import 'package:drift/drift.dart';

import '../../core/domain/breath.dart';
import '../../core/domain/practice_step.dart';
import 'database.dart';

enum StepKind { breath, asana, focus, silence, reading }

abstract final class StepCodec {
  static StepRowsCompanion encode(
    PracticeStep step, {
    required int sequenceId,
    required int position,
  }) {
    final base = StepRowsCompanion.insert(
      sequenceId: sequenceId,
      position: position,
      kind: '',
    );

    return switch (step) {
      BreathStep(:final pattern, :final cycles) => base.copyWith(
        kind: Value(StepKind.breath.name),
        breathIn: Value(pattern.inhale),
        breathHoldIn: Value(pattern.holdIn),
        breathOut: Value(pattern.exhale),
        breathHoldOut: Value(pattern.holdOut),
        cycles: Value(cycles),
      ),
      AsanaStep(:final asanaId, :final hold, :final side) => base.copyWith(
        kind: Value(StepKind.asana.name),
        asanaId: Value(asanaId),
        durationSeconds: Value(hold.inSeconds),
        side: Value(side?.name),
      ),
      FocusStep(:final object, :final duration) => base.copyWith(
        kind: Value(StepKind.focus.name),
        focusObject: Value(object),
        durationSeconds: Value(duration.inSeconds),
      ),
      SilenceStep(:final duration) => base.copyWith(
        kind: Value(StepKind.silence.name),
        durationSeconds: Value(duration.inSeconds),
      ),
      ReadingStep(:final textId, :final duration) => base.copyWith(
        kind: Value(StepKind.reading.name),
        textId: Value(textId),
        durationSeconds: Value(duration.inSeconds),
      ),
    };
  }

  static PracticeStep decode(StepRow row) {
    final kind = StepKind.values.byName(row.kind);

    return switch (kind) {
      StepKind.breath => BreathStep(
        pattern: BreathPattern(
          inhale: row.breathIn ?? 4,
          holdIn: row.breathHoldIn ?? 0,
          exhale: row.breathOut ?? 4,
          holdOut: row.breathHoldOut ?? 0,
        ),
        cycles: row.cycles ?? 1,
      ),
      StepKind.asana => AsanaStep(
        asanaId: row.asanaId ?? '',
        hold: Duration(seconds: row.durationSeconds ?? 30),
        side: switch (row.side) {
          'left' => BodySide.left,
          'right' => BodySide.right,
          _ => null,
        },
      ),
      StepKind.focus => FocusStep(
        object: row.focusObject ?? '',
        duration: Duration(seconds: row.durationSeconds ?? 60),
      ),
      StepKind.silence => SilenceStep(
        duration: Duration(seconds: row.durationSeconds ?? 60),
      ),
      StepKind.reading => ReadingStep(
        textId: row.textId ?? '',
        duration: Duration(seconds: row.durationSeconds ?? 120),
      ),
    };
  }

  static StepKind kindOf(PracticeStep step) => switch (step) {
    BreathStep() => StepKind.breath,
    AsanaStep() => StepKind.asana,
    FocusStep() => StepKind.focus,
    SilenceStep() => StepKind.silence,
    ReadingStep() => StepKind.reading,
  };

  static PracticeStep blank(StepKind kind) => switch (kind) {
    StepKind.breath => const BreathStep(
      pattern: BreathPattern.samaVritti,
      cycles: 8,
    ),
    StepKind.asana => const AsanaStep(
      asanaId: 'asana.trikonasana',
      hold: Duration(seconds: 45),
    ),
    StepKind.focus => const FocusStep(
      object: 'focusBreathAtNostrils',
      duration: Duration(minutes: 3),
    ),
    StepKind.silence => const SilenceStep(duration: Duration(minutes: 5)),
    StepKind.reading => const ReadingStep(
      textId: 'ys.1.2',
      duration: Duration(minutes: 2),
    ),
  };
}
