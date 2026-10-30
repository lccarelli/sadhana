import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/providers.dart';
import '../../core/domain/practice_sequence.dart';
import '../../design_system/tokens.dart';
import '../../design_system/typography.dart';
import '../../design_system/widgets.dart';
import '../../l10n/l10n_x.dart';
import 'sequence_actions_menu.dart';

class SequenceTile extends ConsumerWidget {
  const SequenceTile({
    super.key,
    required this.sequence,
    required this.isSelected,
  });

  final PracticeSequence sequence;
  final bool isSelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l;
    final c = context.colors;

    return InkWell(
      onTap: () {
        ref.read(selectedSequenceIdProvider.notifier).state = sequence.id;
        Navigator.of(context).pop();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 13),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: c.rule)),
        ),
        child: Row(
          children: [
            SizedBox(
              width: 26,
              child: isSelected
                  ? Icon(Icons.check, size: 16, color: c.accent)
                  : null,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l.sequenceTitle(sequence),
                    style: AppType.heading.copyWith(
                      fontSize: 17,
                      color: isSelected ? c.accent : c.ink,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    l.editorTotal(
                      sequence.steps.length,
                      sequence.duration.inMinutes,
                    ),
                    style: AppType.uiBody.copyWith(
                      fontSize: 12.5,
                      color: c.muted,
                    ),
                  ),
                  const SizedBox(height: 7),
                  Wrap(
                    spacing: 5,
                    runSpacing: 5,
                    children: [
                      for (final anga in sequence.angas) AngaChip(anga.iast),
                    ],
                  ),
                ],
              ),
            ),
            SequenceActionsMenu(sequence: sequence),
          ],
        ),
      ),
    );
  }
}
