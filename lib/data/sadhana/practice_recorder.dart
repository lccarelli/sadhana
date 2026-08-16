import 'package:drift/drift.dart' show Value;

import '../../core/domain/practice_sequence.dart';
import 'database.dart';

/// Writes a practice down while it happens.
///
/// The design assumption worth stating: **most practices are abandoned, not
/// completed.** Someone starts, does eight minutes, and the phone gets locked
/// or the app killed. So the row is written at the first breath and checkpointed
/// as the practice runs, rather than being composed at the end — a record that
/// only exists on a clean finish would under-report real practice badly, and
/// this app's whole read side is built on honest history.
class PracticeRecorder {
  PracticeRecorder(
    this._db, {
    DateTime Function()? now,
    this.checkpointEvery = const Duration(seconds: 30),
  }) : _now = now ?? DateTime.now;

  final SadhanaDatabase _db;
  final DateTime Function() _now;

  /// How much practice may be lost to a hard kill. Thirty seconds costs one
  /// tiny write per half-minute and bounds the damage.
  final Duration checkpointEvery;

  int? _sessionId;
  Duration _lastCheckpoint = Duration.zero;
  final Set<String> _encountered = {};
  bool _ended = false;

  int? get sessionId => _sessionId;
  bool get isRecording => _sessionId != null && !_ended;

  Future<void> begin(PracticeSequence sequence) async {
    if (_sessionId != null) return;
    _sessionId = await _db.startSession(
      sequenceId: sequence.id,
      at: _now(),
      plannedSeconds: sequence.duration.inSeconds,
    );
  }

  /// [practised] is time actually practised — the runner's elapsedTotal, which
  /// does not advance while paused. Wall-clock would reward leaving the app
  /// open, which is the opposite of what this app should measure.
  /// [force] bypasses the throttle — used when the app is going to the
  /// background, which is the moment most likely to be followed by the OS
  /// killing us.
  Future<void> checkpoint(Duration practised, {bool force = false}) async {
    final id = _sessionId;
    if (id == null || _ended) return;
    if (!force && practised - _lastCheckpoint < checkpointEvery) return;

    _lastCheckpoint = practised;
    await _db.recordProgress(id, practisedSeconds: practised.inSeconds);
  }

  /// A text was met inside a practice, not merely read in the library. Once
  /// per session per text: re-reading the same verse in one sitting is one
  /// encounter, not thirty frames of one.
  Future<void> noteTextEncounter(String textId) async {
    final id = _sessionId;
    if (id == null || _ended || !_encountered.add(textId)) return;
    await _db.addTextEncounter(textId: textId, sessionId: id, at: _now());
  }

  /// Close the session. Idempotent — the screen calls this on completion, on
  /// backgrounding and on dispose, and only the first one counts.
  ///
  /// Returns the session id so the journal entry can be attached to it.
  Future<int?> end({
    required Duration practised,
    required bool completed,
  }) async {
    final id = _sessionId;
    if (id == null || _ended) return id;
    _ended = true;

    await _db.finishSession(
      id,
      at: _now(),
      practisedSeconds: practised.inSeconds,
      completed: completed,
    );
    return id;
  }

  /// Attach an entry to the recorded session.
  Future<void> writeJournal({
    required int? sthira,
    required int? sukha,
    required String note,
    required Iterable<String> angas,
  }) =>
      _db.addJournalEntry(
        JournalEntriesCompanion.insert(
          createdAt: _now(),
          sessionId: Value(_sessionId),
          sthira: Value(sthira),
          sukha: Value(sukha),
          note: Value(note),
          angas: Value(angas.join(',')),
        ),
      );
}
