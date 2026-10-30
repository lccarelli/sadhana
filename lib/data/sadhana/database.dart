import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import 'tables.dart';

export 'practice_reads.dart';
export 'sequence_queries.dart';
export 'session_writes.dart';
export 'tables.dart';

part 'database.g.dart';

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
  SadhanaDatabase([QueryExecutor? executor])
    : super(executor ?? driftDatabase(name: 'sadhana'));

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) => m.createAll(),
    onUpgrade: (m, from, to) async {
      if (from < 2) {
        await m.createTable(sequenceRows);
        await m.createTable(stepRows);
      }
    },
  );
}
