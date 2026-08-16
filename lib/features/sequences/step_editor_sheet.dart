import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/providers.dart';
import '../../core/domain/breath.dart';
import '../../core/domain/practice_step.dart';
import '../../data/corpus/asana_catalogue.dart';
import '../../design_system/tokens.dart';
import '../../design_system/typography.dart';
import '../../design_system/widgets.dart';
import '../../l10n/l10n_x.dart';

/// Edits one step. Returns the edited step, or null if dismissed.
///
/// Every control is a stepper rather than a text field or a slider: a
/// practitioner setting a four-count inhale wants 4, not 4.3, and not to open
/// a keyboard on a mat.
Future<PracticeStep?> showStepEditor(
  BuildContext context, {
  required PracticeStep step,
}) =>
    showModalBottomSheet<PracticeStep>(
      context: context,
      isScrollControlled: true,
      backgroundColor: context.colors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => _StepEditor(initial: step),
    );

class _StepEditor extends ConsumerStatefulWidget {
  const _StepEditor({required this.initial});
  final PracticeStep initial;

  @override
  ConsumerState<_StepEditor> createState() => _StepEditorState();
}

class _StepEditorState extends ConsumerState<_StepEditor> {
  late PracticeStep _step = widget.initial;

  void _set(PracticeStep next) => setState(() => _step = next);

