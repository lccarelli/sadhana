import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sadhana/core/domain/practice_step.dart';
import 'package:sadhana/data/sadhana/database.dart';
import 'package:sadhana/data/sadhana/sequence_repository.dart';

/// The v1 schema, verbatim from what drift generated before sequences existed.
///
/// Hardcoded on purpose. If it were derived from the current table
/// definitions it would silently follow them forward, and the test would
/// "pass" while proving nothing about a real upgrade.
const _v1Schema = [
  'CREATE TABLE "sessions" ("id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, '
      '"sequence_id" TEXT NOT NULL, "started_at" INTEGER NOT NULL, '
      '"ended_at" INTEGER NULL, "planned_seconds" INTEGER NOT NULL, '
      '"practised_seconds" INTEGER NOT NULL DEFAULT 0, '
      '"completed" INTEGER NOT NULL DEFAULT 0 CHECK ("completed" IN (0, 1)));',
  'CREATE TABLE "journal_entries" ("id" INTEGER NOT NULL PRIMARY KEY '
      'AUTOINCREMENT, "session_id" INTEGER NULL REFERENCES sessions (id), '
      '"created_at" INTEGER NOT NULL, "sthira" INTEGER NULL, '
      '"sukha" INTEGER NULL, "note" TEXT NOT NULL DEFAULT \'\', '
      '"angas" TEXT NOT NULL DEFAULT \'\');',
  'CREATE TABLE "text_annotations" ("id" INTEGER NOT NULL PRIMARY KEY '
      'AUTOINCREMENT, "text_id" TEXT NOT NULL, "note" TEXT NOT NULL, '
      '"created_at" INTEGER NOT NULL);',
  'CREATE TABLE "text_encounters" ("id" INTEGER NOT NULL PRIMARY KEY '
      'AUTOINCREMENT, "text_id" TEXT NOT NULL, '
      '"session_id" INTEGER NULL REFERENCES sessions (id), '
      '"at" INTEGER NOT NULL);',
];

void main() {
  /// A database as it looked before this feature, carrying practice history
  /// that must survive the upgrade. A journal is the one thing in this app
  /// that cannot be recreated.
  SadhanaDatabase openV1WithHistory() => SadhanaDatabase(
        NativeDatabase.memory(
          setup: (raw) {
            for (final statement in _v1Schema) {
              raw.execute(statement);
            }
            raw.execute(
              'INSERT INTO sessions (sequence_id, started_at, ended_at, '
              'planned_seconds, practised_seconds, completed) '
              'VALUES (?, ?, ?, ?, ?, ?)',
              ['seq.slow_morning', 1755300000, 1755301452, 1452, 1452, 1],
            );
            raw.execute(
              'INSERT INTO journal_entries (session_id, created_at, sthira, '
              'sukha, note, angas) VALUES (?, ?, ?, ?, ?, ?)',
              [1, 1755301460, 4, 3, 'the long hold let go on its own', 'asana'],
            );
            raw.execute(
              'INSERT INTO text_encounters (text_id, session_id, at) '
              'VALUES (?, ?, ?)',
              ['ys.1.2', 1, 1755301000],
            );
            raw.execute('PRAGMA user_version = 1');
          },
        ),
      );

  group('upgrading from v1', () {
    test('keeps every session and its entry', () async {
      final db = openV1WithHistory();
      addTearDown(db.close);

      final history = await db.watchHistory().first;

      expect(history, hasLength(1));
      expect(history.single.session.practisedSeconds, 1452);
      expect(history.single.session.completed, isTrue);
      expect(history.single.journal!.sthira, 4);
      expect(history.single.journal!.note, 'the long hold let go on its own');
    });

    test('keeps text encounters, so the library does not forget', () async {
      final db = openV1WithHistory();
      addTearDown(db.close);

      expect(await db.encounterCount('ys.1.2'), 1);
    });

    test('lands on the current schema version', () async {
      final db = openV1WithHistory();
      addTearDown(db.close);

      // Force the migration to run before reading the pragma.
      await db.select(db.sessions).get();
      final row = await db.customSelect('PRAGMA user_version').getSingle();

      expect(row.data.values.first, db.schemaVersion);
    });

    test('adds the sequence tables, empty and usable', () async {
      final db = openV1WithHistory();
      addTearDown(db.close);
      final repo = SequenceRepository(db);

      expect(await repo.watchOwn().first, isEmpty);

      final saved = await repo.save(
        title: 'composed after upgrading',
        steps: const [SilenceStep(duration: Duration(minutes: 5))],
      );

      expect((await repo.byId(saved.id))!.steps, hasLength(1));
    });

    test('continuity still reads the pre-upgrade practice', () async {
      final db = openV1WithHistory();
      addTearDown(db.close);

      final practisedAt =
          DateTime.fromMillisecondsSinceEpoch(1755300000 * 1000);
      final days = await db.continuity(today: practisedAt, days: 14);

      expect(days.last, 1452, reason: 'the old session is the last bucket');
    });
  });

  group('a fresh install', () {
    test('creates every table at the current version', () async {
      final db = SadhanaDatabase(NativeDatabase.memory());
      addTearDown(db.close);
      final repo = SequenceRepository(db);

      expect(await repo.watchOwn().first, isEmpty);
      expect(await db.watchHistory().first, isEmpty);

      final row = await db.customSelect('PRAGMA user_version').getSingle();
      expect(row.data.values.first, db.schemaVersion);
    });
  });
}
