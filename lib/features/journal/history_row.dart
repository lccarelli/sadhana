import 'package:flutter/material.dart';

import '../../data/sadhana/database.dart';
import '../../design_system/tokens.dart';
import '../../design_system/typography.dart';
import '../../design_system/widgets.dart';
import '../../l10n/l10n_x.dart';

class HistoryRow extends StatelessWidget {
  const HistoryRow({super.key, required this.entry});

  final PractisedSession entry;

  @override
  Widget build(BuildContext context) {
    final l = context.l;
    final c = context.colors;
    final material = MaterialLocalizations.of(context);
    final session = entry.session;

    final percent = session.plannedSeconds == 0
        ? 100
        : (session.practisedSeconds * 100 / session.plannedSeconds).round();

    return Padding(
      padding: const EdgeInsets.only(bottom: Space.md),
      child: Hanging(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Expanded(
                  child: MonoLabel(
                    '${material.formatMediumDate(session.startedAt)} · '
                    '${material.formatTimeOfDay(TimeOfDay.fromDateTime(session.startedAt))}',
                  ),
                ),
                Text(
                  l.journalMinutes(entry.practised.inMinutes),
                  style: AppType.numeric.copyWith(
                    fontSize: 12.5,
                    color: session.completed ? c.accent : c.muted,
                  ),
                ),
              ],
            ),

            if (!session.completed) ...[
              const SizedBox(height: 3),
              Text(
                l.journalPartial(percent.clamp(0, 100)),
                style: AppType.uiBody.copyWith(fontSize: 12, color: c.muted),
              ),
            ],

            if (entry.journal case final journal?) ...[
              if (journal.sthira != null || journal.sukha != null) ...[
                const SizedBox(height: 9),
                Row(
                  children: [
                    if (journal.sthira case final v?)
                      _Pips(label: l.journalSthira, value: v),
                    if (journal.sukha case final v?) ...[
                      const SizedBox(width: Space.md),
                      _Pips(label: l.journalSukha, value: v),
                    ],
                  ],
                ),
              ],
              const SizedBox(height: 8),
              Text(
                entry.hasNote ? journal.note : l.journalNoNote,
                style: AppType.readingBody.copyWith(
                  fontSize: 14,
                  color: entry.hasNote ? c.ink : c.muted,
                  fontStyle: entry.hasNote
                      ? FontStyle.normal
                      : FontStyle.italic,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _Pips extends StatelessWidget {
  const _Pips({required this.label, required this.value});

  final String label;
  final int value;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final short = label.split('—').last.trim();

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        MonoLabel(short),
        const SizedBox(width: 6),
        for (var i = 1; i <= 5; i++)
          Container(
            width: 5,
            height: 5,
            margin: const EdgeInsets.only(right: 3),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: i <= value ? c.accent : c.rule,
            ),
          ),
      ],
    );
  }
}
