import 'package:drift/drift.dart';

import 'database.dart';

extension PracticeReads on SadhanaDatabase {
  Future<int> encounterCount(String textId) async {
    final count = textEncounters.id.count();
    final row =
        await (selectOnly(textEncounters)
              ..addColumns([count])
              ..where(textEncounters.textId.equals(textId)))
            .getSingle();
    return row.read(count) ?? 0;
  }

  Stream<Map<String, int>> watchEncounterCounts() {
    final count = textEncounters.id.count();
    final query = selectOnly(textEncounters)
      ..addColumns([textEncounters.textId, count])
      ..groupBy([textEncounters.textId]);

    return query.watch().map(
      (rows) => {
        for (final row in rows)
          row.read(textEncounters.textId)!: row.read(count) ?? 0,
      },
    );
  }

  Stream<List<int>> watchContinuity({required DateTime today, int days = 14}) {
    final from = DateTime(
      today.year,
      today.month,
      today.day,
    ).subtract(Duration(days: days - 1));

    return (select(sessions)
          ..where((s) => s.startedAt.isBiggerOrEqualValue(from)))
        .watch()
        .map((rows) => _bucketByDay(rows, from, days));
  }

  Future<List<int>> continuity({required DateTime today, int days = 14}) async {
    final from = DateTime(
      today.year,
      today.month,
      today.day,
    ).subtract(Duration(days: days - 1));
    final rows = await (select(
      sessions,
    )..where((s) => s.startedAt.isBiggerOrEqualValue(from))).get();
    return _bucketByDay(rows, from, days);
  }

  List<int> _bucketByDay(List<Session> rows, DateTime from, int days) {
    final perDay = List<int>.filled(days, 0);
    for (final s in rows) {
      final index = DateTime(
        s.startedAt.year,
        s.startedAt.month,
        s.startedAt.day,
      ).difference(from).inDays;
      if (index >= 0 && index < days) perDay[index] += s.practisedSeconds;
    }
    return perDay;
  }

  Stream<List<PractisedSession>> watchHistory({int limit = 60}) {
    final query =
        select(sessions).join([
            leftOuterJoin(
              journalEntries,
              journalEntries.sessionId.equalsExp(sessions.id),
            ),
          ])
          ..where(sessions.endedAt.isNotNull())
          ..orderBy([OrderingTerm.desc(sessions.startedAt)])
          ..limit(limit);

    return query.watch().map(
      (rows) => rows
          .map(
            (row) => PractisedSession(
              session: row.readTable(sessions),
              journal: row.readTableOrNull(journalEntries),
            ),
          )
          .toList(),
    );
  }
}

class PractisedSession {
  const PractisedSession({required this.session, this.journal});

  final Session session;
  final JournalEntry? journal;

  Duration get practised => Duration(seconds: session.practisedSeconds);
  bool get hasNote => (journal?.note ?? '').trim().isNotEmpty;
}
