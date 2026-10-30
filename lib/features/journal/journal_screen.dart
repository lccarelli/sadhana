import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/providers.dart';
import '../../design_system/tokens.dart';
import '../../design_system/typography.dart';
import '../../design_system/widgets.dart';
import '../../l10n/l10n_x.dart';
import 'history_row.dart';
import 'journal_empty.dart';

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
          if (sessions.isEmpty) return const JournalEmpty();

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
              for (final entry in sessions) HistoryRow(entry: entry),
            ],
          );
        },
      ),
    );
  }
}
