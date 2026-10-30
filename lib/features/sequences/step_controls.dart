import 'package:flutter/material.dart';

import '../../core/domain/practice_step.dart';
import '../../design_system/tokens.dart';
import '../../design_system/typography.dart';
import '../../design_system/widgets.dart';
import '../../l10n/l10n_x.dart';
import 'breath_controls.dart';
import 'step_pickers.dart';
import 'steppers.dart';

class StepControls extends StatelessWidget {
  const StepControls({super.key, required this.step, required this.onChanged});

  final PracticeStep step;
  final ValueChanged<PracticeStep> onChanged;

  static const _minuteStep = Duration(minutes: 1);

  @override
  Widget build(BuildContext context) {
    final l = context.l;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: switch (step) {
        BreathStep step => [BreathControls(step: step, onChanged: onChanged)],
        AsanaStep(:final asanaId, :final hold, :final side) => [
          MonoLabel(l.stepPosture),
          const SizedBox(height: 6),
          AsanaPicker(
            selected: asanaId,
            onChanged: (v) =>
                onChanged(AsanaStep(asanaId: v, hold: hold, side: side)),
          ),
          const SizedBox(height: Space.md),
          DurationRow(
            label: l.stepDuration,
            value: hold,
            step: const Duration(seconds: 15),
            min: const Duration(seconds: 15),
            onChanged: (v) =>
                onChanged(AsanaStep(asanaId: asanaId, hold: v, side: side)),
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
            onSelectionChanged: (s) => onChanged(
              AsanaStep(asanaId: asanaId, hold: hold, side: s.first),
            ),
          ),
        ],
        FocusStep(:final object, :final duration) => [
          MonoLabel(l.stepFocusObject),
          const SizedBox(height: 6),
          TextFormField(
            initialValue: l.stepSummary(step).split(' · ').first,
            style: AppType.uiBody.copyWith(color: context.colors.ink),
            decoration: const InputDecoration(isDense: true),
            onChanged: (v) =>
                onChanged(FocusStep(object: v, duration: duration)),
          ),
          const SizedBox(height: Space.md),
          DurationRow(
            label: l.stepDuration,
            value: duration,
            step: _minuteStep,
            min: _minuteStep,
            onChanged: (v) => onChanged(FocusStep(object: object, duration: v)),
          ),
        ],
        SilenceStep(:final duration) => [
          DurationRow(
            label: l.stepDuration,
            value: duration,
            step: _minuteStep,
            min: _minuteStep,
            onChanged: (v) => onChanged(SilenceStep(duration: v)),
          ),
        ],
        ReadingStep(:final textId, :final duration) => [
          MonoLabel(l.stepText),
          const SizedBox(height: 6),
          TextPicker(
            selected: textId,
            onChanged: (v) =>
                onChanged(ReadingStep(textId: v, duration: duration)),
          ),
          const SizedBox(height: Space.md),
          DurationRow(
            label: l.stepDuration,
            value: duration,
            step: _minuteStep,
            min: _minuteStep,
            onChanged: (v) =>
                onChanged(ReadingStep(textId: textId, duration: v)),
          ),
        ],
      },
    );
  }
}
