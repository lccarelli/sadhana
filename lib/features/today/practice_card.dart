import 'package:flutter/material.dart';

import '../../core/domain/practice_sequence.dart';
import '../../design_system/tokens.dart';
import '../../design_system/typography.dart';
import '../../design_system/widgets.dart';
import '../../l10n/l10n_x.dart';
import '../practice/practice_screen.dart';
import '../sequences/sequence_list_screen.dart';

class PracticeCard extends StatelessWidget {
  const PracticeCard({super.key, required this.sequence});

  final PracticeSequence sequence;

  @override
  Widget build(BuildContext context) {
    final l = context.l;
    final c = context.colors;

    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => const SequenceListScreen(),
              ),
            ),
            child: Row(
              children: [
                Expanded(child: MonoLabel(l.todaySavedSequence)),
                Text(
                  l.sequencesChoose,
                  style: AppType.label.copyWith(color: c.accent),
                ),
                Icon(Icons.chevron_right, size: 15, color: c.accent),
              ],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            l.sequenceTitle(sequence),
            style: AppType.heading.copyWith(color: c.ink),
          ),
          const SizedBox(height: 7),
          Text(
            l.todayStepsAndTime(
              sequence.steps.length,
              sequence.duration.inMinutes,
            ),
            style: AppType.uiBody.copyWith(fontSize: 12, color: c.muted),
          ),
          const SizedBox(height: 11),
          Wrap(
            spacing: 5,
            runSpacing: 5,
            children: [
              for (final anga in sequence.angas)
                AngaChip(anga.iast, active: true),
            ],
          ),
          const SizedBox(height: Space.md),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => PracticeScreen(sequence: sequence),
                ),
              ),
              child: Text(l.todayStart),
            ),
          ),
        ],
      ),
    );
  }
}
