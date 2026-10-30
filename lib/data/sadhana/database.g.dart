// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $SessionsTable extends Sessions with TableInfo<$SessionsTable, Session> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SessionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _sequenceIdMeta = const VerificationMeta(
    'sequenceId',
  );
  @override
  late final GeneratedColumn<String> sequenceId = GeneratedColumn<String>(
    'sequence_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _startedAtMeta = const VerificationMeta(
    'startedAt',
  );
  @override
  late final GeneratedColumn<DateTime> startedAt = GeneratedColumn<DateTime>(
    'started_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endedAtMeta = const VerificationMeta(
    'endedAt',
  );
  @override
  late final GeneratedColumn<DateTime> endedAt = GeneratedColumn<DateTime>(
    'ended_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _plannedSecondsMeta = const VerificationMeta(
    'plannedSeconds',
  );
  @override
  late final GeneratedColumn<int> plannedSeconds = GeneratedColumn<int>(
    'planned_seconds',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _practisedSecondsMeta = const VerificationMeta(
    'practisedSeconds',
  );
  @override
  late final GeneratedColumn<int> practisedSeconds = GeneratedColumn<int>(
    'practised_seconds',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _completedMeta = const VerificationMeta(
    'completed',
  );
  @override
  late final GeneratedColumn<bool> completed = GeneratedColumn<bool>(
    'completed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("completed" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    sequenceId,
    startedAt,
    endedAt,
    plannedSeconds,
    practisedSeconds,
    completed,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sessions';
  @override
  VerificationContext validateIntegrity(
    Insertable<Session> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('sequence_id')) {
      context.handle(
        _sequenceIdMeta,
        sequenceId.isAcceptableOrUnknown(data['sequence_id']!, _sequenceIdMeta),
      );
    } else if (isInserting) {
      context.missing(_sequenceIdMeta);
    }
    if (data.containsKey('started_at')) {
      context.handle(
        _startedAtMeta,
        startedAt.isAcceptableOrUnknown(data['started_at']!, _startedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_startedAtMeta);
    }
    if (data.containsKey('ended_at')) {
      context.handle(
        _endedAtMeta,
        endedAt.isAcceptableOrUnknown(data['ended_at']!, _endedAtMeta),
      );
    }
    if (data.containsKey('planned_seconds')) {
      context.handle(
        _plannedSecondsMeta,
        plannedSeconds.isAcceptableOrUnknown(
          data['planned_seconds']!,
          _plannedSecondsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_plannedSecondsMeta);
    }
    if (data.containsKey('practised_seconds')) {
      context.handle(
        _practisedSecondsMeta,
        practisedSeconds.isAcceptableOrUnknown(
          data['practised_seconds']!,
          _practisedSecondsMeta,
        ),
      );
    }
    if (data.containsKey('completed')) {
      context.handle(
        _completedMeta,
        completed.isAcceptableOrUnknown(data['completed']!, _completedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Session map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Session(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      sequenceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sequence_id'],
      )!,
      startedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}started_at'],
      )!,
      endedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}ended_at'],
      ),
      plannedSeconds: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}planned_seconds'],
      )!,
      practisedSeconds: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}practised_seconds'],
      )!,
      completed: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}completed'],
      )!,
    );
  }

  @override
  $SessionsTable createAlias(String alias) {
    return $SessionsTable(attachedDatabase, alias);
  }
}

