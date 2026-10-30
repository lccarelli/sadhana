import 'package:flutter/material.dart';

import '../../core/domain/practice_sequence.dart';
import '../../core/usecases/session_runner.dart';
import '../../design_system/tokens.dart';
import 'breathing_view.dart';
import 'practice_completed.dart';
import 'practice_footer.dart';
import 'step_header.dart';
import 'timed_view.dart';

class PracticeBody extends StatelessWidget {
  const PracticeBody({
    super.key,
    required this.snap,
    required this.sequence,
    required this.onComplete,
  });

  final RunnerSnapshot snap;
  final PracticeSequence sequence;
  final VoidCallback onComplete;

  @override
  Widget build(BuildContext context) {
    if (snap.status == RunnerStatus.completed) {
      return PracticeCompleted(onClose: onComplete);
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Space.screen),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          StepHeader(snap: snap),
          if (snap.isBreathing)
            BreathingView(snap: snap)
          else
            TimedView(snap: snap),
          PracticeFooter(snap: snap, sequence: sequence),
        ],
      ),
    );
  }
}