  @override
  Widget build(BuildContext context) {
    final l = context.l;
    final c = context.colors;

    return Padding(
      padding: EdgeInsets.only(
        left: Space.screen,
        right: Space.screen,
        top: Space.md,
        bottom: MediaQuery.of(context).viewInsets.bottom + Space.lg,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              width: 36,
              height: 3,
              decoration: BoxDecoration(
                color: c.rule,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: Space.md),
          MonoLabel(l.stepKindLabel(_step)),
          const SizedBox(height: 4),
          Text(
            l.stepSummary(_step),
            style: AppType.heading.copyWith(color: c.ink),
          ),
          const SizedBox(height: Space.lg),

          ..._controls(context),

          const SizedBox(height: Space.lg),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(_step),
            child: Text(l.editorSave),
          ),
        ],
      ),
    );
  }

  List<Widget> _controls(BuildContext context) {
    final l = context.l;

    return switch (_step) {
      BreathStep(:final pattern, :final cycles) => [
          MonoLabel(l.stepPattern),
          const SizedBox(height: Space.sm),
          Row(
            children: [
              _Counter(
                label: l.breathInhale,
                value: pattern.inhale,
                min: 1,
                onChanged: (v) => _set(
                  BreathStep(
                    pattern: BreathPattern(
                      inhale: v,
                      holdIn: pattern.holdIn,
                      exhale: pattern.exhale,
                      holdOut: pattern.holdOut,
                    ),
                    cycles: cycles,
                  ),
                ),
              ),
              _Counter(
                label: l.breathHoldIn,
                value: pattern.holdIn,
                onChanged: (v) => _set(
                  BreathStep(
                    pattern: BreathPattern(
                      inhale: pattern.inhale,
                      holdIn: v,
                      exhale: pattern.exhale,
                      holdOut: pattern.holdOut,
                    ),
                    cycles: cycles,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: Space.sm),
          Row(
            children: [
              _Counter(
                label: l.breathExhale,
                value: pattern.exhale,
                min: 1,
                onChanged: (v) => _set(
                  BreathStep(
                    pattern: BreathPattern(
                      inhale: pattern.inhale,
                      holdIn: pattern.holdIn,
                      exhale: v,
                      holdOut: pattern.holdOut,
                    ),
                    cycles: cycles,
                  ),
                ),
              ),
              _Counter(
                label: l.breathHoldOut,
                value: pattern.holdOut,
                onChanged: (v) => _set(
                  BreathStep(
                    pattern: BreathPattern(
                      inhale: pattern.inhale,
                      holdIn: pattern.holdIn,
                      exhale: pattern.exhale,
                      holdOut: v,
                    ),
                    cycles: cycles,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: Space.md),
          MonoLabel(l.stepCycles),
          const SizedBox(height: Space.sm),
          Row(
            children: [
              _Counter(
                label: l.stepCycles,
                value: cycles,
                min: 1,
                max: 108, // a mala, and nobody is doing more than that
                onChanged: (v) => _set(BreathStep(pattern: pattern, cycles: v)),
              ),
            ],
          ),
        ],
      AsanaStep(:final asanaId, :final hold, :final side) => [
          MonoLabel(l.stepPosture),
          const SizedBox(height: 6),
          // Picked from the catalogue, not typed. A free-text field produced
          // ids nothing else could resolve — the runner had no name to show
          // and the anatomy screen had no figure to draw.
          _AsanaPicker(
            selected: asanaId,
            onChanged: (v) =>
                _set(AsanaStep(asanaId: v, hold: hold, side: side)),
          ),
          const SizedBox(height: Space.md),
          _DurationRow(
            label: l.stepDuration,
            value: hold,
            step: const Duration(seconds: 15),
            min: const Duration(seconds: 15),
            onChanged: (v) =>
                _set(AsanaStep(asanaId: asanaId, hold: v, side: side)),
          ),
          const SizedBox(height: Space.md),
          MonoLabel(l.stepSide),
          const SizedBox(height: Space.sm),
          SegmentedButton<BodySide?>(
            showSelectedIcon: false,
            segments: [
              ButtonSegment(value: null, label: Text(l.stepSideBoth)),
              ButtonSegment(
                value: BodySide.left,
                label: Text(l.runnerSideLeft),
              ),
              ButtonSegment(
                value: BodySide.right,
                label: Text(l.runnerSideRight),
              ),
            ],
            selected: {side},
            onSelectionChanged: (s) => _set(
              AsanaStep(asanaId: asanaId, hold: hold, side: s.first),
            ),
          ),
        ],
      FocusStep(:final object, :final duration) => [
          MonoLabel(l.stepFocusObject),
          const SizedBox(height: 6),
          TextFormField(
            initialValue: l.stepSummary(_step).split(' · ').first,
            style: AppType.uiBody.copyWith(color: context.colors.ink),
            decoration: const InputDecoration(isDense: true),
            onChanged: (v) => _set(FocusStep(object: v, duration: duration)),
          ),
          const SizedBox(height: Space.md),
          _DurationRow(
            label: l.stepDuration,
            value: duration,
            step: const Duration(minutes: 1),
            min: const Duration(minutes: 1),
            onChanged: (v) => _set(FocusStep(object: object, duration: v)),
          ),
        ],
      SilenceStep(:final duration) => [
          _DurationRow(
            label: l.stepDuration,
            value: duration,
            step: const Duration(minutes: 1),
            min: const Duration(minutes: 1),
            onChanged: (v) => _set(SilenceStep(duration: v)),
          ),
        ],
      ReadingStep(:final textId, :final duration) => [
          MonoLabel(l.stepText),
          const SizedBox(height: 6),
          _TextPicker(
            selected: textId,
            onChanged: (v) => _set(ReadingStep(textId: v, duration: duration)),
          ),
          const SizedBox(height: Space.md),
          _DurationRow(
            label: l.stepDuration,
            value: duration,
            step: const Duration(minutes: 1),
            min: const Duration(minutes: 1),
            onChanged: (v) => _set(ReadingStep(textId: textId, duration: v)),
          ),
        ],
    };
  }
}

class _AsanaPicker extends StatelessWidget {
  const _AsanaPicker({required this.selected, required this.onChanged});

  final String selected;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final l = context.l;
    final c = context.colors;
    final ids = AsanaCatalogue.asanas.map((a) => a.id).toList();

    return DropdownButtonFormField<String>(
      initialValue: ids.contains(selected) ? selected : ids.first,
      isExpanded: true,
      decoration: const InputDecoration(isDense: true),
      style: AppType.uiBody.copyWith(color: c.ink),
      items: [
        for (final asana in AsanaCatalogue.asanas)
          DropdownMenuItem(
            value: asana.id,
            child: Text(
              '${l.asanaName(asana.id)} · ${asana.iast}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
      ],
      onChanged: (v) => v == null ? null : onChanged(v),
    );
  }
}

/// Picks a verse from the corpus. The one place the editor reaches across into
/// the library half of the app.
class _TextPicker extends ConsumerWidget {
  const _TextPicker({required this.selected, required this.onChanged});

  final String selected;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;
    final code = ref.watch(
      localeCodeProvider(Localizations.localeOf(context)),
    );
    final texts =
        ref.watch(workProvider((workId: 'ys', locale: code))).valueOrNull ??
            const [];

    if (texts.isEmpty) return const SizedBox.shrink();

    final ids = texts.map((t) => t.text.id).toList();

    return DropdownButtonFormField<String>(
      initialValue: ids.contains(selected) ? selected : ids.first,
      isExpanded: true,
      decoration: const InputDecoration(isDense: true),
      style: AppType.uiBody.copyWith(color: c.ink),
      items: [
        for (final item in texts)
          DropdownMenuItem(
            value: item.text.id,
            child: Text(
              '${item.text.reference} · ${item.translation.body}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
      ],
      onChanged: (v) => v == null ? null : onChanged(v),
    );
  }
}

class _DurationRow extends StatelessWidget {
  const _DurationRow({
    required this.label,
    required this.value,
    required this.step,
    required this.min,
    required this.onChanged,
  });

  final String label;
  final Duration value;
  final Duration step;
  final Duration min;
  final ValueChanged<Duration> onChanged;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;

    return Row(
      children: [
        Expanded(child: MonoLabel(label)),
        _Nudge(
          icon: Icons.remove,
          enabled: value - step >= min,
          onTap: () => onChanged(value - step),
        ),
        SizedBox(
          width: 76,
          child: Text(
            '${value.inMinutes}:'
            '${value.inSeconds.remainder(60).toString().padLeft(2, '0')}',
            textAlign: TextAlign.center,
            style: AppType.numeric.copyWith(fontSize: 19, color: c.ink),
          ),
        ),
        _Nudge(icon: Icons.add, onTap: () => onChanged(value + step)),
      ],
    );
  }
}

class _Counter extends StatelessWidget {
  const _Counter({
    required this.label,
    required this.value,
    required this.onChanged,
    this.min = 0,
    this.max = 60,
  });

  final String label;
  final int value;
  final int min;
  final int max;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;

    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MonoLabel(label),
          const SizedBox(height: 4),
          Row(
            children: [
              _Nudge(
                icon: Icons.remove,
                enabled: value > min,
                onTap: () => onChanged(value - 1),
              ),
              SizedBox(
                width: 38,
                child: Text(
                  '$value',
                  textAlign: TextAlign.center,
                  style: AppType.numeric.copyWith(fontSize: 19, color: c.ink),
                ),
              ),
              _Nudge(
                icon: Icons.add,
                enabled: value < max,
                onTap: () => onChanged(value + 1),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Nudge extends StatelessWidget {
  const _Nudge({required this.icon, required this.onTap, this.enabled = true});

  final IconData icon;
  final VoidCallback onTap;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return IconButton(
      onPressed: enabled ? onTap : null,
      visualDensity: VisualDensity.compact,
      icon: Icon(icon, size: 18, color: enabled ? c.accent : c.rule),
    );
  }
}
