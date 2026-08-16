import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'database.g.dart';

/// One completed (or abandoned) practice.
class Sessions extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get sequenceId => text()();
  DateTimeColumn get startedAt => dateTime()();
  DateTimeColumn get endedAt => dateTime().nullable()();

  /// What the sequence asked for, versus what actually happened. The gap is
  /// interesting on its own — it is where skipping shows up.
  IntColumn get plannedSeconds => integer()();
  IntColumn get practisedSeconds => integer().withDefault(const Constant(0))();
  BoolColumn get completed => boolean().withDefault(const Constant(false))();
}

/// The most intimate data in the system. Never leaves the device without an
/// explicit, revocable act of consent.
class JournalEntries extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get sessionId => integer().nullable().references(Sessions, #id)();
  DateTimeColumn get createdAt => dateTime()();

  /// Sthira and sukha, 1–5, from Yoga Sutra II.46. Not stars, not emoji:
  /// the tradition already had the right two axes.
  IntColumn get sthira => integer().nullable()();
  IntColumn get sukha => integer().nullable()();

  TextColumn get note => text().withDefault(const Constant(''))();

  /// Comma-separated anga names, denormalised on purpose — this is read far
  /// more often than written, and a join table for five tags is overkill.
  TextColumn get angas => text().withDefault(const Constant(''))();
}

/// A note the practitioner made on a corpus text.
class TextAnnotations extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get textId => text()();
  TextColumn get note => text()();
  DateTimeColumn get createdAt => dateTime()();
}

/// Every time a text was met inside a practice, not just read in the library.
/// This is what the "Practiced ×3" chip counts, and it is the only real
/// bridge between the two halves of the app.
class TextEncounters extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get textId => text()();
  IntColumn get sessionId => integer().nullable().references(Sessions, #id)();
  DateTimeColumn get at => dateTime()();
}

/// A practice the practitioner composed. Seeded practices stay in code — see
/// [PracticeSequence.slowMorning] — so they can be improved in a release
/// without rewriting anyone's rows. Editing a seeded one duplicates it here.
class SequenceRows extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  /// The seeded sequence id this was duplicated from, if any. Kept for
  /// provenance, never for behaviour — a copy is fully independent.
  TextColumn get derivedFrom => text().nullable()();
}

/// One step of a stored sequence.
///
/// Sparse on purpose: each step kind fills a disjoint subset of these columns.
/// The alternative — a JSON blob — would be tidier to look at and impossible
/// to query, and "every practice that includes trikonasana" is a question this
/// app will want to answer. The sparseness is confined to [StepCodec]; nothing
/// else ever touches these columns directly.
class StepRows extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get sequenceId => integer()();
  IntColumn get position => integer()();
  TextColumn get kind => text()();

  /// Timed steps: focus, silence, reading, and an asana's hold.
  IntColumn get durationSeconds => integer().nullable()();

  // Breath
  IntColumn get breathIn => integer().nullable()();
  IntColumn get breathHoldIn => integer().nullable()();
  IntColumn get breathOut => integer().nullable()();
  IntColumn get breathHoldOut => integer().nullable()();
  IntColumn get cycles => integer().nullable()();

  // Asana
  TextColumn get asanaId => text().nullable()();
  TextColumn get side => text().nullable()();

  // Focus / reading
  TextColumn get focusObject => text().nullable()();
  TextColumn get textId => text().nullable()();
}

