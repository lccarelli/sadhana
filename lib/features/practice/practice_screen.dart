import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/providers.dart';
import '../../core/domain/practice_sequence.dart';
import '../../core/usecases/session_runner.dart';
import '../../design_system/tokens.dart';
import '../journal/journal_entry_screen.dart';
import 'practice_body.dart';
import 'practice_controller.dart';
import 'practice_exit_button.dart';

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

    _ticker = createTicker((elapsed) {
      final delta = elapsed - _lastTick;
      _lastTick = elapsed;
      _controller.advance(delta);
    })..start();

    unawaited(_controller.start());
    WidgetsBinding.instance.addObserver(this);

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
  }

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

  Future<void> _leave() async {
    await _controller.finish();
    if (mounted) Navigator.of(context).pop();
  }

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

  void _swipe(DragEndDetails details) {
    final velocity = details.primaryVelocity ?? 0;
    if (velocity < -200) _controller.skip();
    if (velocity > 200) _controller.back();
  }

  bool get _isOver => _controller.snapshot.status == RunnerStatus.completed;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;

    return Scaffold(
      backgroundColor: c.ground,
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => _isOver ? null : _controller.togglePause(),
        onHorizontalDragEnd: (details) => _isOver ? null : _swipe(details),
        child: SafeArea(
          child: Stack(
            children: [
              AnimatedBuilder(
                animation: _controller,
                builder: (context, _) => PracticeBody(
                  snap: _controller.snapshot,
                  sequence: widget.sequence,
                  onComplete: _toJournal,
                ),
              ),

              PracticeExitButton(onPressed: _leave),
            ],
          ),
        ),
      ),
    );
  }
}
