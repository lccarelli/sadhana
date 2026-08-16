import '../../core/domain/practice_sequence.dart';
import '../../core/domain/practice_step.dart';
import 'database.dart';
import 'step_codec.dart';

/// Every practice on offer: the ones we ship, plus the ones the practitioner
/// composed.
///
/// The runner cannot tell the two apart, and that is the whole point of
/// modelling a practice as data. Nothing downstream of here branches on where
/// a sequence came from.
class SequenceRepository {
  const SequenceRepository(this._db);

  final SadhanaDatabase _db;

  /// Seeded practices first — they are the ones a new practitioner needs —
  /// then their own, most recently edited first.
  Stream<List<PracticeSequence>> watchAll() => _db.watchSequences().map(
        (stored) => [
          ...PracticeSequence.seeds,
          ..._toDomainAll(stored),
        ],
      );

  Stream<List<PracticeSequence>> watchOwn() =>
      _db.watchSequences().map(_toDomainAll);

  /// A stored sequence with no steps cannot become a [PracticeSequence] and
  /// would crash the runner on its first frame. [save] refuses to write one,
  /// so this is belt and braces against a hand-edited database — asserts are
  /// stripped in release and a crash on the mat is unforgivable.
  List<PracticeSequence> _toDomainAll(List<StoredSequence> stored) => [
        for (final s in stored)
          if (s.steps.isNotEmpty) _toDomain(s),
      ];

  Future<PracticeSequence?> byId(String id) async {
    final seeded =
        PracticeSequence.seeds.where((s) => s.id == id).firstOrNull;
    if (seeded != null) return seeded;

    final storageId = storageIdOf(id);
    if (storageId == null) return null;

    final stored = await _db.sequenceById(storageId);
    return stored == null ? null : _toDomain(stored);
  }

  /// Insert or update. Returns the saved practice, with its storage id filled
  /// in so the editor can keep working on it.
  Future<PracticeSequence> save({
    int? storageId,
    required String title,
    required List<PracticeStep> steps,
    String? derivedFrom,
    DateTime? at,
  }) async {
    if (steps.isEmpty) {
      throw ArgumentError.value(
        steps,
        'steps',
        'a practice with no steps is not a practice',
      );
    }

    final id = await _db.saveSequence(
      id: storageId,
      title: title,
      at: at ?? DateTime.now(),
      derivedFrom: derivedFrom,
      steps: (sequenceId) => [
        for (var i = 0; i < steps.length; i++)
          StepCodec.encode(steps[i], sequenceId: sequenceId, position: i),
      ],
    );

    return PracticeSequence(
      id: idFor(id),
      title: title,
      steps: steps,
      authoredByUser: true,
      storageId: id,
    );
  }

  /// Editing a shipped practice never modifies it — it makes the
  /// practitioner's own copy. Seeded practices have to stay improvable in a
  /// release, and a practice someone has been doing for a year must not
  /// change under them because we edited ours.
  Future<PracticeSequence> duplicate(
    PracticeSequence source, {
    required String title,
    DateTime? at,
  }) =>
      save(
        title: title,
        steps: source.steps,
        derivedFrom: source.authoredByUser ? null : source.id,
        at: at,
      );

  Future<void> delete(PracticeSequence sequence) async {
    final id = sequence.storageId;
    if (id == null) return; // seeded practices are not ours to delete
    await _db.deleteSequence(id);
  }

  static String idFor(int storageId) => 'user.$storageId';

  static int? storageIdOf(String id) =>
      id.startsWith('user.') ? int.tryParse(id.substring(5)) : null;

  PracticeSequence _toDomain(StoredSequence stored) => PracticeSequence(
        id: idFor(stored.row.id),
        title: stored.row.title,
        steps: stored.steps.map(StepCodec.decode).toList(),
        authoredByUser: true,
        storageId: stored.row.id,
      );
}
