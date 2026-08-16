import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/providers.dart';
import '../../core/domain/breath.dart';
import '../../core/domain/practice_sequence.dart';
import '../../core/domain/practice_step.dart';
import '../../core/usecases/session_runner.dart';
import '../../design_system/tokens.dart';
import '../../design_system/typography.dart';
import '../../design_system/widgets.dart';
import '../../l10n/l10n_x.dart';
import '../journal/journal_entry_screen.dart';
import 'breath_ring.dart';
import 'practice_controller.dart';

/// The screen that decides whether the app is any good.
///
/// It is looked at sideways from a mat, through half-closed eyes. So: no
/// navigation bar, no small controls, enormous type. Tap anywhere to pause,
/// swipe to move between steps.
class PracticeScreen extends ConsumerStatefulWidget {
  const PracticeScreen({super.key, required this.sequence});

  final PracticeSequence sequence;

  @override
  ConsumerState<PracticeScreen> createState() => _PracticeScreenState();
}

class _PracticeScreenState extends ConsumerState<PracticeScreen>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  late final PracticeController _controller;
  late final Ticker _ticker;
  Duration _lastTick = Duration.zero;

  @override
  void initState() {
    super.initState();
    _controller = PracticeController(
      sequence: widget.sequence,
      theme: ref.read(themeControllerProvider),
      recorder: createRecorder(ref),
    );

    // Time is pushed into the domain one frame at a time. The runner itself
    // owns no Timer and never reads the clock, which is what makes a
    // twenty-four minute practice testable in microseconds.
    _ticker = createTicker((elapsed) {
      final delta = elapsed - _lastTick;
      _lastTick = elapsed;
      _controller.advance(delta);
    })..start();

    unawaited(_controller.start());
    WidgetsBinding.instance.addObserver(this);

    // Nobody wants the screen locking mid-savasana.
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
  }

  /// Leaving the app is one of the ways a practice ends, and by far the most
  /// common one. Close the session before the OS gets a chance to kill us.
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached) {
      _controller.pauseForBackground();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _ticker.dispose();
    _controller.dispose();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  /// Leaving before the end. The session closes honestly as partial — those
  /// minutes are practice and they stay in the history.
  ///
  /// No confirmation prompt: someone reaching for the exit mid-practice is
  /// usually being interrupted by something more urgent than this app, and
  /// nothing is lost by leaving.
  Future<void> _leave() async {
    await _controller.finish();
    if (mounted) Navigator.of(context).pop();
  }

  /// Straight into the journal: an entry is worth most while the practice is
  /// still in the body. Replaces rather than pushes, so Back does not land
  /// the practitioner in a finished practice.
  Future<void> _toJournal() async {
    final sessionId = await _controller.finish();
    if (!mounted) return;

    await Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => JournalEntryScreen(
          sessionId: sessionId,
          practised: _controller.snapshot.elapsedTotal,
          angas: widget.sequence.angas,
        ),
      ),
    );
  }

  bool get _isOver => _controller.snapshot.status == RunnerStatus.completed;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;

    return Scaffold(
      backgroundColor: c.ground,
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        // Guarded inside the callbacks rather than by detaching them: build
        // runs once, and the completion happens later inside the
        // AnimatedBuilder, so a captured flag here would be stale.
        //
        // Without this, a stray swipe on the completion screen restarts the
        // runner against a session that has already been closed, and those
        // extra minutes are never recorded.
        onTap: () {
          if (_isOver) return;
          _controller.togglePause();
        },
        onHorizontalDragEnd: (details) {
          if (_isOver) return;
          final v = details.primaryVelocity ?? 0;
          if (v < -200) _controller.skip();
          if (v > 200) _controller.back();
        },
        child: SafeArea(
          child: Stack(
            children: [
              AnimatedBuilder(
                animation: _controller,
                builder: (context, _) => _body(context, _controller.snapshot),
              ),

              // The way out. Muted almost to the ground so it never competes
              // with the practice, but always present — an earlier version had
              // no exit at all, which is fine right up until someone needs to
              // leave. It wins the gesture arena over the tap-to-pause behind
              // it because it is the deeper recognizer.
              Positioned(
                top: 0,
                left: 0,
                child: IconButton(
                  onPressed: _leave,
                  tooltip: context.l.runnerExit,
                  icon: Icon(Icons.close, size: 20, color: c.muted),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _body(BuildContext context, RunnerSnapshot snap) {
    final l = context.l;
    final c = context.colors;

    if (snap.status == RunnerStatus.completed) {
      return _Completed(onClose: _toJournal);
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Space.screen),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _header(context, snap),
          if (snap.isBreathing) _breathing(context, snap) else _timed(context, snap),
          Padding(
            padding: const EdgeInsets.only(bottom: Space.md),
            child: Column(
              children: [
                _steps(context, snap),
                const SizedBox(height: Space.sm),
                MonoLabel(
                  snap.stepIndex + 1 < widget.sequence.steps.length
                      ? l.runnerNext(
                          l.stepTitle(widget.sequence.steps[snap.stepIndex + 1]),
                        )
                      : l.runnerLastStep,
                  align: TextAlign.center,
                ),
                if (snap.status == RunnerStatus.paused) ...[
                  const SizedBox(height: Space.sm),
                  MonoLabel(l.runnerPaused, color: c.ember),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _header(BuildContext context, RunnerSnapshot snap) {
    final l = context.l;
    final anga = snap.step.angas.first;

    return Padding(
      padding: const EdgeInsets.only(top: Space.sm),
      child: Column(
        children: [
          MonoLabel(
            '${l.limbNumber(anga.position)} · ${anga.iast}',
            align: TextAlign.center,
          ),
          const SizedBox(height: 3),
          Text(
            l.stepTitle(snap.step),
            textAlign: TextAlign.center,
            style: AppType.heading.copyWith(color: context.colors.ink),
          ),
        ],
      ),
    );
  }

  Widget _breathing(BuildContext context, RunnerSnapshot snap) {
    final l = context.l;
    final c = context.colors;
    final step = snap.step as BreathStep;
    final phase = snap.breathPhase!;
    final exhaling = phase == BreathPhase.exhale || phase == BreathPhase.holdOut;

    return Column(
      children: [
        BreathRing(
          progress: snap.breathProgress ?? 0,
          expanded: !exhaling,
          exhaling: exhaling,
        ),
        const SizedBox(height: Space.md),
        Text(
          l.breathPhase(phase),
          style: AppType.phase.copyWith(color: c.ink),
        ),
        Text(
          '${snap.breathRemaining}',
          style: AppType.countdown.copyWith(color: c.ink),
        ),
        const SizedBox(height: 7),
        MonoLabel(
          l.runnerCycle(snap.cycle!, snap.totalCycles!, step.pattern.label),
          align: TextAlign.center,
        ),
      ],
    );
  }

  /// Everything that is not breathing: a held posture, a focus, silence, a
  /// reading. One layout, because from the mat they are the same gesture —
  /// stay here until it is time to move.
  Widget _timed(BuildContext context, RunnerSnapshot snap) {
    final l = context.l;
    final c = context.colors;
    final remaining = snap.remainingInStep;
    final side = snap.step is AsanaStep ? (snap.step as AsanaStep).side : null;

    return Column(
      children: [
        SizedBox(
          width: 214,
          height: 214,
          child: Stack(
            alignment: Alignment.center,
            children: [
              CircularProgressIndicator(
                value: snap.stepProgress.clamp(0, 1),
                strokeWidth: 3,
                strokeCap: StrokeCap.round,
                backgroundColor: c.rule,
                valueColor: AlwaysStoppedAnimation(c.accent),
              ),
              Text(
                _mmss(remaining),
                style: AppType.countdown.copyWith(fontSize: 44, color: c.ink),
              ),
            ],
          ),
        ),
        const SizedBox(height: Space.md),
        Text(
          side == null ? l.stepKind(snap.step) : l.side(side),
          style: AppType.phase.copyWith(color: c.ink),
        ),
      ],
    );
  }

  Widget _steps(BuildContext context, RunnerSnapshot snap) {
    final c = context.colors;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (var i = 0; i < widget.sequence.steps.length; i++)
          AnimatedContainer(
            duration: Beat.quarter,
            margin: const EdgeInsets.symmetric(horizontal: 2.5),
            width: i == snap.stepIndex ? 28 : 15,
            height: 2.5,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(2),
              color: i == snap.stepIndex
                  ? c.accent
                  : (i < snap.stepIndex ? c.muted : c.rule),
            ),
          ),
      ],
    );
  }

  static String _mmss(Duration d) {
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$m:$s';
  }
}

class _Completed extends StatelessWidget {
  const _Completed({required this.onClose});
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final l = context.l;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(Space.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Sanskrit('समाधि', size: 34),
            const SizedBox(height: Space.md),
            Text(l.runnerComplete, style: AppType.practiceTitle),
            const SizedBox(height: Space.xl),
            // Straight into the journal: the entry is worth most while the
            // practice is still in the body.
            FilledButton(onPressed: onClose, child: Text(l.journalTitle)),
          ],
        ),
      ),
    );
  }
}