class Session extends DataClass implements Insertable<Session> {
  final int id;
  final String sequenceId;
  final DateTime startedAt;
  final DateTime? endedAt;
  final int plannedSeconds;
  final int practisedSeconds;
  final bool completed;
  const Session({
    required this.id,
    required this.sequenceId,
    required this.startedAt,
    this.endedAt,
    required this.plannedSeconds,
    required this.practisedSeconds,
    required this.completed,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['sequence_id'] = Variable<String>(sequenceId);
    map['started_at'] = Variable<DateTime>(startedAt);
    if (!nullToAbsent || endedAt != null) {
      map['ended_at'] = Variable<DateTime>(endedAt);
    }
    map['planned_seconds'] = Variable<int>(plannedSeconds);
    map['practised_seconds'] = Variable<int>(practisedSeconds);
    map['completed'] = Variable<bool>(completed);
    return map;
  }

  SessionsCompanion toCompanion(bool nullToAbsent) {
    return SessionsCompanion(
      id: Value(id),
      sequenceId: Value(sequenceId),
      startedAt: Value(startedAt),
      endedAt: endedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(endedAt),
      plannedSeconds: Value(plannedSeconds),
      practisedSeconds: Value(practisedSeconds),
      completed: Value(completed),
    );
  }

  factory Session.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Session(
      id: serializer.fromJson<int>(json['id']),
      sequenceId: serializer.fromJson<String>(json['sequenceId']),
      startedAt: serializer.fromJson<DateTime>(json['startedAt']),
      endedAt: serializer.fromJson<DateTime?>(json['endedAt']),
      plannedSeconds: serializer.fromJson<int>(json['plannedSeconds']),
      practisedSeconds: serializer.fromJson<int>(json['practisedSeconds']),
      completed: serializer.fromJson<bool>(json['completed']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'sequenceId': serializer.toJson<String>(sequenceId),
      'startedAt': serializer.toJson<DateTime>(startedAt),
      'endedAt': serializer.toJson<DateTime?>(endedAt),
      'plannedSeconds': serializer.toJson<int>(plannedSeconds),
      'practisedSeconds': serializer.toJson<int>(practisedSeconds),
      'completed': serializer.toJson<bool>(completed),
    };
  }

  Session copyWith({
    int? id,
    String? sequenceId,
    DateTime? startedAt,
    Value<DateTime?> endedAt = const Value.absent(),
    int? plannedSeconds,
    int? practisedSeconds,
    bool? completed,
  }) => Session(
    id: id ?? this.id,
    sequenceId: sequenceId ?? this.sequenceId,
    startedAt: startedAt ?? this.startedAt,
    endedAt: endedAt.present ? endedAt.value : this.endedAt,
    plannedSeconds: plannedSeconds ?? this.plannedSeconds,
    practisedSeconds: practisedSeconds ?? this.practisedSeconds,
    completed: completed ?? this.completed,
  );
  Session copyWithCompanion(SessionsCompanion data) {
    return Session(
      id: data.id.present ? data.id.value : this.id,
      sequenceId: data.sequenceId.present
          ? data.sequenceId.value
          : this.sequenceId,
      startedAt: data.startedAt.present ? data.startedAt.value : this.startedAt,
      endedAt: data.endedAt.present ? data.endedAt.value : this.endedAt,
      plannedSeconds: data.plannedSeconds.present
          ? data.plannedSeconds.value
          : this.plannedSeconds,
      practisedSeconds: data.practisedSeconds.present
          ? data.practisedSeconds.value
          : this.practisedSeconds,
      completed: data.completed.present ? data.completed.value : this.completed,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Session(')
          ..write('id: $id, ')
          ..write('sequenceId: $sequenceId, ')
          ..write('startedAt: $startedAt, ')
          ..write('endedAt: $endedAt, ')
          ..write('plannedSeconds: $plannedSeconds, ')
          ..write('practisedSeconds: $practisedSeconds, ')
          ..write('completed: $completed')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    sequenceId,
    startedAt,
    endedAt,
    plannedSeconds,
    practisedSeconds,
    completed,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Session &&
          other.id == this.id &&
          other.sequenceId == this.sequenceId &&
          other.startedAt == this.startedAt &&
          other.endedAt == this.endedAt &&
          other.plannedSeconds == this.plannedSeconds &&
          other.practisedSeconds == this.practisedSeconds &&
          other.completed == this.completed);
}

class SessionsCompanion extends UpdateCompanion<Session> {
  final Value<int> id;
  final Value<String> sequenceId;
  final Value<DateTime> startedAt;
  final Value<DateTime?> endedAt;
  final Value<int> plannedSeconds;
  final Value<int> practisedSeconds;
  final Value<bool> completed;
  const SessionsCompanion({
    this.id = const Value.absent(),
    this.sequenceId = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.endedAt = const Value.absent(),
    this.plannedSeconds = const Value.absent(),
    this.practisedSeconds = const Value.absent(),
    this.completed = const Value.absent(),
  });
  SessionsCompanion.insert({
    this.id = const Value.absent(),
    required String sequenceId,
    required DateTime startedAt,
    this.endedAt = const Value.absent(),
    required int plannedSeconds,
    this.practisedSeconds = const Value.absent(),
    this.completed = const Value.absent(),
  }) : sequenceId = Value(sequenceId),
       startedAt = Value(startedAt),
       plannedSeconds = Value(plannedSeconds);
  static Insertable<Session> custom({
    Expression<int>? id,
    Expression<String>? sequenceId,
    Expression<DateTime>? startedAt,
    Expression<DateTime>? endedAt,
    Expression<int>? plannedSeconds,
    Expression<int>? practisedSeconds,
    Expression<bool>? completed,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (sequenceId != null) 'sequence_id': sequenceId,
      if (startedAt != null) 'started_at': startedAt,
      if (endedAt != null) 'ended_at': endedAt,
      if (plannedSeconds != null) 'planned_seconds': plannedSeconds,
      if (practisedSeconds != null) 'practised_seconds': practisedSeconds,
      if (completed != null) 'completed': completed,
    });
  }

  SessionsCompanion copyWith({
    Value<int>? id,
    Value<String>? sequenceId,
    Value<DateTime>? startedAt,
    Value<DateTime?>? endedAt,
    Value<int>? plannedSeconds,
    Value<int>? practisedSeconds,
    Value<bool>? completed,
  }) {
    return SessionsCompanion(
      id: id ?? this.id,
      sequenceId: sequenceId ?? this.sequenceId,
      startedAt: startedAt ?? this.startedAt,
      endedAt: endedAt ?? this.endedAt,
      plannedSeconds: plannedSeconds ?? this.plannedSeconds,
      practisedSeconds: practisedSeconds ?? this.practisedSeconds,
      completed: completed ?? this.completed,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (sequenceId.present) {
      map['sequence_id'] = Variable<String>(sequenceId.value);
    }
    if (startedAt.present) {
      map['started_at'] = Variable<DateTime>(startedAt.value);
    }
    if (endedAt.present) {
      map['ended_at'] = Variable<DateTime>(endedAt.value);
    }
    if (plannedSeconds.present) {
      map['planned_seconds'] = Variable<int>(plannedSeconds.value);
    }
    if (practisedSeconds.present) {
      map['practised_seconds'] = Variable<int>(practisedSeconds.value);
    }
    if (completed.present) {
      map['completed'] = Variable<bool>(completed.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SessionsCompanion(')
          ..write('id: $id, ')
          ..write('sequenceId: $sequenceId, ')
          ..write('startedAt: $startedAt, ')
          ..write('endedAt: $endedAt, ')
          ..write('plannedSeconds: $plannedSeconds, ')
          ..write('practisedSeconds: $practisedSeconds, ')
          ..write('completed: $completed')
          ..write(')'))
        .toString();
  }
}

class $JournalEntriesTable extends JournalEntries
    with TableInfo<$JournalEntriesTable, JournalEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $JournalEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _sessionIdMeta = const VerificationMeta(
    'sessionId',
  );
  @override
  late final GeneratedColumn<int> sessionId = GeneratedColumn<int>(
    'session_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES sessions (id)',
    ),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sthiraMeta = const VerificationMeta('sthira');
  @override
  late final GeneratedColumn<int> sthira = GeneratedColumn<int>(
    'sthira',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sukhaMeta = const VerificationMeta('sukha');
  @override
  late final GeneratedColumn<int> sukha = GeneratedColumn<int>(
    'sukha',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _angasMeta = const VerificationMeta('angas');
  @override
  late final GeneratedColumn<String> angas = GeneratedColumn<String>(
    'angas',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    sessionId,
    createdAt,
    sthira,
    sukha,
    note,
    angas,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'journal_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<JournalEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('session_id')) {
      context.handle(
        _sessionIdMeta,
        sessionId.isAcceptableOrUnknown(data['session_id']!, _sessionIdMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('sthira')) {
      context.handle(
        _sthiraMeta,
        sthira.isAcceptableOrUnknown(data['sthira']!, _sthiraMeta),
      );
    }
    if (data.containsKey('sukha')) {
      context.handle(
        _sukhaMeta,
        sukha.isAcceptableOrUnknown(data['sukha']!, _sukhaMeta),
      );
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('angas')) {
      context.handle(
        _angasMeta,
        angas.isAcceptableOrUnknown(data['angas']!, _angasMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  JournalEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return JournalEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      sessionId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}session_id'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      sthira: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sthira'],
      ),
      sukha: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sukha'],
      ),
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      )!,
      angas: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}angas'],
      )!,
    );
  }

  @override
  $JournalEntriesTable createAlias(String alias) {
    return $JournalEntriesTable(attachedDatabase, alias);
  }
}

class JournalEntry extends DataClass implements Insertable<JournalEntry> {
  final int id;
  final int? sessionId;
  final DateTime createdAt;
  final int? sthira;
  final int? sukha;
  final String note;
  final String angas;
  const JournalEntry({
    required this.id,
    this.sessionId,
    required this.createdAt,
    this.sthira,
    this.sukha,
    required this.note,
    required this.angas,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || sessionId != null) {
      map['session_id'] = Variable<int>(sessionId);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || sthira != null) {
      map['sthira'] = Variable<int>(sthira);
    }
    if (!nullToAbsent || sukha != null) {
      map['sukha'] = Variable<int>(sukha);
    }
    map['note'] = Variable<String>(note);
    map['angas'] = Variable<String>(angas);
    return map;
  }

  JournalEntriesCompanion toCompanion(bool nullToAbsent) {
    return JournalEntriesCompanion(
      id: Value(id),
      sessionId: sessionId == null && nullToAbsent
          ? const Value.absent()
          : Value(sessionId),
      createdAt: Value(createdAt),
      sthira: sthira == null && nullToAbsent
          ? const Value.absent()
          : Value(sthira),
      sukha: sukha == null && nullToAbsent
          ? const Value.absent()
          : Value(sukha),
      note: Value(note),
      angas: Value(angas),
    );
  }

  factory JournalEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return JournalEntry(
      id: serializer.fromJson<int>(json['id']),
      sessionId: serializer.fromJson<int?>(json['sessionId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      sthira: serializer.fromJson<int?>(json['sthira']),
      sukha: serializer.fromJson<int?>(json['sukha']),
      note: serializer.fromJson<String>(json['note']),
      angas: serializer.fromJson<String>(json['angas']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'sessionId': serializer.toJson<int?>(sessionId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'sthira': serializer.toJson<int?>(sthira),
      'sukha': serializer.toJson<int?>(sukha),
      'note': serializer.toJson<String>(note),
      'angas': serializer.toJson<String>(angas),
    };
  }

  JournalEntry copyWith({
    int? id,
    Value<int?> sessionId = const Value.absent(),
    DateTime? createdAt,
    Value<int?> sthira = const Value.absent(),
    Value<int?> sukha = const Value.absent(),
    String? note,
    String? angas,
  }) => JournalEntry(
    id: id ?? this.id,
    sessionId: sessionId.present ? sessionId.value : this.sessionId,
    createdAt: createdAt ?? this.createdAt,
    sthira: sthira.present ? sthira.value : this.sthira,
    sukha: sukha.present ? sukha.value : this.sukha,
    note: note ?? this.note,
    angas: angas ?? this.angas,
  );
  JournalEntry copyWithCompanion(JournalEntriesCompanion data) {
    return JournalEntry(
      id: data.id.present ? data.id.value : this.id,
      sessionId: data.sessionId.present ? data.sessionId.value : this.sessionId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      sthira: data.sthira.present ? data.sthira.value : this.sthira,
      sukha: data.sukha.present ? data.sukha.value : this.sukha,
      note: data.note.present ? data.note.value : this.note,
      angas: data.angas.present ? data.angas.value : this.angas,
    );
  }

  @override
  String toString() {
    return (StringBuffer('JournalEntry(')
          ..write('id: $id, ')
          ..write('sessionId: $sessionId, ')
          ..write('createdAt: $createdAt, ')
          ..write('sthira: $sthira, ')
          ..write('sukha: $sukha, ')
          ..write('note: $note, ')
          ..write('angas: $angas')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, sessionId, createdAt, sthira, sukha, note, angas);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is JournalEntry &&
          other.id == this.id &&
          other.sessionId == this.sessionId &&
          other.createdAt == this.createdAt &&
          other.sthira == this.sthira &&
          other.sukha == this.sukha &&
          other.note == this.note &&
          other.angas == this.angas);
}

class JournalEntriesCompanion extends UpdateCompanion<JournalEntry> {
  final Value<int> id;
  final Value<int?> sessionId;
  final Value<DateTime> createdAt;
  final Value<int?> sthira;
  final Value<int?> sukha;
  final Value<String> note;
  final Value<String> angas;
  const JournalEntriesCompanion({
    this.id = const Value.absent(),
    this.sessionId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.sthira = const Value.absent(),
    this.sukha = const Value.absent(),
    this.note = const Value.absent(),
    this.angas = const Value.absent(),
  });
  JournalEntriesCompanion.insert({
    this.id = const Value.absent(),
    this.sessionId = const Value.absent(),
    required DateTime createdAt,
    this.sthira = const Value.absent(),
    this.sukha = const Value.absent(),
    this.note = const Value.absent(),
    this.angas = const Value.absent(),
  }) : createdAt = Value(createdAt);
  static Insertable<JournalEntry> custom({
    Expression<int>? id,
    Expression<int>? sessionId,
    Expression<DateTime>? createdAt,
    Expression<int>? sthira,
    Expression<int>? sukha,
    Expression<String>? note,
    Expression<String>? angas,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (sessionId != null) 'session_id': sessionId,
      if (createdAt != null) 'created_at': createdAt,
      if (sthira != null) 'sthira': sthira,
      if (sukha != null) 'sukha': sukha,
      if (note != null) 'note': note,
      if (angas != null) 'angas': angas,
    });
  }

  JournalEntriesCompanion copyWith({
    Value<int>? id,
    Value<int?>? sessionId,
    Value<DateTime>? createdAt,
    Value<int?>? sthira,
    Value<int?>? sukha,
    Value<String>? note,
    Value<String>? angas,
  }) {
    return JournalEntriesCompanion(
      id: id ?? this.id,
      sessionId: sessionId ?? this.sessionId,
      createdAt: createdAt ?? this.createdAt,
      sthira: sthira ?? this.sthira,
      sukha: sukha ?? this.sukha,
      note: note ?? this.note,
      angas: angas ?? this.angas,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (sessionId.present) {
      map['session_id'] = Variable<int>(sessionId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (sthira.present) {
      map['sthira'] = Variable<int>(sthira.value);
    }
    if (sukha.present) {
      map['sukha'] = Variable<int>(sukha.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (angas.present) {
      map['angas'] = Variable<String>(angas.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('JournalEntriesCompanion(')
          ..write('id: $id, ')
          ..write('sessionId: $sessionId, ')
          ..write('createdAt: $createdAt, ')
          ..write('sthira: $sthira, ')
          ..write('sukha: $sukha, ')
          ..write('note: $note, ')
          ..write('angas: $angas')
          ..write(')'))
        .toString();
  }
}

class $TextAnnotationsTable extends TextAnnotations
    with TableInfo<$TextAnnotationsTable, TextAnnotation> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TextAnnotationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _textIdMeta = const VerificationMeta('textId');
  @override
  late final GeneratedColumn<String> textId = GeneratedColumn<String>(
    'text_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, textId, note, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'text_annotations';
  @override
  VerificationContext validateIntegrity(
    Insertable<TextAnnotation> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('text_id')) {
      context.handle(
        _textIdMeta,
        textId.isAcceptableOrUnknown(data['text_id']!, _textIdMeta),
      );
    } else if (isInserting) {
      context.missing(_textIdMeta);
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    } else if (isInserting) {
      context.missing(_noteMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TextAnnotation map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TextAnnotation(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      textId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}text_id'],
      )!,
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $TextAnnotationsTable createAlias(String alias) {
    return $TextAnnotationsTable(attachedDatabase, alias);
  }
}

class TextAnnotation extends DataClass implements Insertable<TextAnnotation> {
  final int id;
  final String textId;
  final String note;
  final DateTime createdAt;
  const TextAnnotation({
    required this.id,
    required this.textId,
    required this.note,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['text_id'] = Variable<String>(textId);
    map['note'] = Variable<String>(note);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  TextAnnotationsCompanion toCompanion(bool nullToAbsent) {
    return TextAnnotationsCompanion(
      id: Value(id),
      textId: Value(textId),
      note: Value(note),
      createdAt: Value(createdAt),
    );
  }

  factory TextAnnotation.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TextAnnotation(
      id: serializer.fromJson<int>(json['id']),
      textId: serializer.fromJson<String>(json['textId']),
      note: serializer.fromJson<String>(json['note']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'textId': serializer.toJson<String>(textId),
      'note': serializer.toJson<String>(note),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  TextAnnotation copyWith({
    int? id,
    String? textId,
    String? note,
    DateTime? createdAt,
  }) => TextAnnotation(
    id: id ?? this.id,
    textId: textId ?? this.textId,
    note: note ?? this.note,
    createdAt: createdAt ?? this.createdAt,
  );
  TextAnnotation copyWithCompanion(TextAnnotationsCompanion data) {
    return TextAnnotation(
      id: data.id.present ? data.id.value : this.id,
      textId: data.textId.present ? data.textId.value : this.textId,
      note: data.note.present ? data.note.value : this.note,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TextAnnotation(')
          ..write('id: $id, ')
          ..write('textId: $textId, ')
          ..write('note: $note, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, textId, note, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TextAnnotation &&
          other.id == this.id &&
          other.textId == this.textId &&
          other.note == this.note &&
          other.createdAt == this.createdAt);
}

class TextAnnotationsCompanion extends UpdateCompanion<TextAnnotation> {
  final Value<int> id;
  final Value<String> textId;
  final Value<String> note;
  final Value<DateTime> createdAt;
  const TextAnnotationsCompanion({
    this.id = const Value.absent(),
    this.textId = const Value.absent(),
    this.note = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  TextAnnotationsCompanion.insert({
    this.id = const Value.absent(),
    required String textId,
    required String note,
    required DateTime createdAt,
  }) : textId = Value(textId),
       note = Value(note),
       createdAt = Value(createdAt);
  static Insertable<TextAnnotation> custom({
    Expression<int>? id,
    Expression<String>? textId,
    Expression<String>? note,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (textId != null) 'text_id': textId,
      if (note != null) 'note': note,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  TextAnnotationsCompanion copyWith({
    Value<int>? id,
    Value<String>? textId,
    Value<String>? note,
    Value<DateTime>? createdAt,
  }) {
    return TextAnnotationsCompanion(
      id: id ?? this.id,
      textId: textId ?? this.textId,
      note: note ?? this.note,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (textId.present) {
      map['text_id'] = Variable<String>(textId.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TextAnnotationsCompanion(')
          ..write('id: $id, ')
          ..write('textId: $textId, ')
          ..write('note: $note, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $TextEncountersTable extends TextEncounters
    with TableInfo<$TextEncountersTable, TextEncounter> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TextEncountersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _textIdMeta = const VerificationMeta('textId');
  @override
  late final GeneratedColumn<String> textId = GeneratedColumn<String>(
    'text_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sessionIdMeta = const VerificationMeta(
    'sessionId',
  );
  @override
  late final GeneratedColumn<int> sessionId = GeneratedColumn<int>(
    'session_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES sessions (id)',
    ),
  );
  static const VerificationMeta _atMeta = const VerificationMeta('at');
  @override
  late final GeneratedColumn<DateTime> at = GeneratedColumn<DateTime>(
    'at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, textId, sessionId, at];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'text_encounters';
  @override
  VerificationContext validateIntegrity(
    Insertable<TextEncounter> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('text_id')) {
      context.handle(
        _textIdMeta,
        textId.isAcceptableOrUnknown(data['text_id']!, _textIdMeta),
      );
    } else if (isInserting) {
      context.missing(_textIdMeta);
    }
    if (data.containsKey('session_id')) {
      context.handle(
        _sessionIdMeta,
        sessionId.isAcceptableOrUnknown(data['session_id']!, _sessionIdMeta),
      );
    }
    if (data.containsKey('at')) {
      context.handle(_atMeta, at.isAcceptableOrUnknown(data['at']!, _atMeta));
    } else if (isInserting) {
      context.missing(_atMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TextEncounter map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TextEncounter(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      textId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}text_id'],
      )!,
      sessionId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}session_id'],
      ),
      at: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}at'],
      )!,
    );
  }

  @override
  $TextEncountersTable createAlias(String alias) {
    return $TextEncountersTable(attachedDatabase, alias);
  }
}

class TextEncounter extends DataClass implements Insertable<TextEncounter> {
  final int id;
  final String textId;
  final int? sessionId;
  final DateTime at;
  const TextEncounter({
    required this.id,
    required this.textId,
    this.sessionId,
    required this.at,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['text_id'] = Variable<String>(textId);
    if (!nullToAbsent || sessionId != null) {
      map['session_id'] = Variable<int>(sessionId);
    }
    map['at'] = Variable<DateTime>(at);
    return map;
  }

  TextEncountersCompanion toCompanion(bool nullToAbsent) {
    return TextEncountersCompanion(
      id: Value(id),
      textId: Value(textId),
      sessionId: sessionId == null && nullToAbsent
          ? const Value.absent()
          : Value(sessionId),
      at: Value(at),
    );
  }

  factory TextEncounter.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TextEncounter(
      id: serializer.fromJson<int>(json['id']),
      textId: serializer.fromJson<String>(json['textId']),
      sessionId: serializer.fromJson<int?>(json['sessionId']),
      at: serializer.fromJson<DateTime>(json['at']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'textId': serializer.toJson<String>(textId),
      'sessionId': serializer.toJson<int?>(sessionId),
      'at': serializer.toJson<DateTime>(at),
    };
  }

  TextEncounter copyWith({
    int? id,
    String? textId,
    Value<int?> sessionId = const Value.absent(),
    DateTime? at,
  }) => TextEncounter(
    id: id ?? this.id,
    textId: textId ?? this.textId,
    sessionId: sessionId.present ? sessionId.value : this.sessionId,
    at: at ?? this.at,
  );
  TextEncounter copyWithCompanion(TextEncountersCompanion data) {
    return TextEncounter(
      id: data.id.present ? data.id.value : this.id,
      textId: data.textId.present ? data.textId.value : this.textId,
      sessionId: data.sessionId.present ? data.sessionId.value : this.sessionId,
      at: data.at.present ? data.at.value : this.at,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TextEncounter(')
          ..write('id: $id, ')
          ..write('textId: $textId, ')
          ..write('sessionId: $sessionId, ')
          ..write('at: $at')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, textId, sessionId, at);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TextEncounter &&
          other.id == this.id &&
          other.textId == this.textId &&
          other.sessionId == this.sessionId &&
          other.at == this.at);
}

class TextEncountersCompanion extends UpdateCompanion<TextEncounter> {
  final Value<int> id;
  final Value<String> textId;
  final Value<int?> sessionId;
  final Value<DateTime> at;
  const TextEncountersCompanion({
    this.id = const Value.absent(),
    this.textId = const Value.absent(),
    this.sessionId = const Value.absent(),
    this.at = const Value.absent(),
  });
  TextEncountersCompanion.insert({
    this.id = const Value.absent(),
    required String textId,
    this.sessionId = const Value.absent(),
    required DateTime at,
  }) : textId = Value(textId),
       at = Value(at);
  static Insertable<TextEncounter> custom({
    Expression<int>? id,
    Expression<String>? textId,
    Expression<int>? sessionId,
    Expression<DateTime>? at,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (textId != null) 'text_id': textId,
      if (sessionId != null) 'session_id': sessionId,
      if (at != null) 'at': at,
    });
  }

  TextEncountersCompanion copyWith({
    Value<int>? id,
    Value<String>? textId,
    Value<int?>? sessionId,
    Value<DateTime>? at,
  }) {
    return TextEncountersCompanion(
      id: id ?? this.id,
      textId: textId ?? this.textId,
      sessionId: sessionId ?? this.sessionId,
      at: at ?? this.at,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (textId.present) {
      map['text_id'] = Variable<String>(textId.value);
    }
    if (sessionId.present) {
      map['session_id'] = Variable<int>(sessionId.value);
    }
    if (at.present) {
      map['at'] = Variable<DateTime>(at.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TextEncountersCompanion(')
          ..write('id: $id, ')
          ..write('textId: $textId, ')
          ..write('sessionId: $sessionId, ')
          ..write('at: $at')
          ..write(')'))
        .toString();
  }
}

class $SequenceRowsTable extends SequenceRows
    with TableInfo<$SequenceRowsTable, SequenceRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SequenceRowsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _derivedFromMeta = const VerificationMeta(
    'derivedFrom',
  );
  @override
  late final GeneratedColumn<String> derivedFrom = GeneratedColumn<String>(
    'derived_from',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    title,
    createdAt,
    updatedAt,
    derivedFrom,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sequence_rows';
  @override
  VerificationContext validateIntegrity(
    Insertable<SequenceRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('derived_from')) {
      context.handle(
        _derivedFromMeta,
        derivedFrom.isAcceptableOrUnknown(
          data['derived_from']!,
          _derivedFromMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SequenceRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SequenceRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      derivedFrom: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}derived_from'],
      ),
    );
  }

  @override
  $SequenceRowsTable createAlias(String alias) {
    return $SequenceRowsTable(attachedDatabase, alias);
  }
}

class SequenceRow extends DataClass implements Insertable<SequenceRow> {
  final int id;
  final String title;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? derivedFrom;
  const SequenceRow({
    required this.id,
    required this.title,
    required this.createdAt,
    required this.updatedAt,
    this.derivedFrom,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['title'] = Variable<String>(title);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || derivedFrom != null) {
      map['derived_from'] = Variable<String>(derivedFrom);
    }
    return map;
  }

  SequenceRowsCompanion toCompanion(bool nullToAbsent) {
    return SequenceRowsCompanion(
      id: Value(id),
      title: Value(title),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      derivedFrom: derivedFrom == null && nullToAbsent
          ? const Value.absent()
          : Value(derivedFrom),
    );
  }

  factory SequenceRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SequenceRow(
      id: serializer.fromJson<int>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      derivedFrom: serializer.fromJson<String?>(json['derivedFrom']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'title': serializer.toJson<String>(title),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'derivedFrom': serializer.toJson<String?>(derivedFrom),
    };
  }

  SequenceRow copyWith({
    int? id,
    String? title,
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<String?> derivedFrom = const Value.absent(),
  }) => SequenceRow(
    id: id ?? this.id,
    title: title ?? this.title,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    derivedFrom: derivedFrom.present ? derivedFrom.value : this.derivedFrom,
  );
  SequenceRow copyWithCompanion(SequenceRowsCompanion data) {
    return SequenceRow(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      derivedFrom: data.derivedFrom.present
          ? data.derivedFrom.value
          : this.derivedFrom,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SequenceRow(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('derivedFrom: $derivedFrom')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, title, createdAt, updatedAt, derivedFrom);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SequenceRow &&
          other.id == this.id &&
          other.title == this.title &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.derivedFrom == this.derivedFrom);
}

class SequenceRowsCompanion extends UpdateCompanion<SequenceRow> {
  final Value<int> id;
  final Value<String> title;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<String?> derivedFrom;
  const SequenceRowsCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.derivedFrom = const Value.absent(),
  });
  SequenceRowsCompanion.insert({
    this.id = const Value.absent(),
    required String title,
    required DateTime createdAt,
    required DateTime updatedAt,
    this.derivedFrom = const Value.absent(),
  }) : title = Value(title),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<SequenceRow> custom({
    Expression<int>? id,
    Expression<String>? title,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<String>? derivedFrom,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (derivedFrom != null) 'derived_from': derivedFrom,
    });
  }

  SequenceRowsCompanion copyWith({
    Value<int>? id,
    Value<String>? title,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<String?>? derivedFrom,
  }) {
    return SequenceRowsCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      derivedFrom: derivedFrom ?? this.derivedFrom,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (derivedFrom.present) {
      map['derived_from'] = Variable<String>(derivedFrom.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SequenceRowsCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('derivedFrom: $derivedFrom')
          ..write(')'))
        .toString();
  }
}

class $StepRowsTable extends StepRows with TableInfo<$StepRowsTable, StepRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StepRowsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _sequenceIdMeta = const VerificationMeta(
    'sequenceId',
  );
  @override
  late final GeneratedColumn<int> sequenceId = GeneratedColumn<int>(
    'sequence_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _positionMeta = const VerificationMeta(
    'position',
  );
  @override
  late final GeneratedColumn<int> position = GeneratedColumn<int>(
    'position',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _kindMeta = const VerificationMeta('kind');
  @override
  late final GeneratedColumn<String> kind = GeneratedColumn<String>(
    'kind',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _durationSecondsMeta = const VerificationMeta(
    'durationSeconds',
  );
  @override
  late final GeneratedColumn<int> durationSeconds = GeneratedColumn<int>(
    'duration_seconds',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _breathInMeta = const VerificationMeta(
    'breathIn',
  );
  @override
  late final GeneratedColumn<int> breathIn = GeneratedColumn<int>(
    'breath_in',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _breathHoldInMeta = const VerificationMeta(
    'breathHoldIn',
  );
  @override
  late final GeneratedColumn<int> breathHoldIn = GeneratedColumn<int>(
    'breath_hold_in',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _breathOutMeta = const VerificationMeta(
    'breathOut',
  );
  @override
  late final GeneratedColumn<int> breathOut = GeneratedColumn<int>(
    'breath_out',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _breathHoldOutMeta = const VerificationMeta(
    'breathHoldOut',
  );
  @override
  late final GeneratedColumn<int> breathHoldOut = GeneratedColumn<int>(
    'breath_hold_out',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _cyclesMeta = const VerificationMeta('cycles');
  @override
  late final GeneratedColumn<int> cycles = GeneratedColumn<int>(
    'cycles',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _asanaIdMeta = const VerificationMeta(
    'asanaId',
  );
  @override
  late final GeneratedColumn<String> asanaId = GeneratedColumn<String>(
    'asana_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sideMeta = const VerificationMeta('side');
  @override
  late final GeneratedColumn<String> side = GeneratedColumn<String>(
    'side',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _focusObjectMeta = const VerificationMeta(
    'focusObject',
  );
  @override
  late final GeneratedColumn<String> focusObject = GeneratedColumn<String>(
    'focus_object',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _textIdMeta = const VerificationMeta('textId');
  @override
  late final GeneratedColumn<String> textId = GeneratedColumn<String>(
    'text_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    sequenceId,
    position,
    kind,
    durationSeconds,
    breathIn,
    breathHoldIn,
    breathOut,
    breathHoldOut,
    cycles,
    asanaId,
    side,
    focusObject,
    textId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'step_rows';
  @override
  VerificationContext validateIntegrity(
    Insertable<StepRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('sequence_id')) {
      context.handle(
        _sequenceIdMeta,
        sequenceId.isAcceptableOrUnknown(data['sequence_id']!, _sequenceIdMeta),
      );
    } else if (isInserting) {
      context.missing(_sequenceIdMeta);
    }
    if (data.containsKey('position')) {
      context.handle(
        _positionMeta,
        position.isAcceptableOrUnknown(data['position']!, _positionMeta),
      );
    } else if (isInserting) {
      context.missing(_positionMeta);
    }
    if (data.containsKey('kind')) {
      context.handle(
        _kindMeta,
        kind.isAcceptableOrUnknown(data['kind']!, _kindMeta),
      );
    } else if (isInserting) {
      context.missing(_kindMeta);
    }
    if (data.containsKey('duration_seconds')) {
      context.handle(
        _durationSecondsMeta,
        durationSeconds.isAcceptableOrUnknown(
          data['duration_seconds']!,
          _durationSecondsMeta,
        ),
      );
    }
    if (data.containsKey('breath_in')) {
      context.handle(
        _breathInMeta,
        breathIn.isAcceptableOrUnknown(data['breath_in']!, _breathInMeta),
      );
    }
    if (data.containsKey('breath_hold_in')) {
      context.handle(
        _breathHoldInMeta,
        breathHoldIn.isAcceptableOrUnknown(
          data['breath_hold_in']!,
          _breathHoldInMeta,
        ),
      );
    }
    if (data.containsKey('breath_out')) {
      context.handle(
        _breathOutMeta,
        breathOut.isAcceptableOrUnknown(data['breath_out']!, _breathOutMeta),
      );
    }
    if (data.containsKey('breath_hold_out')) {
      context.handle(
        _breathHoldOutMeta,
        breathHoldOut.isAcceptableOrUnknown(
          data['breath_hold_out']!,
          _breathHoldOutMeta,
        ),
      );
    }
    if (data.containsKey('cycles')) {
      context.handle(
        _cyclesMeta,
        cycles.isAcceptableOrUnknown(data['cycles']!, _cyclesMeta),
      );
    }
    if (data.containsKey('asana_id')) {
      context.handle(
        _asanaIdMeta,
        asanaId.isAcceptableOrUnknown(data['asana_id']!, _asanaIdMeta),
      );
    }
    if (data.containsKey('side')) {
      context.handle(
        _sideMeta,
        side.isAcceptableOrUnknown(data['side']!, _sideMeta),
      );
    }
    if (data.containsKey('focus_object')) {
      context.handle(
        _focusObjectMeta,
        focusObject.isAcceptableOrUnknown(
          data['focus_object']!,
          _focusObjectMeta,
        ),
      );
    }
    if (data.containsKey('text_id')) {
      context.handle(
        _textIdMeta,
        textId.isAcceptableOrUnknown(data['text_id']!, _textIdMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  StepRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StepRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      sequenceId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sequence_id'],
      )!,
      position: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}position'],
      )!,
      kind: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}kind'],
      )!,
      durationSeconds: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}duration_seconds'],
      ),
      breathIn: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}breath_in'],
      ),
      breathHoldIn: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}breath_hold_in'],
      ),
      breathOut: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}breath_out'],
      ),
      breathHoldOut: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}breath_hold_out'],
      ),
      cycles: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}cycles'],
      ),
      asanaId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}asana_id'],
      ),
      side: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}side'],
      ),
      focusObject: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}focus_object'],
      ),
      textId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}text_id'],
      ),
    );
  }

  @override
  $StepRowsTable createAlias(String alias) {
    return $StepRowsTable(attachedDatabase, alias);
  }
}

class StepRow extends DataClass implements Insertable<StepRow> {
  final int id;
  final int sequenceId;
  final int position;
  final String kind;
  final int? durationSeconds;
  final int? breathIn;
  final int? breathHoldIn;
  final int? breathOut;
  final int? breathHoldOut;
  final int? cycles;
  final String? asanaId;
  final String? side;
  final String? focusObject;
  final String? textId;
  const StepRow({
    required this.id,
    required this.sequenceId,
    required this.position,
    required this.kind,
    this.durationSeconds,
    this.breathIn,
    this.breathHoldIn,
    this.breathOut,
    this.breathHoldOut,
    this.cycles,
    this.asanaId,
    this.side,
    this.focusObject,
    this.textId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['sequence_id'] = Variable<int>(sequenceId);
    map['position'] = Variable<int>(position);
    map['kind'] = Variable<String>(kind);
    if (!nullToAbsent || durationSeconds != null) {
      map['duration_seconds'] = Variable<int>(durationSeconds);
    }
    if (!nullToAbsent || breathIn != null) {
      map['breath_in'] = Variable<int>(breathIn);
    }
    if (!nullToAbsent || breathHoldIn != null) {
      map['breath_hold_in'] = Variable<int>(breathHoldIn);
    }
    if (!nullToAbsent || breathOut != null) {
      map['breath_out'] = Variable<int>(breathOut);
    }
    if (!nullToAbsent || breathHoldOut != null) {
      map['breath_hold_out'] = Variable<int>(breathHoldOut);
    }
    if (!nullToAbsent || cycles != null) {
      map['cycles'] = Variable<int>(cycles);
    }
    if (!nullToAbsent || asanaId != null) {
      map['asana_id'] = Variable<String>(asanaId);
    }
    if (!nullToAbsent || side != null) {
      map['side'] = Variable<String>(side);
    }
    if (!nullToAbsent || focusObject != null) {
      map['focus_object'] = Variable<String>(focusObject);
    }
    if (!nullToAbsent || textId != null) {
      map['text_id'] = Variable<String>(textId);
    }
    return map;
  }

  StepRowsCompanion toCompanion(bool nullToAbsent) {
    return StepRowsCompanion(
      id: Value(id),
      sequenceId: Value(sequenceId),
      position: Value(position),
      kind: Value(kind),
      durationSeconds: durationSeconds == null && nullToAbsent
          ? const Value.absent()
          : Value(durationSeconds),
      breathIn: breathIn == null && nullToAbsent
          ? const Value.absent()
          : Value(breathIn),
      breathHoldIn: breathHoldIn == null && nullToAbsent
          ? const Value.absent()
          : Value(breathHoldIn),
      breathOut: breathOut == null && nullToAbsent
          ? const Value.absent()
          : Value(breathOut),
      breathHoldOut: breathHoldOut == null && nullToAbsent
          ? const Value.absent()
          : Value(breathHoldOut),
      cycles: cycles == null && nullToAbsent
          ? const Value.absent()
          : Value(cycles),
      asanaId: asanaId == null && nullToAbsent
          ? const Value.absent()
          : Value(asanaId),
      side: side == null && nullToAbsent ? const Value.absent() : Value(side),
      focusObject: focusObject == null && nullToAbsent
          ? const Value.absent()
          : Value(focusObject),
      textId: textId == null && nullToAbsent
          ? const Value.absent()
          : Value(textId),
    );
  }

  factory StepRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StepRow(
      id: serializer.fromJson<int>(json['id']),
      sequenceId: serializer.fromJson<int>(json['sequenceId']),
      position: serializer.fromJson<int>(json['position']),
      kind: serializer.fromJson<String>(json['kind']),
      durationSeconds: serializer.fromJson<int?>(json['durationSeconds']),
      breathIn: serializer.fromJson<int?>(json['breathIn']),
      breathHoldIn: serializer.fromJson<int?>(json['breathHoldIn']),
      breathOut: serializer.fromJson<int?>(json['breathOut']),
      breathHoldOut: serializer.fromJson<int?>(json['breathHoldOut']),
      cycles: serializer.fromJson<int?>(json['cycles']),
      asanaId: serializer.fromJson<String?>(json['asanaId']),
      side: serializer.fromJson<String?>(json['side']),
      focusObject: serializer.fromJson<String?>(json['focusObject']),
      textId: serializer.fromJson<String?>(json['textId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'sequenceId': serializer.toJson<int>(sequenceId),
      'position': serializer.toJson<int>(position),
      'kind': serializer.toJson<String>(kind),
      'durationSeconds': serializer.toJson<int?>(durationSeconds),
      'breathIn': serializer.toJson<int?>(breathIn),
      'breathHoldIn': serializer.toJson<int?>(breathHoldIn),
      'breathOut': serializer.toJson<int?>(breathOut),
      'breathHoldOut': serializer.toJson<int?>(breathHoldOut),
      'cycles': serializer.toJson<int?>(cycles),
      'asanaId': serializer.toJson<String?>(asanaId),
      'side': serializer.toJson<String?>(side),
      'focusObject': serializer.toJson<String?>(focusObject),
      'textId': serializer.toJson<String?>(textId),
    };
  }

  StepRow copyWith({
    int? id,
    int? sequenceId,
    int? position,
    String? kind,
    Value<int?> durationSeconds = const Value.absent(),
    Value<int?> breathIn = const Value.absent(),
    Value<int?> breathHoldIn = const Value.absent(),
    Value<int?> breathOut = const Value.absent(),
    Value<int?> breathHoldOut = const Value.absent(),
    Value<int?> cycles = const Value.absent(),
    Value<String?> asanaId = const Value.absent(),
    Value<String?> side = const Value.absent(),
    Value<String?> focusObject = const Value.absent(),
    Value<String?> textId = const Value.absent(),
  }) => StepRow(
    id: id ?? this.id,
    sequenceId: sequenceId ?? this.sequenceId,
    position: position ?? this.position,
    kind: kind ?? this.kind,
    durationSeconds: durationSeconds.present
        ? durationSeconds.value
        : this.durationSeconds,
    breathIn: breathIn.present ? breathIn.value : this.breathIn,
    breathHoldIn: breathHoldIn.present ? breathHoldIn.value : this.breathHoldIn,
    breathOut: breathOut.present ? breathOut.value : this.breathOut,
    breathHoldOut: breathHoldOut.present
        ? breathHoldOut.value
        : this.breathHoldOut,
    cycles: cycles.present ? cycles.value : this.cycles,
    asanaId: asanaId.present ? asanaId.value : this.asanaId,
    side: side.present ? side.value : this.side,
    focusObject: focusObject.present ? focusObject.value : this.focusObject,
    textId: textId.present ? textId.value : this.textId,
  );
  StepRow copyWithCompanion(StepRowsCompanion data) {
    return StepRow(
      id: data.id.present ? data.id.value : this.id,
      sequenceId: data.sequenceId.present
          ? data.sequenceId.value
          : this.sequenceId,
      position: data.position.present ? data.position.value : this.position,
      kind: data.kind.present ? data.kind.value : this.kind,
      durationSeconds: data.durationSeconds.present
          ? data.durationSeconds.value
          : this.durationSeconds,
      breathIn: data.breathIn.present ? data.breathIn.value : this.breathIn,
      breathHoldIn: data.breathHoldIn.present
          ? data.breathHoldIn.value
          : this.breathHoldIn,
      breathOut: data.breathOut.present ? data.breathOut.value : this.breathOut,
      breathHoldOut: data.breathHoldOut.present
          ? data.breathHoldOut.value
          : this.breathHoldOut,
      cycles: data.cycles.present ? data.cycles.value : this.cycles,
      asanaId: data.asanaId.present ? data.asanaId.value : this.asanaId,
      side: data.side.present ? data.side.value : this.side,
      focusObject: data.focusObject.present
          ? data.focusObject.value
          : this.focusObject,
      textId: data.textId.present ? data.textId.value : this.textId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('StepRow(')
          ..write('id: $id, ')
          ..write('sequenceId: $sequenceId, ')
          ..write('position: $position, ')
          ..write('kind: $kind, ')
          ..write('durationSeconds: $durationSeconds, ')
          ..write('breathIn: $breathIn, ')
          ..write('breathHoldIn: $breathHoldIn, ')
          ..write('breathOut: $breathOut, ')
          ..write('breathHoldOut: $breathHoldOut, ')
          ..write('cycles: $cycles, ')
          ..write('asanaId: $asanaId, ')
          ..write('side: $side, ')
          ..write('focusObject: $focusObject, ')
          ..write('textId: $textId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    sequenceId,
    position,
    kind,
    durationSeconds,
    breathIn,
    breathHoldIn,
    breathOut,
    breathHoldOut,
    cycles,
    asanaId,
    side,
    focusObject,
    textId,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StepRow &&
          other.id == this.id &&
          other.sequenceId == this.sequenceId &&
          other.position == this.position &&
          other.kind == this.kind &&
          other.durationSeconds == this.durationSeconds &&
          other.breathIn == this.breathIn &&
          other.breathHoldIn == this.breathHoldIn &&
          other.breathOut == this.breathOut &&
          other.breathHoldOut == this.breathHoldOut &&
          other.cycles == this.cycles &&
          other.asanaId == this.asanaId &&
          other.side == this.side &&
          other.focusObject == this.focusObject &&
          other.textId == this.textId);
}

class StepRowsCompanion extends UpdateCompanion<StepRow> {
  final Value<int> id;
  final Value<int> sequenceId;
  final Value<int> position;
  final Value<String> kind;
  final Value<int?> durationSeconds;
  final Value<int?> breathIn;
  final Value<int?> breathHoldIn;
  final Value<int?> breathOut;
  final Value<int?> breathHoldOut;
  final Value<int?> cycles;
  final Value<String?> asanaId;
  final Value<String?> side;
  final Value<String?> focusObject;
  final Value<String?> textId;
  const StepRowsCompanion({
    this.id = const Value.absent(),
    this.sequenceId = const Value.absent(),
    this.position = const Value.absent(),
    this.kind = const Value.absent(),
    this.durationSeconds = const Value.absent(),
    this.breathIn = const Value.absent(),
    this.breathHoldIn = const Value.absent(),
    this.breathOut = const Value.absent(),
    this.breathHoldOut = const Value.absent(),
    this.cycles = const Value.absent(),
    this.asanaId = const Value.absent(),
    this.side = const Value.absent(),
    this.focusObject = const Value.absent(),
    this.textId = const Value.absent(),
  });
  StepRowsCompanion.insert({
    this.id = const Value.absent(),
    required int sequenceId,
    required int position,
    required String kind,
    this.durationSeconds = const Value.absent(),
    this.breathIn = const Value.absent(),
    this.breathHoldIn = const Value.absent(),
    this.breathOut = const Value.absent(),
    this.breathHoldOut = const Value.absent(),
    this.cycles = const Value.absent(),
    this.asanaId = const Value.absent(),
    this.side = const Value.absent(),
    this.focusObject = const Value.absent(),
    this.textId = const Value.absent(),
  }) : sequenceId = Value(sequenceId),
       position = Value(position),
       kind = Value(kind);
  static Insertable<StepRow> custom({
    Expression<int>? id,
    Expression<int>? sequenceId,
    Expression<int>? position,
    Expression<String>? kind,
    Expression<int>? durationSeconds,
    Expression<int>? breathIn,
    Expression<int>? breathHoldIn,
    Expression<int>? breathOut,
    Expression<int>? breathHoldOut,
    Expression<int>? cycles,
    Expression<String>? asanaId,
    Expression<String>? side,
    Expression<String>? focusObject,
    Expression<String>? textId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (sequenceId != null) 'sequence_id': sequenceId,
      if (position != null) 'position': position,
      if (kind != null) 'kind': kind,
      if (durationSeconds != null) 'duration_seconds': durationSeconds,
      if (breathIn != null) 'breath_in': breathIn,
      if (breathHoldIn != null) 'breath_hold_in': breathHoldIn,
      if (breathOut != null) 'breath_out': breathOut,
      if (breathHoldOut != null) 'breath_hold_out': breathHoldOut,
      if (cycles != null) 'cycles': cycles,
      if (asanaId != null) 'asana_id': asanaId,
      if (side != null) 'side': side,
      if (focusObject != null) 'focus_object': focusObject,
      if (textId != null) 'text_id': textId,
    });
  }

  StepRowsCompanion copyWith({
    Value<int>? id,
    Value<int>? sequenceId,
    Value<int>? position,
    Value<String>? kind,
    Value<int?>? durationSeconds,
    Value<int?>? breathIn,
    Value<int?>? breathHoldIn,
    Value<int?>? breathOut,
    Value<int?>? breathHoldOut,
    Value<int?>? cycles,
    Value<String?>? asanaId,
    Value<String?>? side,
    Value<String?>? focusObject,
    Value<String?>? textId,
  }) {
    return StepRowsCompanion(
      id: id ?? this.id,
      sequenceId: sequenceId ?? this.sequenceId,
      position: position ?? this.position,
      kind: kind ?? this.kind,
      durationSeconds: durationSeconds ?? this.durationSeconds,
      breathIn: breathIn ?? this.breathIn,
      breathHoldIn: breathHoldIn ?? this.breathHoldIn,
      breathOut: breathOut ?? this.breathOut,
      breathHoldOut: breathHoldOut ?? this.breathHoldOut,
      cycles: cycles ?? this.cycles,
      asanaId: asanaId ?? this.asanaId,
      side: side ?? this.side,
      focusObject: focusObject ?? this.focusObject,
      textId: textId ?? this.textId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (sequenceId.present) {
      map['sequence_id'] = Variable<int>(sequenceId.value);
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(kind.value);
    }
    if (durationSeconds.present) {
      map['duration_seconds'] = Variable<int>(durationSeconds.value);
    }
    if (breathIn.present) {
      map['breath_in'] = Variable<int>(breathIn.value);
    }
    if (breathHoldIn.present) {
      map['breath_hold_in'] = Variable<int>(breathHoldIn.value);
    }
    if (breathOut.present) {
      map['breath_out'] = Variable<int>(breathOut.value);
    }
    if (breathHoldOut.present) {
      map['breath_hold_out'] = Variable<int>(breathHoldOut.value);
    }
    if (cycles.present) {
      map['cycles'] = Variable<int>(cycles.value);
    }
    if (asanaId.present) {
      map['asana_id'] = Variable<String>(asanaId.value);
    }
    if (side.present) {
      map['side'] = Variable<String>(side.value);
    }
    if (focusObject.present) {
      map['focus_object'] = Variable<String>(focusObject.value);
    }
    if (textId.present) {
      map['text_id'] = Variable<String>(textId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StepRowsCompanion(')
          ..write('id: $id, ')
          ..write('sequenceId: $sequenceId, ')
          ..write('position: $position, ')
          ..write('kind: $kind, ')
          ..write('durationSeconds: $durationSeconds, ')
          ..write('breathIn: $breathIn, ')
          ..write('breathHoldIn: $breathHoldIn, ')
          ..write('breathOut: $breathOut, ')
          ..write('breathHoldOut: $breathHoldOut, ')
          ..write('cycles: $cycles, ')
          ..write('asanaId: $asanaId, ')
          ..write('side: $side, ')
          ..write('focusObject: $focusObject, ')
          ..write('textId: $textId')
          ..write(')'))
        .toString();
  }
}

abstract class _$SadhanaDatabase extends GeneratedDatabase {
  _$SadhanaDatabase(QueryExecutor e) : super(e);
  $SadhanaDatabaseManager get managers => $SadhanaDatabaseManager(this);
  late final $SessionsTable sessions = $SessionsTable(this);
  late final $JournalEntriesTable journalEntries = $JournalEntriesTable(this);
  late final $TextAnnotationsTable textAnnotations = $TextAnnotationsTable(
    this,
  );
  late final $TextEncountersTable textEncounters = $TextEncountersTable(this);
  late final $SequenceRowsTable sequenceRows = $SequenceRowsTable(this);
  late final $StepRowsTable stepRows = $StepRowsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    sessions,
    journalEntries,
    textAnnotations,
    textEncounters,
    sequenceRows,
    stepRows,
  ];
}

typedef $$SessionsTableCreateCompanionBuilder =
    SessionsCompanion Function({
      Value<int> id,
      required String sequenceId,
      required DateTime startedAt,
      Value<DateTime?> endedAt,
      required int plannedSeconds,
      Value<int> practisedSeconds,
      Value<bool> completed,
    });
typedef $$SessionsTableUpdateCompanionBuilder =
    SessionsCompanion Function({
      Value<int> id,
      Value<String> sequenceId,
      Value<DateTime> startedAt,
      Value<DateTime?> endedAt,
      Value<int> plannedSeconds,
      Value<int> practisedSeconds,
      Value<bool> completed,
    });

final class $$SessionsTableReferences
    extends BaseReferences<_$SadhanaDatabase, $SessionsTable, Session> {
  $$SessionsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$JournalEntriesTable, List<JournalEntry>>
  _journalEntriesRefsTable(_$SadhanaDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.journalEntries,
        aliasName: $_aliasNameGenerator(
          db.sessions.id,
          db.journalEntries.sessionId,
        ),
      );

  $$JournalEntriesTableProcessedTableManager get journalEntriesRefs {
    final manager = $$JournalEntriesTableTableManager(
      $_db,
      $_db.journalEntries,
    ).filter((f) => f.sessionId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_journalEntriesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$TextEncountersTable, List<TextEncounter>>
  _textEncountersRefsTable(_$SadhanaDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.textEncounters,
        aliasName: $_aliasNameGenerator(
          db.sessions.id,
          db.textEncounters.sessionId,
        ),
      );

  $$TextEncountersTableProcessedTableManager get textEncountersRefs {
    final manager = $$TextEncountersTableTableManager(
      $_db,
      $_db.textEncounters,
    ).filter((f) => f.sessionId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_textEncountersRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$SessionsTableFilterComposer
    extends Composer<_$SadhanaDatabase, $SessionsTable> {
  $$SessionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sequenceId => $composableBuilder(
    column: $table.sequenceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get endedAt => $composableBuilder(
    column: $table.endedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get plannedSeconds => $composableBuilder(
    column: $table.plannedSeconds,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get practisedSeconds => $composableBuilder(
    column: $table.practisedSeconds,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get completed => $composableBuilder(
    column: $table.completed,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> journalEntriesRefs(
    Expression<bool> Function($$JournalEntriesTableFilterComposer f) f,
  ) {
    final $$JournalEntriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.journalEntries,
      getReferencedColumn: (t) => t.sessionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$JournalEntriesTableFilterComposer(
            $db: $db,
            $table: $db.journalEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> textEncountersRefs(
    Expression<bool> Function($$TextEncountersTableFilterComposer f) f,
  ) {
    final $$TextEncountersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.textEncounters,
      getReferencedColumn: (t) => t.sessionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TextEncountersTableFilterComposer(
            $db: $db,
            $table: $db.textEncounters,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$SessionsTableOrderingComposer
    extends Composer<_$SadhanaDatabase, $SessionsTable> {
  $$SessionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sequenceId => $composableBuilder(
    column: $table.sequenceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get endedAt => $composableBuilder(
    column: $table.endedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get plannedSeconds => $composableBuilder(
    column: $table.plannedSeconds,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get practisedSeconds => $composableBuilder(
    column: $table.practisedSeconds,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get completed => $composableBuilder(
    column: $table.completed,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SessionsTableAnnotationComposer
    extends Composer<_$SadhanaDatabase, $SessionsTable> {
  $$SessionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get sequenceId => $composableBuilder(
    column: $table.sequenceId,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get startedAt =>
      $composableBuilder(column: $table.startedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get endedAt =>
      $composableBuilder(column: $table.endedAt, builder: (column) => column);

  GeneratedColumn<int> get plannedSeconds => $composableBuilder(
    column: $table.plannedSeconds,
    builder: (column) => column,
  );

  GeneratedColumn<int> get practisedSeconds => $composableBuilder(
    column: $table.practisedSeconds,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get completed =>
      $composableBuilder(column: $table.completed, builder: (column) => column);

  Expression<T> journalEntriesRefs<T extends Object>(
    Expression<T> Function($$JournalEntriesTableAnnotationComposer a) f,
  ) {
    final $$JournalEntriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.journalEntries,
      getReferencedColumn: (t) => t.sessionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$JournalEntriesTableAnnotationComposer(
            $db: $db,
            $table: $db.journalEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> textEncountersRefs<T extends Object>(
    Expression<T> Function($$TextEncountersTableAnnotationComposer a) f,
  ) {
    final $$TextEncountersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.textEncounters,
      getReferencedColumn: (t) => t.sessionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TextEncountersTableAnnotationComposer(
            $db: $db,
            $table: $db.textEncounters,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$SessionsTableTableManager
    extends
        RootTableManager<
          _$SadhanaDatabase,
          $SessionsTable,
          Session,
          $$SessionsTableFilterComposer,
          $$SessionsTableOrderingComposer,
          $$SessionsTableAnnotationComposer,
          $$SessionsTableCreateCompanionBuilder,
          $$SessionsTableUpdateCompanionBuilder,
          (Session, $$SessionsTableReferences),
          Session,
          PrefetchHooks Function({
            bool journalEntriesRefs,
            bool textEncountersRefs,
          })
        > {
  $$SessionsTableTableManager(_$SadhanaDatabase db, $SessionsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SessionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SessionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SessionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> sequenceId = const Value.absent(),
                Value<DateTime> startedAt = const Value.absent(),
                Value<DateTime?> endedAt = const Value.absent(),
                Value<int> plannedSeconds = const Value.absent(),
                Value<int> practisedSeconds = const Value.absent(),
                Value<bool> completed = const Value.absent(),
              }) => SessionsCompanion(
                id: id,
                sequenceId: sequenceId,
                startedAt: startedAt,
                endedAt: endedAt,
                plannedSeconds: plannedSeconds,
                practisedSeconds: practisedSeconds,
                completed: completed,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String sequenceId,
                required DateTime startedAt,
                Value<DateTime?> endedAt = const Value.absent(),
                required int plannedSeconds,
                Value<int> practisedSeconds = const Value.absent(),
                Value<bool> completed = const Value.absent(),
              }) => SessionsCompanion.insert(
                id: id,
                sequenceId: sequenceId,
                startedAt: startedAt,
                endedAt: endedAt,
                plannedSeconds: plannedSeconds,
                practisedSeconds: practisedSeconds,
                completed: completed,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$SessionsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({journalEntriesRefs = false, textEncountersRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (journalEntriesRefs) db.journalEntries,
                    if (textEncountersRefs) db.textEncounters,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (journalEntriesRefs)
                        await $_getPrefetchedData<
                          Session,
                          $SessionsTable,
                          JournalEntry
                        >(
                          currentTable: table,
                          referencedTable: $$SessionsTableReferences
                              ._journalEntriesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$SessionsTableReferences(
                                db,
                                table,
                                p0,
                              ).journalEntriesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.sessionId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (textEncountersRefs)
                        await $_getPrefetchedData<
                          Session,
                          $SessionsTable,
                          TextEncounter
                        >(
                          currentTable: table,
                          referencedTable: $$SessionsTableReferences
                              ._textEncountersRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$SessionsTableReferences(
                                db,
                                table,
                                p0,
                              ).textEncountersRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.sessionId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$SessionsTableProcessedTableManager =
    ProcessedTableManager<
      _$SadhanaDatabase,
      $SessionsTable,
      Session,
      $$SessionsTableFilterComposer,
      $$SessionsTableOrderingComposer,
      $$SessionsTableAnnotationComposer,
      $$SessionsTableCreateCompanionBuilder,
      $$SessionsTableUpdateCompanionBuilder,
      (Session, $$SessionsTableReferences),
      Session,
      PrefetchHooks Function({bool journalEntriesRefs, bool textEncountersRefs})
    >;
typedef $$JournalEntriesTableCreateCompanionBuilder =
    JournalEntriesCompanion Function({
      Value<int> id,
      Value<int?> sessionId,
      required DateTime createdAt,
      Value<int?> sthira,
      Value<int?> sukha,
      Value<String> note,
      Value<String> angas,
    });
typedef $$JournalEntriesTableUpdateCompanionBuilder =
    JournalEntriesCompanion Function({
      Value<int> id,
      Value<int?> sessionId,
      Value<DateTime> createdAt,
      Value<int?> sthira,
      Value<int?> sukha,
      Value<String> note,
      Value<String> angas,
    });

final class $$JournalEntriesTableReferences
    extends
        BaseReferences<_$SadhanaDatabase, $JournalEntriesTable, JournalEntry> {
  $$JournalEntriesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $SessionsTable _sessionIdTable(_$SadhanaDatabase db) =>
      db.sessions.createAlias(
        $_aliasNameGenerator(db.journalEntries.sessionId, db.sessions.id),
      );

  $$SessionsTableProcessedTableManager? get sessionId {
    final $_column = $_itemColumn<int>('session_id');
    if ($_column == null) return null;
    final manager = $$SessionsTableTableManager(
      $_db,
      $_db.sessions,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_sessionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$JournalEntriesTableFilterComposer
    extends Composer<_$SadhanaDatabase, $JournalEntriesTable> {
  $$JournalEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sthira => $composableBuilder(
    column: $table.sthira,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sukha => $composableBuilder(
    column: $table.sukha,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get angas => $composableBuilder(
    column: $table.angas,
    builder: (column) => ColumnFilters(column),
  );

  $$SessionsTableFilterComposer get sessionId {
    final $$SessionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionId,
      referencedTable: $db.sessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SessionsTableFilterComposer(
            $db: $db,
            $table: $db.sessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$JournalEntriesTableOrderingComposer
    extends Composer<_$SadhanaDatabase, $JournalEntriesTable> {
  $$JournalEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sthira => $composableBuilder(
    column: $table.sthira,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sukha => $composableBuilder(
    column: $table.sukha,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get angas => $composableBuilder(
    column: $table.angas,
    builder: (column) => ColumnOrderings(column),
  );

  $$SessionsTableOrderingComposer get sessionId {
    final $$SessionsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionId,
      referencedTable: $db.sessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SessionsTableOrderingComposer(
            $db: $db,
            $table: $db.sessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$JournalEntriesTableAnnotationComposer
    extends Composer<_$SadhanaDatabase, $JournalEntriesTable> {
  $$JournalEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get sthira =>
      $composableBuilder(column: $table.sthira, builder: (column) => column);

  GeneratedColumn<int> get sukha =>
      $composableBuilder(column: $table.sukha, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<String> get angas =>
      $composableBuilder(column: $table.angas, builder: (column) => column);

  $$SessionsTableAnnotationComposer get sessionId {
    final $$SessionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionId,
      referencedTable: $db.sessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SessionsTableAnnotationComposer(
            $db: $db,
            $table: $db.sessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$JournalEntriesTableTableManager
    extends
        RootTableManager<
          _$SadhanaDatabase,
          $JournalEntriesTable,
          JournalEntry,
          $$JournalEntriesTableFilterComposer,
          $$JournalEntriesTableOrderingComposer,
          $$JournalEntriesTableAnnotationComposer,
          $$JournalEntriesTableCreateCompanionBuilder,
          $$JournalEntriesTableUpdateCompanionBuilder,
          (JournalEntry, $$JournalEntriesTableReferences),
          JournalEntry,
          PrefetchHooks Function({bool sessionId})
        > {
  $$JournalEntriesTableTableManager(
    _$SadhanaDatabase db,
    $JournalEntriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$JournalEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$JournalEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$JournalEntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int?> sessionId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int?> sthira = const Value.absent(),
                Value<int?> sukha = const Value.absent(),
                Value<String> note = const Value.absent(),
                Value<String> angas = const Value.absent(),
              }) => JournalEntriesCompanion(
                id: id,
                sessionId: sessionId,
                createdAt: createdAt,
                sthira: sthira,
                sukha: sukha,
                note: note,
                angas: angas,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int?> sessionId = const Value.absent(),
                required DateTime createdAt,
                Value<int?> sthira = const Value.absent(),
                Value<int?> sukha = const Value.absent(),
                Value<String> note = const Value.absent(),
                Value<String> angas = const Value.absent(),
              }) => JournalEntriesCompanion.insert(
                id: id,
                sessionId: sessionId,
                createdAt: createdAt,
                sthira: sthira,
                sukha: sukha,
                note: note,
                angas: angas,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$JournalEntriesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({sessionId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (sessionId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.sessionId,
                                referencedTable: $$JournalEntriesTableReferences
                                    ._sessionIdTable(db),
                                referencedColumn:
                                    $$JournalEntriesTableReferences
                                        ._sessionIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$JournalEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$SadhanaDatabase,
      $JournalEntriesTable,
      JournalEntry,
      $$JournalEntriesTableFilterComposer,
      $$JournalEntriesTableOrderingComposer,
      $$JournalEntriesTableAnnotationComposer,
      $$JournalEntriesTableCreateCompanionBuilder,
      $$JournalEntriesTableUpdateCompanionBuilder,
      (JournalEntry, $$JournalEntriesTableReferences),
      JournalEntry,
      PrefetchHooks Function({bool sessionId})
    >;
typedef $$TextAnnotationsTableCreateCompanionBuilder =
    TextAnnotationsCompanion Function({
      Value<int> id,
      required String textId,
      required String note,
      required DateTime createdAt,
    });
typedef $$TextAnnotationsTableUpdateCompanionBuilder =
    TextAnnotationsCompanion Function({
      Value<int> id,
      Value<String> textId,
      Value<String> note,
      Value<DateTime> createdAt,
    });

class $$TextAnnotationsTableFilterComposer
    extends Composer<_$SadhanaDatabase, $TextAnnotationsTable> {
  $$TextAnnotationsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get textId => $composableBuilder(
    column: $table.textId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$TextAnnotationsTableOrderingComposer
    extends Composer<_$SadhanaDatabase, $TextAnnotationsTable> {
  $$TextAnnotationsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get textId => $composableBuilder(
    column: $table.textId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TextAnnotationsTableAnnotationComposer
    extends Composer<_$SadhanaDatabase, $TextAnnotationsTable> {
  $$TextAnnotationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get textId =>
      $composableBuilder(column: $table.textId, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$TextAnnotationsTableTableManager
    extends
        RootTableManager<
          _$SadhanaDatabase,
          $TextAnnotationsTable,
          TextAnnotation,
          $$TextAnnotationsTableFilterComposer,
          $$TextAnnotationsTableOrderingComposer,
          $$TextAnnotationsTableAnnotationComposer,
          $$TextAnnotationsTableCreateCompanionBuilder,
          $$TextAnnotationsTableUpdateCompanionBuilder,
          (
            TextAnnotation,
            BaseReferences<
              _$SadhanaDatabase,
              $TextAnnotationsTable,
              TextAnnotation
            >,
          ),
          TextAnnotation,
          PrefetchHooks Function()
        > {
  $$TextAnnotationsTableTableManager(
    _$SadhanaDatabase db,
    $TextAnnotationsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TextAnnotationsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TextAnnotationsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TextAnnotationsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> textId = const Value.absent(),
                Value<String> note = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => TextAnnotationsCompanion(
                id: id,
                textId: textId,
                note: note,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String textId,
                required String note,
                required DateTime createdAt,
              }) => TextAnnotationsCompanion.insert(
                id: id,
                textId: textId,
                note: note,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$TextAnnotationsTableProcessedTableManager =
    ProcessedTableManager<
      _$SadhanaDatabase,
      $TextAnnotationsTable,
      TextAnnotation,
      $$TextAnnotationsTableFilterComposer,
      $$TextAnnotationsTableOrderingComposer,
      $$TextAnnotationsTableAnnotationComposer,
      $$TextAnnotationsTableCreateCompanionBuilder,
      $$TextAnnotationsTableUpdateCompanionBuilder,
      (
        TextAnnotation,
        BaseReferences<
          _$SadhanaDatabase,
          $TextAnnotationsTable,
          TextAnnotation
        >,
      ),
      TextAnnotation,
      PrefetchHooks Function()
    >;
typedef $$TextEncountersTableCreateCompanionBuilder =
    TextEncountersCompanion Function({
      Value<int> id,
      required String textId,
      Value<int?> sessionId,
      required DateTime at,
    });
typedef $$TextEncountersTableUpdateCompanionBuilder =
    TextEncountersCompanion Function({
      Value<int> id,
      Value<String> textId,
      Value<int?> sessionId,
      Value<DateTime> at,
    });

final class $$TextEncountersTableReferences
    extends
        BaseReferences<_$SadhanaDatabase, $TextEncountersTable, TextEncounter> {
  $$TextEncountersTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $SessionsTable _sessionIdTable(_$SadhanaDatabase db) =>
      db.sessions.createAlias(
        $_aliasNameGenerator(db.textEncounters.sessionId, db.sessions.id),
      );

  $$SessionsTableProcessedTableManager? get sessionId {
    final $_column = $_itemColumn<int>('session_id');
    if ($_column == null) return null;
    final manager = $$SessionsTableTableManager(
      $_db,
      $_db.sessions,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_sessionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$TextEncountersTableFilterComposer
    extends Composer<_$SadhanaDatabase, $TextEncountersTable> {
  $$TextEncountersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get textId => $composableBuilder(
    column: $table.textId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get at => $composableBuilder(
    column: $table.at,
    builder: (column) => ColumnFilters(column),
  );

  $$SessionsTableFilterComposer get sessionId {
    final $$SessionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionId,
      referencedTable: $db.sessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SessionsTableFilterComposer(
            $db: $db,
            $table: $db.sessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TextEncountersTableOrderingComposer
    extends Composer<_$SadhanaDatabase, $TextEncountersTable> {
  $$TextEncountersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get textId => $composableBuilder(
    column: $table.textId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get at => $composableBuilder(
    column: $table.at,
    builder: (column) => ColumnOrderings(column),
  );

  $$SessionsTableOrderingComposer get sessionId {
    final $$SessionsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionId,
      referencedTable: $db.sessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SessionsTableOrderingComposer(
            $db: $db,
            $table: $db.sessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TextEncountersTableAnnotationComposer
    extends Composer<_$SadhanaDatabase, $TextEncountersTable> {
  $$TextEncountersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get textId =>
      $composableBuilder(column: $table.textId, builder: (column) => column);

  GeneratedColumn<DateTime> get at =>
      $composableBuilder(column: $table.at, builder: (column) => column);

  $$SessionsTableAnnotationComposer get sessionId {
    final $$SessionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionId,
      referencedTable: $db.sessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SessionsTableAnnotationComposer(
            $db: $db,
            $table: $db.sessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TextEncountersTableTableManager
    extends
        RootTableManager<
          _$SadhanaDatabase,
          $TextEncountersTable,
          TextEncounter,
          $$TextEncountersTableFilterComposer,
          $$TextEncountersTableOrderingComposer,
          $$TextEncountersTableAnnotationComposer,
          $$TextEncountersTableCreateCompanionBuilder,
          $$TextEncountersTableUpdateCompanionBuilder,
          (TextEncounter, $$TextEncountersTableReferences),
          TextEncounter,
          PrefetchHooks Function({bool sessionId})
        > {
  $$TextEncountersTableTableManager(
    _$SadhanaDatabase db,
    $TextEncountersTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TextEncountersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TextEncountersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TextEncountersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> textId = const Value.absent(),
                Value<int?> sessionId = const Value.absent(),
                Value<DateTime> at = const Value.absent(),
              }) => TextEncountersCompanion(
                id: id,
                textId: textId,
                sessionId: sessionId,
                at: at,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String textId,
                Value<int?> sessionId = const Value.absent(),
                required DateTime at,
              }) => TextEncountersCompanion.insert(
                id: id,
                textId: textId,
                sessionId: sessionId,
                at: at,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$TextEncountersTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({sessionId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (sessionId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.sessionId,
                                referencedTable: $$TextEncountersTableReferences
                                    ._sessionIdTable(db),
                                referencedColumn:
                                    $$TextEncountersTableReferences
                                        ._sessionIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$TextEncountersTableProcessedTableManager =
    ProcessedTableManager<
      _$SadhanaDatabase,
      $TextEncountersTable,
      TextEncounter,
      $$TextEncountersTableFilterComposer,
      $$TextEncountersTableOrderingComposer,
      $$TextEncountersTableAnnotationComposer,
      $$TextEncountersTableCreateCompanionBuilder,
      $$TextEncountersTableUpdateCompanionBuilder,
      (TextEncounter, $$TextEncountersTableReferences),
      TextEncounter,
      PrefetchHooks Function({bool sessionId})
    >;
typedef $$SequenceRowsTableCreateCompanionBuilder =
    SequenceRowsCompanion Function({
      Value<int> id,
      required String title,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<String?> derivedFrom,
    });
typedef $$SequenceRowsTableUpdateCompanionBuilder =
    SequenceRowsCompanion Function({
      Value<int> id,
      Value<String> title,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<String?> derivedFrom,
    });

class $$SequenceRowsTableFilterComposer
    extends Composer<_$SadhanaDatabase, $SequenceRowsTable> {
  $$SequenceRowsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get derivedFrom => $composableBuilder(
    column: $table.derivedFrom,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SequenceRowsTableOrderingComposer
    extends Composer<_$SadhanaDatabase, $SequenceRowsTable> {
  $$SequenceRowsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get derivedFrom => $composableBuilder(
    column: $table.derivedFrom,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SequenceRowsTableAnnotationComposer
    extends Composer<_$SadhanaDatabase, $SequenceRowsTable> {
  $$SequenceRowsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<String> get derivedFrom => $composableBuilder(
    column: $table.derivedFrom,
    builder: (column) => column,
  );
}

class $$SequenceRowsTableTableManager
    extends
        RootTableManager<
          _$SadhanaDatabase,
          $SequenceRowsTable,
          SequenceRow,
          $$SequenceRowsTableFilterComposer,
          $$SequenceRowsTableOrderingComposer,
          $$SequenceRowsTableAnnotationComposer,
          $$SequenceRowsTableCreateCompanionBuilder,
          $$SequenceRowsTableUpdateCompanionBuilder,
          (
            SequenceRow,
            BaseReferences<_$SadhanaDatabase, $SequenceRowsTable, SequenceRow>,
          ),
          SequenceRow,
          PrefetchHooks Function()
        > {
  $$SequenceRowsTableTableManager(
    _$SadhanaDatabase db,
    $SequenceRowsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SequenceRowsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SequenceRowsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SequenceRowsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<String?> derivedFrom = const Value.absent(),
              }) => SequenceRowsCompanion(
                id: id,
                title: title,
                createdAt: createdAt,
                updatedAt: updatedAt,
                derivedFrom: derivedFrom,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String title,
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<String?> derivedFrom = const Value.absent(),
              }) => SequenceRowsCompanion.insert(
                id: id,
                title: title,
                createdAt: createdAt,
                updatedAt: updatedAt,
                derivedFrom: derivedFrom,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SequenceRowsTableProcessedTableManager =
    ProcessedTableManager<
      _$SadhanaDatabase,
      $SequenceRowsTable,
      SequenceRow,
      $$SequenceRowsTableFilterComposer,
      $$SequenceRowsTableOrderingComposer,
      $$SequenceRowsTableAnnotationComposer,
      $$SequenceRowsTableCreateCompanionBuilder,
      $$SequenceRowsTableUpdateCompanionBuilder,
      (
        SequenceRow,
        BaseReferences<_$SadhanaDatabase, $SequenceRowsTable, SequenceRow>,
      ),
      SequenceRow,
      PrefetchHooks Function()
    >;
typedef $$StepRowsTableCreateCompanionBuilder =
    StepRowsCompanion Function({
      Value<int> id,
      required int sequenceId,
      required int position,
      required String kind,
      Value<int?> durationSeconds,
      Value<int?> breathIn,
      Value<int?> breathHoldIn,
      Value<int?> breathOut,
      Value<int?> breathHoldOut,
      Value<int?> cycles,
      Value<String?> asanaId,
      Value<String?> side,
      Value<String?> focusObject,
      Value<String?> textId,
    });
typedef $$StepRowsTableUpdateCompanionBuilder =
    StepRowsCompanion Function({
      Value<int> id,
      Value<int> sequenceId,
      Value<int> position,
      Value<String> kind,
      Value<int?> durationSeconds,
      Value<int?> breathIn,
      Value<int?> breathHoldIn,
      Value<int?> breathOut,
      Value<int?> breathHoldOut,
      Value<int?> cycles,
      Value<String?> asanaId,
      Value<String?> side,
      Value<String?> focusObject,
      Value<String?> textId,
    });

class $$StepRowsTableFilterComposer
    extends Composer<_$SadhanaDatabase, $StepRowsTable> {
  $$StepRowsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sequenceId => $composableBuilder(
    column: $table.sequenceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get durationSeconds => $composableBuilder(
    column: $table.durationSeconds,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get breathIn => $composableBuilder(
    column: $table.breathIn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get breathHoldIn => $composableBuilder(
    column: $table.breathHoldIn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get breathOut => $composableBuilder(
    column: $table.breathOut,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get breathHoldOut => $composableBuilder(
    column: $table.breathHoldOut,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get cycles => $composableBuilder(
    column: $table.cycles,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get asanaId => $composableBuilder(
    column: $table.asanaId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get side => $composableBuilder(
    column: $table.side,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get focusObject => $composableBuilder(
    column: $table.focusObject,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get textId => $composableBuilder(
    column: $table.textId,
    builder: (column) => ColumnFilters(column),
  );
}

class $$StepRowsTableOrderingComposer
    extends Composer<_$SadhanaDatabase, $StepRowsTable> {
  $$StepRowsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sequenceId => $composableBuilder(
    column: $table.sequenceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get durationSeconds => $composableBuilder(
    column: $table.durationSeconds,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get breathIn => $composableBuilder(
    column: $table.breathIn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get breathHoldIn => $composableBuilder(
    column: $table.breathHoldIn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get breathOut => $composableBuilder(
    column: $table.breathOut,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get breathHoldOut => $composableBuilder(
    column: $table.breathHoldOut,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get cycles => $composableBuilder(
    column: $table.cycles,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get asanaId => $composableBuilder(
    column: $table.asanaId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get side => $composableBuilder(
    column: $table.side,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get focusObject => $composableBuilder(
    column: $table.focusObject,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get textId => $composableBuilder(
    column: $table.textId,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$StepRowsTableAnnotationComposer
    extends Composer<_$SadhanaDatabase, $StepRowsTable> {
  $$StepRowsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get sequenceId => $composableBuilder(
    column: $table.sequenceId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get position =>
      $composableBuilder(column: $table.position, builder: (column) => column);

  GeneratedColumn<String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<int> get durationSeconds => $composableBuilder(
    column: $table.durationSeconds,
    builder: (column) => column,
  );

  GeneratedColumn<int> get breathIn =>
      $composableBuilder(column: $table.breathIn, builder: (column) => column);

  GeneratedColumn<int> get breathHoldIn => $composableBuilder(
    column: $table.breathHoldIn,
    builder: (column) => column,
  );

  GeneratedColumn<int> get breathOut =>
      $composableBuilder(column: $table.breathOut, builder: (column) => column);

  GeneratedColumn<int> get breathHoldOut => $composableBuilder(
    column: $table.breathHoldOut,
    builder: (column) => column,
  );

  GeneratedColumn<int> get cycles =>
      $composableBuilder(column: $table.cycles, builder: (column) => column);

  GeneratedColumn<String> get asanaId =>
      $composableBuilder(column: $table.asanaId, builder: (column) => column);

  GeneratedColumn<String> get side =>
      $composableBuilder(column: $table.side, builder: (column) => column);

  GeneratedColumn<String> get focusObject => $composableBuilder(
    column: $table.focusObject,
    builder: (column) => column,
  );

  GeneratedColumn<String> get textId =>
      $composableBuilder(column: $table.textId, builder: (column) => column);
}

class $$StepRowsTableTableManager
    extends
        RootTableManager<
          _$SadhanaDatabase,
          $StepRowsTable,
          StepRow,
          $$StepRowsTableFilterComposer,
          $$StepRowsTableOrderingComposer,
          $$StepRowsTableAnnotationComposer,
          $$StepRowsTableCreateCompanionBuilder,
          $$StepRowsTableUpdateCompanionBuilder,
          (StepRow, BaseReferences<_$SadhanaDatabase, $StepRowsTable, StepRow>),
          StepRow,
          PrefetchHooks Function()
        > {
  $$StepRowsTableTableManager(_$SadhanaDatabase db, $StepRowsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$StepRowsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$StepRowsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$StepRowsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> sequenceId = const Value.absent(),
                Value<int> position = const Value.absent(),
                Value<String> kind = const Value.absent(),
                Value<int?> durationSeconds = const Value.absent(),
                Value<int?> breathIn = const Value.absent(),
                Value<int?> breathHoldIn = const Value.absent(),
                Value<int?> breathOut = const Value.absent(),
                Value<int?> breathHoldOut = const Value.absent(),
                Value<int?> cycles = const Value.absent(),
                Value<String?> asanaId = const Value.absent(),
                Value<String?> side = const Value.absent(),
                Value<String?> focusObject = const Value.absent(),
                Value<String?> textId = const Value.absent(),
              }) => StepRowsCompanion(
                id: id,
                sequenceId: sequenceId,
                position: position,
                kind: kind,
                durationSeconds: durationSeconds,
                breathIn: breathIn,
                breathHoldIn: breathHoldIn,
                breathOut: breathOut,
                breathHoldOut: breathHoldOut,
                cycles: cycles,
                asanaId: asanaId,
                side: side,
                focusObject: focusObject,
                textId: textId,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int sequenceId,
                required int position,
                required String kind,
                Value<int?> durationSeconds = const Value.absent(),
                Value<int?> breathIn = const Value.absent(),
                Value<int?> breathHoldIn = const Value.absent(),
                Value<int?> breathOut = const Value.absent(),
                Value<int?> breathHoldOut = const Value.absent(),
                Value<int?> cycles = const Value.absent(),
                Value<String?> asanaId = const Value.absent(),
                Value<String?> side = const Value.absent(),
                Value<String?> focusObject = const Value.absent(),
                Value<String?> textId = const Value.absent(),
              }) => StepRowsCompanion.insert(
                id: id,
                sequenceId: sequenceId,
                position: position,
                kind: kind,
                durationSeconds: durationSeconds,
                breathIn: breathIn,
                breathHoldIn: breathHoldIn,
                breathOut: breathOut,
                breathHoldOut: breathHoldOut,
                cycles: cycles,
                asanaId: asanaId,
                side: side,
                focusObject: focusObject,
                textId: textId,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$StepRowsTableProcessedTableManager =
    ProcessedTableManager<
      _$SadhanaDatabase,
      $StepRowsTable,
      StepRow,
      $$StepRowsTableFilterComposer,
      $$StepRowsTableOrderingComposer,
      $$StepRowsTableAnnotationComposer,
      $$StepRowsTableCreateCompanionBuilder,
      $$StepRowsTableUpdateCompanionBuilder,
      (StepRow, BaseReferences<_$SadhanaDatabase, $StepRowsTable, StepRow>),
      StepRow,
      PrefetchHooks Function()
    >;

class $SadhanaDatabaseManager {
  final _$SadhanaDatabase _db;
  $SadhanaDatabaseManager(this._db);
  $$SessionsTableTableManager get sessions =>
      $$SessionsTableTableManager(_db, _db.sessions);
  $$JournalEntriesTableTableManager get journalEntries =>
      $$JournalEntriesTableTableManager(_db, _db.journalEntries);
  $$TextAnnotationsTableTableManager get textAnnotations =>
      $$TextAnnotationsTableTableManager(_db, _db.textAnnotations);
  $$TextEncountersTableTableManager get textEncounters =>
      $$TextEncountersTableTableManager(_db, _db.textEncounters);
  $$SequenceRowsTableTableManager get sequenceRows =>
      $$SequenceRowsTableTableManager(_db, _db.sequenceRows);
  $$StepRowsTableTableManager get stepRows =>
      $$StepRowsTableTableManager(_db, _db.stepRows);
}
