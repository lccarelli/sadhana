import 'package:drift/drift.dart';

import 'database.dart';

extension SessionWrites on SadhanaDatabase {
  Future<int> startSession({
    required String sequenceId,
    required DateTime at,
    required int plannedSeconds,
  }) => into(sessions).insert(
    SessionsCompanion.insert(
      sequenceId: sequenceId,
      startedAt: at,
      plannedSeconds: plannedSeconds,
    ),
  );

  Future<void> recordProgress(int id, {required int practisedSeconds}) =>
      (update(sessions)..where((s) => s.id.equals(id))).write(
        SessionsCompanion(practisedSeconds: Value(practisedSeconds)),
      );

  Future<void> finishSession(
    int id, {
    required DateTime at,
    required int practisedSeconds,
    required bool completed,
  }) => (update(sessions)..where((s) => s.id.equals(id))).write(
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
  }) => into(textEncounters).insert(
    TextEncountersCompanion.insert(
      textId: textId,
      sessionId: Value(sessionId),
      at: at,
    ),
  );

  Future<int> closeAbandonedSessions({required DateTime at}) =>
      (update(sessions)..where((s) => s.endedAt.isNull())).write(
        SessionsCompanion(endedAt: Value(at), completed: const Value(false)),
      );
}
