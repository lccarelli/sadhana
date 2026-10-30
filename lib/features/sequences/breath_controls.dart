import 'package:flutter/material.dart';

import '../../core/domain/breath.dart';
import '../../core/domain/practice_step.dart';
import '../../design_system/tokens.dart';
import '../../design_system/widgets.dart';
import '../../l10n/l10n_x.dart';
import 'steppers.dart';

class BreathControls extends StatelessWidget {
  const BreathControls({
    super.key,
    required this.step,
    required this.onChanged,
  });

  final BreathStep step;
  final ValueChanged<PracticeStep> onChanged;

  static const _rows = [
    [BreathPhase.inhale, BreathPhase.holdIn],
    [BreathPhase.exhale, BreathPhase.holdOut],
  ];

  static const _alwaysPresent = {BreathPhase.inhale, BreathPhase.exhale};

  @override
  Widget build(BuildContext context) {
    final l = context.l;
    final pattern = step.pattern;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        MonoLabel(l.stepPattern),
        for (final row in _rows) ...[
          const SizedBox(height: Space.sm),
          Row(
            children: [
              for (final phase in row)
                Counter(
                  label: l.breathPhase(phase),
                  value: pattern.secondsOf(phase),
                  min: _alwaysPresent.contains(phase) ? 1 : 0,
                  onChanged: (v) => onChanged(
                    BreathStep(
                      pattern: pattern.withPhase(phase, v),
                      cycles: step.cycles,
                    ),
                  ),
                ),
            ],
          ),
        ],
        const SizedBox(height: Space.md),
        MonoLabel(l.stepCycles),
        const SizedBox(height: Space.sm),
        Row(
          children: [
            Counter(
              label: l.stepCycles,
              value: step.cycles,
              min: 1,
              max: 108,
              onChanged: (v) =>
                  onChanged(BreathStep(pattern: pattern, cycles: v)),
            ),
          ],
        ),
      ],
    );
  }
}