@DriftDatabase(
  tables: [
    Sessions,
    JournalEntries,
    TextAnnotations,
    TextEncounters,
    SequenceRows,
    StepRows,
  ],
)
class SadhanaDatabase extends _$SadhanaDatabase {
  /// Pass an executor in tests (`NativeDatabase.memory()`); production uses
  /// the on-device file.
  SadhanaDatabase([QueryExecutor? executor])
      : super(executor ?? driftDatabase(name: 'sadhana'));

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) => m.createAll(),
        onUpgrade: (m, from, to) async {
          // v2 — practitioners can compose their own sequences.
          if (from < 2) {
            await m.createTable(sequenceRows);
            await m.createTable(stepRows);
          }
        },
      );

  // ------------------------------------------------------------- sequences

  /// Sequences with their steps, ordered. A single query for the steps rather
  /// than one per sequence, because the picker shows all of them at once.
  Stream<List<StoredSequence>> watchSequences() {
    final sequences = (select(sequenceRows)
          ..orderBy([(s) => OrderingTerm.desc(s.updatedAt)]))
        .watch();

    return sequences.asyncMap((rows) async {
      if (rows.isEmpty) return const <StoredSequence>[];

      final ids = rows.map((r) => r.id).toList();
      final steps = await (select(stepRows)
            ..where((s) => s.sequenceId.isIn(ids))
            ..orderBy([(s) => OrderingTerm.asc(s.position)]))
          .get();

      final bySequence = <int, List<StepRow>>{};
      for (final step in steps) {
        bySequence.putIfAbsent(step.sequenceId, () => []).add(step);
      }

      return [
        for (final row in rows)
          StoredSequence(row: row, steps: bySequence[row.id] ?? const []),
      ];
    });
  }

  Future<StoredSequence?> sequenceById(int id) async {
    final row = await (select(sequenceRows)..where((s) => s.id.equals(id)))
        .getSingleOrNull();
    if (row == null) return null;

    final steps = await (select(stepRows)
          ..where((s) => s.sequenceId.equals(id))
          ..orderBy([(s) => OrderingTerm.asc(s.position)]))
        .get();

    return StoredSequence(row: row, steps: steps);
  }

  /// Insert or replace a sequence and all of its steps atomically.
  ///
  /// Steps are deleted and rewritten rather than diffed: reordering renumbers
  /// most of them anyway, and a half-applied edit would leave a practice with
  /// two step threes.
  Future<int> saveSequence({
    int? id,
    required String title,
    required DateTime at,
    String? derivedFrom,
    required List<StepRowsCompanion> Function(int sequenceId) steps,
  }) =>
      transaction(() async {
        final sequenceId = id ??
            await into(sequenceRows).insert(
              SequenceRowsCompanion.insert(
                title: title,
                createdAt: at,
                updatedAt: at,
                derivedFrom: Value(derivedFrom),
              ),
            );

        if (id != null) {
          await (update(sequenceRows)..where((s) => s.id.equals(id))).write(
            SequenceRowsCompanion(title: Value(title), updatedAt: Value(at)),
          );
          await (delete(stepRows)..where((s) => s.sequenceId.equals(id))).go();
        }

        await batch((b) => b.insertAll(stepRows, steps(sequenceId)));
        return sequenceId;
      });

  Future<void> deleteSequence(int id) => transaction(() async {
        await (delete(stepRows)..where((s) => s.sequenceId.equals(id))).go();
        await (delete(sequenceRows)..where((s) => s.id.equals(id))).go();
      });

  // ---------------------------------------------------------------- writes

  Future<int> startSession({
    required String sequenceId,
    required DateTime at,
    required int plannedSeconds,
  }) =>
      into(sessions).insert(
        SessionsCompanion.insert(
          sequenceId: sequenceId,
          startedAt: at,
          plannedSeconds: plannedSeconds,
        ),
      );

  /// Checkpoint mid-practice. Called on a throttle so that a hard kill — the
  /// most common way a practice ends — still leaves an honest record instead
  /// of a row that says zero seconds.
  Future<void> recordProgress(int id, {required int practisedSeconds}) =>
      (update(sessions)..where((s) => s.id.equals(id))).write(
        SessionsCompanion(practisedSeconds: Value(practisedSeconds)),
      );

  Future<void> finishSession(
    int id, {
    required DateTime at,
    required int practisedSeconds,
    required bool completed,
  }) =>
      (update(sessions)..where((s) => s.id.equals(id))).write(
        SessionsCompanion(
          endedAt: Value(at),
          practisedSeconds: Value(practisedSeconds),
          completed: Value(completed),
        ),
      );

  Future<int> addJournalEntry(JournalEntriesCompanion entry) =>
      into(journalEntries).insert(entry);

  Future<int> addTextEncounter({
    required String textId,
    required int sessionId,
    required DateTime at,
  }) =>
      into(textEncounters).insert(
        TextEncountersCompanion.insert(
          textId: textId,
          sessionId: Value(sessionId),
          at: at,
        ),
      );

  // ----------------------------------------------------------------- reads

  /// How many times a text has been met in practice — the chip in the library.
  Future<int> encounterCount(String textId) async {
    final count = textEncounters.id.count();
    final row = await (selectOnly(textEncounters)
          ..addColumns([count])
          ..where(textEncounters.textId.equals(textId)))
        .getSingle();
    return row.read(count) ?? 0;
  }

  /// Every text's encounter count in one query, so a library screen showing
  /// fifty verses does not fire fifty of them.
  Stream<Map<String, int>> watchEncounterCounts() {
    final count = textEncounters.id.count();
    final query = selectOnly(textEncounters)
      ..addColumns([textEncounters.textId, count])
      ..groupBy([textEncounters.textId]);

    return query.watch().map((rows) => {
          for (final row in rows)
            row.read(textEncounters.textId)!: row.read(count) ?? 0,
        });
  }

  /// Days practised in the last [days], oldest first. Feeds the continuity
  /// strip — density, not a streak counter, so a light day fades instead of
  /// breaking anything.
  Stream<List<int>> watchContinuity({
    required DateTime today,
    int days = 14,
  }) {
    final from = DateTime(today.year, today.month, today.day)
        .subtract(Duration(days: days - 1));

    return (select(sessions)
          ..where((s) => s.startedAt.isBiggerOrEqualValue(from)))
        .watch()
        .map((rows) => _bucketByDay(rows, from, days));
  }

  Future<List<int>> continuity({required DateTime today, int days = 14}) async {
    final from = DateTime(today.year, today.month, today.day)
        .subtract(Duration(days: days - 1));
    final rows = await (select(sessions)
          ..where((s) => s.startedAt.isBiggerOrEqualValue(from)))
        .get();
    return _bucketByDay(rows, from, days);
  }

  static List<int> _bucketByDay(List<Session> rows, DateTime from, int days) {
    final perDay = List<int>.filled(days, 0);
    for (final s in rows) {
      final index =
          DateTime(s.startedAt.year, s.startedAt.month, s.startedAt.day)
              .difference(from)
              .inDays;
      if (index >= 0 && index < days) perDay[index] += s.practisedSeconds;
    }
    return perDay;
  }

  /// Practice history, newest first, each with its journal entry if one was
  /// written. A left join because most sessions never get an entry, and a
  /// session without a note is still a session.
  Stream<List<PractisedSession>> watchHistory({int limit = 60}) {
    final query = select(sessions).join([
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

  /// Anything left open by a crash or a force-quit. Closed on next launch so
  /// the history never shows a practice that has been running for three days.
  Future<int> closeAbandonedSessions({required DateTime at}) =>
      (update(sessions)..where((s) => s.endedAt.isNull())).write(
        SessionsCompanion(endedAt: Value(at), completed: const Value(false)),
      );
}

/// A stored sequence and its steps, in order. Raw rows — [StepCodec] turns
/// them into domain objects.
class StoredSequence {
  const StoredSequence({required this.row, required this.steps});

  final SequenceRow row;
  final List<StepRow> steps;
}

/// A finished practice and the entry written about it, if any.
class PractisedSession {
  const PractisedSession({required this.session, this.journal});

  final Session session;
  final JournalEntry? journal;

  Duration get practised => Duration(seconds: session.practisedSeconds);
  bool get hasNote => (journal?.note ?? '').trim().isNotEmpty;
}
