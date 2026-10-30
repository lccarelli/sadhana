import 'package:drift/drift.dart';

class Sessions extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get sequenceId => text()();
  DateTimeColumn get startedAt => dateTime()();
  DateTimeColumn get endedAt => dateTime().nullable()();

  IntColumn get plannedSeconds => integer()();
  IntColumn get practisedSeconds => integer().withDefault(const Constant(0))();
  BoolColumn get completed => boolean().withDefault(const Constant(false))();
}

class JournalEntries extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get sessionId => integer().nullable().references(Sessions, #id)();
  DateTimeColumn get createdAt => dateTime()();

  IntColumn get sthira => integer().nullable()();
  IntColumn get sukha => integer().nullable()();

  TextColumn get note => text().withDefault(const Constant(''))();

  TextColumn get angas => text().withDefault(const Constant(''))();
}

class TextAnnotations extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get textId => text()();
  TextColumn get note => text()();
  DateTimeColumn get createdAt => dateTime()();
}

class TextEncounters extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get textId => text()();
  IntColumn get sessionId => integer().nullable().references(Sessions, #id)();
  DateTimeColumn get at => dateTime()();
}

class SequenceRows extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  TextColumn get derivedFrom => text().nullable()();
}

class StepRows extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get sequenceId => integer()();
  IntColumn get position => integer()();
  TextColumn get kind => text()();

  IntColumn get durationSeconds => integer().nullable()();

  IntColumn get breathIn => integer().nullable()();
  IntColumn get breathHoldIn => integer().nullable()();
  IntColumn get breathOut => integer().nullable()();
  IntColumn get breathHoldOut => integer().nullable()();
  IntColumn get cycles => integer().nullable()();

  TextColumn get asanaId => text().nullable()();
  TextColumn get side => text().nullable()();

  TextColumn get focusObject => text().nullable()();
  TextColumn get textId => text().nullable()();
}
