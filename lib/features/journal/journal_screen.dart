import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/providers.dart';
import '../../data/sadhana/database.dart';
import '../../design_system/tokens.dart';
import '../../design_system/typography.dart';
import '../../design_system/widgets.dart';
import '../../l10n/l10n_x.dart';

/// Practice history. Every session that ended — completed or abandoned —
/// with whatever was written about it.
///
/// Abandoned practices are shown, not hidden. Eight minutes on a bad morning
/// is practice; an app that only counts clean finishes teaches people to
/// avoid starting.
class JournalScreen extends ConsumerWidget {
  const JournalScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l;
    final c = context.colors;
    final history = ref.watch(historyProvider);

    return Scaffold(
      appBar: AppBar(title: MonoLabel(l.navJournal)),
      body: history.when(
        loading: () => const SizedBox.shrink(),
        error: (e, _) => Center(child: Text('$e')),
        data: (sessions) {
          if (sessions.isEmpty) return const _Empty();

          final totalSeconds = sessions.fold<int>(
            0,
            (sum, s) => sum + s.session.practisedSeconds,
          );

          return ListView(
            padding: const EdgeInsets.fromLTRB(
              Space.screen,
              0,
              Space.screen,
              Space.xl,
            ),
            children: [
              Text(
                l.journalHistory,
                style: AppType.practiceTitle.copyWith(color: c.ink),
              ),
              const SizedBox(height: 6),
              Text(
                l.journalTotalPractices(
                  sessions.length,
                  (totalSeconds / 3600).toStringAsFixed(1),
                ),
                style: AppType.uiBody.copyWith(fontSize: 12.5, color: c.muted),
              ),
              const SizedBox(height: Space.lg),
              for (final entry in sessions) _HistoryRow(entry: entry),
            ],
          );
        },
      ),
    );
  }
}

class _Empty extends StatelessWidget {
  const _Empty();

  @override
  Widget build(BuildContext context) {
    final l = context.l;
    final c = context.colors;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(Space.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              l.journalEmpty,
              textAlign: TextAlign.center,
              style: AppType.heading.copyWith(color: c.ink2),
            ),
            const SizedBox(height: Space.sm),
            Text(
              l.journalEmptyDetail,
              textAlign: TextAlign.center,
              style: AppType.uiBody.copyWith(fontSize: 13.5, color: c.muted),
            ),
          ],
        ),
      ),
    );
  }
}

class _HistoryRow extends StatelessWidget {
  const _HistoryRow({required this.entry});

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

            // An abandoned practice reads as "62% of the practice", never as a
            // failure state. The colour stays neutral for the same reason.
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
                  fontStyle: entry.hasNote ? FontStyle.normal : FontStyle.italic,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// The two scales, rendered small enough to scan a month of them at once.
class _Pips extends StatelessWidget {
  const _Pips({required this.label, required this.value});

  final String label;
  final int value;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    // "Steadiness — sthira" is too long here; the sanskrit half identifies it.
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
