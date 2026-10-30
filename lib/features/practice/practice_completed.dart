import 'package:flutter/material.dart';

import '../../design_system/tokens.dart';
import '../../design_system/typography.dart';
import '../../design_system/widgets.dart';
import '../../l10n/l10n_x.dart';

class PracticeCompleted extends StatelessWidget {
  const PracticeCompleted({super.key, required this.onClose});
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
            FilledButton(onPressed: onClose, child: Text(l.journalTitle)),
          ],
        ),
      ),
    );
  }
}
