import 'package:flutter/material.dart';

import '../../core/domain/breath.dart';
import '../../core/domain/practice_step.dart';
import '../../core/usecases/session_runner.dart';
import '../../design_system/tokens.dart';
import '../../design_system/typography.dart';
import '../../design_system/widgets.dart';
import '../../l10n/l10n_x.dart';
import 'breath_ring.dart';

class BreathingView extends StatelessWidget {
  const BreathingView({super.key, required this.snap});

  final RunnerSnapshot snap;

  @override
  Widget build(BuildContext context) {
    final l = context.l;
    final c = context.colors;
    final step = snap.step as BreathStep;
    final phase = snap.breathPhase!;
    final exhaling =
        phase == BreathPhase.exhale || phase == BreathPhase.holdOut;

    return Column(
      children: [
        BreathRing(
          progress: snap.breathProgress ?? 0,
          expanded: !exhaling,
          exhaling: exhaling,
        ),
        const SizedBox(height: Space.md),
        Text(l.breathPhase(phase), style: AppType.phase.copyWith(color: c.ink)),
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
}
