// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class LEn extends L {
  LEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Samyama';

  @override
  String get appSignature => 'Laura de Trantor';

  @override
  String get navToday => 'Today';

  @override
  String get navStudy => 'Study';

  @override
  String get navJournal => 'Journal';

  @override
  String get navBody => 'Body';

  @override
  String get navPath => 'Path';

  @override
  String get todayTitle => 'Your sadhana today';

  @override
  String get todaySavedSequence => 'Saved sequence';

  @override
  String get todayStart => 'Start';

  @override
  String todayStepsAndTime(int steps, int minutes) {
    return '$steps steps · $minutes min';
  }

  @override
  String todayContinuity(int days) {
    return 'Continuity · $days days';
  }

  @override
  String get todayReading => 'Reading';

  @override
  String get todayReadingWork => 'Yoga Sutras — Pada I';

  @override
  String get seqSlowMorning => 'Slow morning';

  @override
  String get seqEveningUnwind => 'Evening unwind';

  @override
  String get sequencesTitle => 'Practices';

  @override
  String get sequencesIncluded => 'Included';

  @override
  String get sequencesYours => 'Yours';

  @override
  String get sequencesNew => 'New practice';

  @override
  String get sequencesEmpty => 'You haven\'t composed a practice yet';

  @override
  String get sequencesChoose => 'Choose';

  @override
  String get sequencesEdit => 'Edit';

  @override
  String get sequencesDuplicate => 'Duplicate';

  @override
  String get sequencesDelete => 'Delete';

  @override
  String sequencesDeleted(String title) {
    return '$title deleted';
  }

  @override
  String get sequencesUndo => 'Undo';

  @override
  String sequencesCopySuffix(String title) {
    return '$title (copy)';
  }

  @override
  String get sequencesSeededNotice =>
      'Included practices can\'t be edited — this opens your own copy.';

  @override
  String get editorTitleHint => 'Name this practice';

  @override
  String get editorUntitled => 'Untitled practice';

  @override
  String get editorSteps => 'Steps';

  @override
  String get editorAddStep => 'Add step';

  @override
  String get editorNoSteps => 'A practice needs at least one step';

  @override
  String get editorSave => 'Save';

  @override
  String get editorDiscard => 'Discard changes?';

  @override
  String editorTotal(int steps, int minutes) {
    return '$steps steps · $minutes min';
  }

  @override
  String get stepBreath => 'Breath';

  @override
  String get stepAsana => 'Posture';

  @override
  String get stepFocus => 'Focus';

  @override
  String get stepSilence => 'Silence';

  @override
  String get stepReading => 'Reading';

  @override
  String get stepCycles => 'Cycles';

  @override
  String get stepPattern => 'Pattern';

  @override
  String get stepDuration => 'Duration';

  @override
  String get stepSide => 'Side';

  @override
  String get stepSideBoth => 'Not specified';

  @override
  String get stepPosture => 'Posture';

  @override
  String get stepFocusObject => 'Object of attention';

  @override
  String get stepText => 'Text';

  @override
  String stepSeconds(int count) {
    return '$count s';
  }

  @override
  String stepMinutesSeconds(String minutes, String seconds) {
    return '$minutes:$seconds';
  }

  @override
  String stepCyclesCount(int count) {
    return '$count cycles';
  }

  @override
  String get breathInhale => 'Inhale';

  @override
  String get breathHoldIn => 'Hold';

  @override
  String get breathExhale => 'Exhale';

  @override
  String get breathHoldOut => 'Empty';

  @override
  String runnerCycle(int cycle, int total, String pattern) {
    return 'Cycle $cycle of $total · $pattern';
  }

  @override
  String runnerNext(String step) {
    return 'Next · $step';
  }

  @override
  String get runnerLastStep => 'Last step';

  @override
  String get runnerPaused => 'Paused';

  @override
  String get runnerExit => 'Leave practice';

  @override
  String get runnerComplete => 'Complete';

  @override
  String get runnerHold => 'Hold';

  @override
  String get runnerSilence => 'Silence';

  @override
  String get runnerFocus => 'Focus';

  @override
  String get runnerReading => 'Reading';

  @override
  String get runnerSideLeft => 'Left';

  @override
  String get runnerSideRight => 'Right';

  @override
  String get focusBreathAtNostrils => 'The breath at the nostrils';

  @override
  String get journalTitle => 'How was it?';

  @override
  String journalJustFinished(int minutes) {
    return 'Just finished · $minutes min';
  }

  @override
  String get journalSthira => 'Steadiness — sthira';

  @override
  String get journalSukha => 'Ease — sukha';

  @override
  String get journalNote => 'Note';

  @override
  String get journalNoteHint => 'What happened. Nobody else will read this.';

  @override
  String get journalSavedWith => 'Saved with';

  @override
  String get journalPrivacy =>
      'On this device only. None of this leaves your phone.';

  @override
  String get journalSave => 'Save';

  @override
  String get journalSaved => 'Saved';

  @override
  String get journalSkip => 'Skip';

  @override
  String get journalEmpty => 'Nothing recorded yet';

  @override
  String get journalEmptyDetail =>
      'Practices appear here as soon as you finish one — or abandon one. Both count.';

  @override
  String get journalNoNote => 'No note';

  @override
  String journalPartial(int percent) {
    return '$percent% of the practice';
  }

  @override
  String get journalHistory => 'Practices';

  @override
  String journalMinutes(int minutes) {
    return '$minutes min';
  }

  @override
  String journalTotalPractices(int count, String hours) {
    return '$count practices · ${hours}h total';
  }

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsTheme => 'Theme';

  @override
  String get settingsThemeAuto => 'Automatic';

  @override
  String settingsThemeAutoDetail(int lightHour, int darkHour) {
    return 'Light from $lightHour:00, dark from $darkHour:00';
  }

  @override
  String get settingsThemeLight => 'Light';

  @override
  String get settingsThemeDark => 'Dark';

  @override
  String get settingsLanguage => 'Language';

  @override
  String get settingsAbout => 'About';

  @override
  String get angaYama => 'How you meet the world';

  @override
  String get angaNiyama => 'How you meet yourself';

  @override
  String get angaAsana => 'Posture, steady and at ease';

  @override
  String get angaPranayama => 'The extension of the breath';

  @override
  String get angaPratyahara => 'The senses turned inward';

  @override
  String get angaDharana => 'Fixing the attention';

  @override
  String get angaDhyana => 'Attention flowing by itself';

  @override
  String get angaSamadhi => 'The one attending dissolves';

  @override
  String get limbOuter => 'Outer limbs';

  @override
  String get limbInner => 'Inner limbs';

  @override
  String limbNumber(int n) {
    return 'Limb $n';
  }

  @override
  String studySource(String translator, String license) {
    return 'Trans. $translator · $license';
  }

  @override
  String get studyPublicDomain => 'public domain';

  @override
  String get studyAnnotated => 'Annotated';

  @override
  String studyPracticed(int count) {
    return 'Practiced ×$count';
  }

  @override
  String get bodyStretches => 'Stretches';

  @override
  String get bodyEngages => 'Engages';

  @override
  String get bodyCareful => 'Take care';

  @override
  String get bodySubtle => 'subtle layer · orientation only';

  @override
  String get bodyPostures => 'Postures';

  @override
  String get bodyTapMuscle => 'Tap a muscle to find it in the posture';

  @override
  String get bodyDisclaimer =>
      'Guidance for practice, not medical advice. Pain is information — stop and ask a teacher.';

  @override
  String get bodyPrimary => 'Primary';

  @override
  String get muscleExternalOblique => 'External oblique';

  @override
  String get muscleQuadratusLumborum => 'Quadratus lumborum';

  @override
  String get muscleHamstrings => 'Hamstrings';

  @override
  String get muscleQuadriceps => 'Quadriceps';

  @override
  String get muscleGlutes => 'Glutes';

  @override
  String get musclePsoas => 'Psoas';

  @override
  String get musclePectorals => 'Pectorals';

  @override
  String get muscleLatissimus => 'Latissimus dorsi';

  @override
  String get muscleDeltoids => 'Deltoids';

  @override
  String get muscleSpinalErectors => 'Spinal erectors';

  @override
  String get muscleAdductors => 'Adductors';

  @override
  String get muscleCalves => 'Calves';

  @override
  String get muscleSacroiliacJoint => 'Sacroiliac joint';
}
