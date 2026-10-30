import 'package:drift/drift.dart' show Value;

import '../../core/domain/practice_sequence.dart';
import 'database.dart';

class PracticeRecorder {
  PracticeRecorder(
    this._db, {
    DateTime Function()? now,
    this.checkpointEvery = const Duration(seconds: 30),
  }) : _now = now ?? DateTime.now;

  final SadhanaDatabase _db;
  final DateTime Function() _now;

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

  Future<void> checkpoint(Duration practised, {bool force = false}) async {
    final id = _sessionId;
    if (id == null || _ended) return;
    if (!force && practised - _lastCheckpoint < checkpointEvery) return;

    _lastCheckpoint = practised;
    await _db.recordProgress(id, practisedSeconds: practised.inSeconds);
  }

  Future<void> noteTextEncounter(String textId) async {
    final id = _sessionId;
    if (id == null || _ended || !_encountered.add(textId)) return;
    await _db.addTextEncounter(textId: textId, sessionId: id, at: _now());
  }

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

  Future<void> writeJournal({
    required int? sthira,
    required int? sukha,
    required String note,
    required Iterable<String> angas,
  }) => _db.addJournalEntry(
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
