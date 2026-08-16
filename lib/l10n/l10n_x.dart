import 'package:flutter/widgets.dart';

import '../core/domain/anga.dart';
import '../core/domain/asana.dart';
import '../core/domain/breath.dart';
import '../core/domain/practice_sequence.dart';
import '../core/domain/practice_step.dart';
import '../data/corpus/asana_catalogue.dart';
import 'generated/app_localizations.dart';

/// The edge where the domain meets a language.
///
/// The domain deliberately knows nothing about locales — it carries keys and
/// invariant Sanskrit. This is the single place those keys become words, so
/// there is exactly one file to look at when a string is wrong.
extension L10nX on L {
  String anga(Anga a) => switch (a) {
        Anga.yama => angaYama,
        Anga.niyama => angaNiyama,
        Anga.asana => angaAsana,
        Anga.pranayama => angaPranayama,
        Anga.pratyahara => angaPratyahara,
        Anga.dharana => angaDharana,
        Anga.dhyana => angaDhyana,
        Anga.samadhi => angaSamadhi,
      };

  String muscle(MuscleGroup m) => switch (m) {
        MuscleGroup.externalOblique => muscleExternalOblique,
        MuscleGroup.quadratusLumborum => muscleQuadratusLumborum,
        MuscleGroup.hamstrings => muscleHamstrings,
        MuscleGroup.quadriceps => muscleQuadriceps,
        MuscleGroup.glutes => muscleGlutes,
        MuscleGroup.psoas => musclePsoas,
        MuscleGroup.pectorals => musclePectorals,
        MuscleGroup.latissimus => muscleLatissimus,
        MuscleGroup.deltoids => muscleDeltoids,
        MuscleGroup.spinalErectors => muscleSpinalErectors,
        MuscleGroup.adductors => muscleAdductors,
        MuscleGroup.calves => muscleCalves,
        MuscleGroup.sacroiliacJoint => muscleSacroiliacJoint,
      };

  String muscleAction(MuscleAction a) => switch (a) {
        MuscleAction.stretches => bodyStretches,
        MuscleAction.engages => bodyEngages,
      };

  String breathPhase(BreathPhase p) => switch (p) {
        BreathPhase.inhale => breathInhale,
        BreathPhase.holdIn => breathHoldIn,
        BreathPhase.exhale => breathExhale,
        BreathPhase.holdOut => breathHoldOut,
      };

  /// A posture's everyday name in the reader's language. Falls back to the id
  /// so a practice composed against a posture we do not ship still shows
  /// something a person can read.
  String asanaName(String asanaId) =>
      AsanaCatalogue.translation(asanaId, localeName)?.name ??
      asanaId.split('.').last;

  String stepTitle(PracticeStep step) => switch (step) {
        BreathStep() => anga(Anga.pranayama),
        AsanaStep(asanaId: final id) => asanaName(id),
        FocusStep(object: final key) => _focus(key),
        SilenceStep() => runnerSilence,
        ReadingStep() => runnerReading,
      };

  String stepKind(PracticeStep step) => switch (step) {
        BreathStep() => breathInhale,
        AsanaStep() => runnerHold,
        FocusStep() => runnerFocus,
        SilenceStep() => runnerSilence,
        ReadingStep() => runnerReading,
      };

  /// The step's kind as the editor names it — "Breath", "Posture", "Silence".
  String stepKindLabel(PracticeStep step) => switch (step) {
        BreathStep() => stepBreath,
        AsanaStep() => stepAsana,
        FocusStep() => stepFocus,
        SilenceStep() => stepSilence,
        ReadingStep() => stepReading,
      };

  /// One line describing what the step actually does, for the editor list.
  String stepSummary(PracticeStep step) => switch (step) {
        BreathStep(:final pattern, :final cycles) =>
          '${pattern.label} · ${stepCyclesCount(cycles)}',
        AsanaStep(:final asanaId, :final hold, :final side) => [
            asanaName(asanaId),
            _clock(hold),
            if (side != null) this.side(side),
          ].join(' · '),
        FocusStep(:final object, :final duration) =>
          '${_focus(object)} · ${_clock(duration)}',
        SilenceStep(:final duration) => _clock(duration),
        ReadingStep(:final textId, :final duration) =>
          '$textId · ${_clock(duration)}',
      };

  /// Seeded titles are localization keys; the practitioner's own are literal.
  String sequenceTitle(PracticeSequence sequence) => sequence.authoredByUser
      ? (sequence.title.trim().isEmpty ? editorUntitled : sequence.title)
      : _seedTitle(sequence.title);

  String _seedTitle(String key) => switch (key) {
        'seqSlowMorning' => seqSlowMorning,
        'seqEveningUnwind' => seqEveningUnwind,
        _ => key,
      };

  String _clock(Duration d) => stepMinutesSeconds(
        d.inMinutes.toString(),
        d.inSeconds.remainder(60).toString().padLeft(2, '0'),
      );

  String side(BodySide s) =>
      s == BodySide.left ? runnerSideLeft : runnerSideRight;

  /// Seeded focus objects are keys; user-authored ones are literal text.
  String _focus(String key) => switch (key) {
        'focusBreathAtNostrils' => focusBreathAtNostrils,
        _ => key,
      };
}

extension LContext on BuildContext {
  L get l => L.of(this);
}
