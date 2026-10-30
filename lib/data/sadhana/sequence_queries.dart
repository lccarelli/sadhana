import 'package:drift/drift.dart';

import 'database.dart';

extension SequenceQueries on SadhanaDatabase {
  Stream<List<StoredSequence>> watchSequences() {
    final sequences = (select(
      sequenceRows,
    )..orderBy([(s) => OrderingTerm.desc(s.updatedAt)])).watch();

    return sequences.asyncMap((rows) async {
      if (rows.isEmpty) return const <StoredSequence>[];

      final ids = rows.map((r) => r.id).toList();
      final steps =
          await (select(stepRows)
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
    final row = await (select(
      sequenceRows,
    )..where((s) => s.id.equals(id))).getSingleOrNull();
    if (row == null) return null;

    final steps =
        await (select(stepRows)
              ..where((s) => s.sequenceId.equals(id))
              ..orderBy([(s) => OrderingTerm.asc(s.position)]))
            .get();

    return StoredSequence(row: row, steps: steps);
  }

  Future<int> saveSequence({
    int? id,
    required String title,
    required DateTime at,
    String? derivedFrom,
    required List<StepRowsCompanion> Function(int sequenceId) steps,
  }) => transaction(() async {
    final sequenceId =
        id ??
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
}

class StoredSequence {
  const StoredSequence({required this.row, required this.steps});

  final SequenceRow row;
  final List<StepRow> steps;
}
