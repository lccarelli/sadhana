import 'package:flutter/material.dart';

import '../../core/domain/practice_step.dart';
import '../../core/usecases/session_runner.dart';
import '../../design_system/tokens.dart';
import '../../design_system/typography.dart';
import '../../l10n/l10n_x.dart';

class TimedView extends StatelessWidget {
  const TimedView({super.key, required this.snap});

  final RunnerSnapshot snap;

  @override
  Widget build(BuildContext context) {
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

  static String _mmss(Duration d) {
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$m:$s';
  }
}
