import 'package:flutter/material.dart';

import '../../core/usecases/session_runner.dart';
import '../../design_system/tokens.dart';
import '../../design_system/widgets.dart';
import '../../l10n/l10n_x.dart';
import '../../core/domain/practice_sequence.dart';
import 'step_progress.dart';

class PracticeFooter extends StatelessWidget {
  const PracticeFooter({super.key, required this.snap, required this.sequence});

  final RunnerSnapshot snap;
  final PracticeSequence sequence;

  @override
  Widget build(BuildContext context) {
    final l = context.l;
    final c = context.colors;

    return Padding(
      padding: const EdgeInsets.only(bottom: Space.md),
      child: Column(
        children: [
          StepProgress(count: sequence.steps.length, current: snap.stepIndex),
          const SizedBox(height: Space.sm),
          MonoLabel(
            snap.stepIndex + 1 < sequence.steps.length
                ? l.runnerNext(l.stepTitle(sequence.steps[snap.stepIndex + 1]))
                : l.runnerLastStep,
            align: TextAlign.center,
          ),
          if (snap.status == RunnerStatus.paused) ...[
            const SizedBox(height: Space.sm),
            MonoLabel(l.runnerPaused, color: c.ember),
          ],
        ],
      ),
    );
  }
}
