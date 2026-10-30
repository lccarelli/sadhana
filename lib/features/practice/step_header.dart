import 'package:flutter/material.dart';

import '../../core/usecases/session_runner.dart';
import '../../design_system/tokens.dart';
import '../../design_system/typography.dart';
import '../../design_system/widgets.dart';
import '../../l10n/l10n_x.dart';

class StepHeader extends StatelessWidget {
  const StepHeader({super.key, required this.snap});

  final RunnerSnapshot snap;

  @override
  Widget build(BuildContext context) {
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
}
