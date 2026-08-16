import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of L
/// returned by `L.of(context)`.
///
/// Applications need to include `L.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: L.localizationsDelegates,
///   supportedLocales: L.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the L.supportedLocales
/// property.
abstract class L {
  L(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static L of(BuildContext context) {
    return Localizations.of<L>(context, L)!;
  }

  static const LocalizationsDelegate<L> delegate = _LDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
  ];

  /// In-app product name. The launcher name lives in ios/Runner/Info.plist and android/app/src/main/AndroidManifest.xml and must be changed there too.
  ///
  /// In en, this message translates to:
  /// **'Samyama'**
  String get appName;

  /// No description provided for @appSignature.
  ///
  /// In en, this message translates to:
  /// **'Laura de Trantor'**
  String get appSignature;

  /// No description provided for @navToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get navToday;

  /// No description provided for @navStudy.
  ///
  /// In en, this message translates to:
  /// **'Study'**
  String get navStudy;

  /// No description provided for @navJournal.
  ///
  /// In en, this message translates to:
  /// **'Journal'**
  String get navJournal;

  /// No description provided for @navBody.
  ///
  /// In en, this message translates to:
  /// **'Body'**
  String get navBody;

  /// No description provided for @navPath.
  ///
  /// In en, this message translates to:
  /// **'Path'**
  String get navPath;

  /// No description provided for @todayTitle.
  ///
  /// In en, this message translates to:
  /// **'Your sadhana today'**
  String get todayTitle;

  /// No description provided for @todaySavedSequence.
  ///
  /// In en, this message translates to:
  /// **'Saved sequence'**
  String get todaySavedSequence;

  /// No description provided for @todayStart.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get todayStart;

  /// No description provided for @todayStepsAndTime.
  ///
  /// In en, this message translates to:
  /// **'{steps} steps · {minutes} min'**
  String todayStepsAndTime(int steps, int minutes);

  /// No description provided for @todayContinuity.
  ///
  /// In en, this message translates to:
  /// **'Continuity · {days} days'**
  String todayContinuity(int days);

  /// No description provided for @todayReading.
  ///
  /// In en, this message translates to:
  /// **'Reading'**
  String get todayReading;

  /// No description provided for @seqSlowMorning.
  ///
  /// In en, this message translates to:
  /// **'Slow morning'**
  String get seqSlowMorning;

  /// No description provided for @seqEveningUnwind.
  ///
  /// In en, this message translates to:
  /// **'Evening unwind'**
  String get seqEveningUnwind;

  /// No description provided for @sequencesTitle.
  ///
  /// In en, this message translates to:
  /// **'Practices'**
  String get sequencesTitle;

  /// No description provided for @sequencesIncluded.
  ///
  /// In en, this message translates to:
  /// **'Included'**
  String get sequencesIncluded;

  /// No description provided for @sequencesYours.
  ///
  /// In en, this message translates to:
  /// **'Yours'**
  String get sequencesYours;

  /// No description provided for @sequencesNew.
  ///
  /// In en, this message translates to:
  /// **'New practice'**
  String get sequencesNew;

  /// No description provided for @sequencesEmpty.
  ///
  /// In en, this message translates to:
  /// **'You haven\'t composed a practice yet'**
  String get sequencesEmpty;

  /// No description provided for @sequencesChoose.
  ///
  /// In en, this message translates to:
  /// **'Choose'**
  String get sequencesChoose;

  /// No description provided for @sequencesEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get sequencesEdit;

  /// No description provided for @sequencesDuplicate.
  ///
  /// In en, this message translates to:
  /// **'Duplicate'**
  String get sequencesDuplicate;

  /// No description provided for @sequencesDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get sequencesDelete;

  /// No description provided for @sequencesDeleted.
  ///
  /// In en, this message translates to:
  /// **'{title} deleted'**
  String sequencesDeleted(String title);

  /// No description provided for @sequencesUndo.
  ///
  /// In en, this message translates to:
  /// **'Undo'**
  String get sequencesUndo;

  /// No description provided for @sequencesCopySuffix.
  ///
  /// In en, this message translates to:
  /// **'{title} (copy)'**
  String sequencesCopySuffix(String title);

  /// No description provided for @sequencesSeededNotice.
  ///
  /// In en, this message translates to:
  /// **'Included practices can\'t be edited — this opens your own copy.'**
  String get sequencesSeededNotice;

  /// No description provided for @editorTitleHint.
  ///
  /// In en, this message translates to:
  /// **'Name this practice'**
  String get editorTitleHint;

  /// No description provided for @editorUntitled.
  ///
  /// In en, this message translates to:
  /// **'Untitled practice'**
  String get editorUntitled;

  /// No description provided for @editorSteps.
  ///
  /// In en, this message translates to:
  /// **'Steps'**
  String get editorSteps;

  /// No description provided for @editorAddStep.
  ///
  /// In en, this message translates to:
  /// **'Add step'**
  String get editorAddStep;

  /// No description provided for @editorNoSteps.
  ///
  /// In en, this message translates to:
  /// **'A practice needs at least one step'**
  String get editorNoSteps;

  /// No description provided for @editorSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get editorSave;

  /// No description provided for @editorDiscard.
  ///
  /// In en, this message translates to:
  /// **'Discard changes?'**
  String get editorDiscard;

  /// No description provided for @editorTotal.
  ///
  /// In en, this message translates to:
  /// **'{steps} steps · {minutes} min'**
  String editorTotal(int steps, int minutes);

  /// No description provided for @stepBreath.
  ///
  /// In en, this message translates to:
  /// **'Breath'**
  String get stepBreath;

  /// No description provided for @stepAsana.
  ///
  /// In en, this message translates to:
  /// **'Posture'**
  String get stepAsana;

  /// No description provided for @stepFocus.
  ///
  /// In en, this message translates to:
  /// **'Focus'**
  String get stepFocus;

  /// No description provided for @stepSilence.
  ///
  /// In en, this message translates to:
  /// **'Silence'**
  String get stepSilence;

  /// No description provided for @stepReading.
  ///
  /// In en, this message translates to:
  /// **'Reading'**
  String get stepReading;

  /// No description provided for @stepCycles.
  ///
  /// In en, this message translates to:
  /// **'Cycles'**
  String get stepCycles;

  /// No description provided for @stepPattern.
  ///
  /// In en, this message translates to:
  /// **'Pattern'**
  String get stepPattern;

  /// No description provided for @stepDuration.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get stepDuration;

  /// No description provided for @stepSide.
  ///
  /// In en, this message translates to:
  /// **'Side'**
  String get stepSide;

  /// No description provided for @stepSideBoth.
  ///
  /// In en, this message translates to:
  /// **'Not specified'**
  String get stepSideBoth;

  /// No description provided for @stepPosture.
  ///
  /// In en, this message translates to:
  /// **'Posture'**
  String get stepPosture;

  /// No description provided for @stepFocusObject.
  ///
  /// In en, this message translates to:
  /// **'Object of attention'**
  String get stepFocusObject;

  /// No description provided for @stepText.
  ///
  /// In en, this message translates to:
  /// **'Text'**
  String get stepText;

  /// No description provided for @stepSeconds.
  ///
  /// In en, this message translates to:
  /// **'{count} s'**
  String stepSeconds(int count);

  /// No description provided for @stepMinutesSeconds.
  ///
  /// In en, this message translates to:
  /// **'{minutes}:{seconds}'**
  String stepMinutesSeconds(String minutes, String seconds);

  /// No description provided for @stepCyclesCount.
  ///
  /// In en, this message translates to:
  /// **'{count} cycles'**
  String stepCyclesCount(int count);

  /// No description provided for @breathInhale.
  ///
  /// In en, this message translates to:
  /// **'Inhale'**
  String get breathInhale;

  /// No description provided for @breathHoldIn.
  ///
  /// In en, this message translates to:
  /// **'Hold'**
  String get breathHoldIn;

  /// No description provided for @breathExhale.
  ///
  /// In en, this message translates to:
  /// **'Exhale'**
  String get breathExhale;

  /// No description provided for @breathHoldOut.
  ///
  /// In en, this message translates to:
  /// **'Empty'**
  String get breathHoldOut;

  /// No description provided for @runnerCycle.
  ///
  /// In en, this message translates to:
  /// **'Cycle {cycle} of {total} · {pattern}'**
  String runnerCycle(int cycle, int total, String pattern);

  /// No description provided for @runnerNext.
  ///
  /// In en, this message translates to:
  /// **'Next · {step}'**
  String runnerNext(String step);

  /// No description provided for @runnerLastStep.
  ///
  /// In en, this message translates to:
  /// **'Last step'**
  String get runnerLastStep;

  /// No description provided for @runnerPaused.
  ///
  /// In en, this message translates to:
  /// **'Paused'**
  String get runnerPaused;

  /// No description provided for @runnerExit.
  ///
  /// In en, this message translates to:
  /// **'Leave practice'**
  String get runnerExit;

  /// No description provided for @runnerComplete.
  ///
  /// In en, this message translates to:
  /// **'Complete'**
  String get runnerComplete;

  /// No description provided for @runnerHold.
  ///
  /// In en, this message translates to:
  /// **'Hold'**
  String get runnerHold;

  /// No description provided for @runnerSilence.
  ///
  /// In en, this message translates to:
  /// **'Silence'**
  String get runnerSilence;

  /// No description provided for @runnerFocus.
  ///
  /// In en, this message translates to:
  /// **'Focus'**
  String get runnerFocus;

  /// No description provided for @runnerReading.
  ///
  /// In en, this message translates to:
  /// **'Reading'**
  String get runnerReading;

  /// No description provided for @runnerSideLeft.
  ///
  /// In en, this message translates to:
  /// **'Left'**
  String get runnerSideLeft;

  /// No description provided for @runnerSideRight.
  ///
  /// In en, this message translates to:
  /// **'Right'**
  String get runnerSideRight;

  /// No description provided for @focusBreathAtNostrils.
  ///
  /// In en, this message translates to:
  /// **'The breath at the nostrils'**
  String get focusBreathAtNostrils;

  /// No description provided for @journalTitle.
  ///
  /// In en, this message translates to:
  /// **'How was it?'**
  String get journalTitle;

  /// No description provided for @journalJustFinished.
  ///
  /// In en, this message translates to:
  /// **'Just finished · {minutes} min'**
  String journalJustFinished(int minutes);

  /// No description provided for @journalSthira.
  ///
  /// In en, this message translates to:
  /// **'Steadiness — sthira'**
  String get journalSthira;

  /// No description provided for @journalSukha.
  ///
  /// In en, this message translates to:
  /// **'Ease — sukha'**
  String get journalSukha;

  /// No description provided for @journalNote.
  ///
  /// In en, this message translates to:
  /// **'Note'**
  String get journalNote;

  /// No description provided for @journalNoteHint.
  ///
  /// In en, this message translates to:
  /// **'What happened. Nobody else will read this.'**
  String get journalNoteHint;

  /// No description provided for @journalSavedWith.
  ///
  /// In en, this message translates to:
  /// **'Saved with'**
  String get journalSavedWith;

  /// No description provided for @journalPrivacy.
  ///
  /// In en, this message translates to:
  /// **'On this device only. None of this leaves your phone.'**
  String get journalPrivacy;

  /// No description provided for @journalSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get journalSave;

  /// No description provided for @journalSaved.
  ///
  /// In en, this message translates to:
  /// **'Saved'**
  String get journalSaved;

  /// No description provided for @journalSkip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get journalSkip;

  /// No description provided for @journalEmpty.
  ///
  /// In en, this message translates to:
  /// **'Nothing recorded yet'**
  String get journalEmpty;

  /// No description provided for @journalEmptyDetail.
  ///
  /// In en, this message translates to:
  /// **'Practices appear here as soon as you finish one — or abandon one. Both count.'**
  String get journalEmptyDetail;

  /// No description provided for @journalNoNote.
  ///
  /// In en, this message translates to:
  /// **'No note'**
  String get journalNoNote;

  /// No description provided for @journalPartial.
  ///
  /// In en, this message translates to:
  /// **'{percent}% of the practice'**
  String journalPartial(int percent);

  /// No description provided for @journalHistory.
  ///
  /// In en, this message translates to:
  /// **'Practices'**
  String get journalHistory;

  /// No description provided for @journalMinutes.
  ///
  /// In en, this message translates to:
  /// **'{minutes} min'**
  String journalMinutes(int minutes);

  /// No description provided for @journalTotalPractices.
  ///
  /// In en, this message translates to:
  /// **'{count} practices · {hours}h total'**
  String journalTotalPractices(int count, String hours);

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @settingsTheme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get settingsTheme;

  /// No description provided for @settingsThemeAuto.
  ///
  /// In en, this message translates to:
  /// **'Automatic'**
  String get settingsThemeAuto;

  /// No description provided for @settingsThemeAutoDetail.
  ///
  /// In en, this message translates to:
  /// **'Light from {lightHour}:00, dark from {darkHour}:00'**
  String settingsThemeAutoDetail(int lightHour, int darkHour);

  /// No description provided for @settingsThemeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get settingsThemeLight;

  /// No description provided for @settingsThemeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get settingsThemeDark;

  /// No description provided for @settingsLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingsLanguage;

  /// No description provided for @settingsAbout.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get settingsAbout;

  /// No description provided for @angaYama.
  ///
  /// In en, this message translates to:
  /// **'How you meet the world'**
  String get angaYama;

  /// No description provided for @angaNiyama.
  ///
  /// In en, this message translates to:
  /// **'How you meet yourself'**
  String get angaNiyama;

  /// No description provided for @angaAsana.
  ///
  /// In en, this message translates to:
  /// **'Posture, steady and at ease'**
  String get angaAsana;

  /// No description provided for @angaPranayama.
  ///
  /// In en, this message translates to:
  /// **'The extension of the breath'**
  String get angaPranayama;

  /// No description provided for @angaPratyahara.
  ///
  /// In en, this message translates to:
  /// **'The senses turned inward'**
  String get angaPratyahara;

  /// No description provided for @angaDharana.
  ///
  /// In en, this message translates to:
  /// **'Fixing the attention'**
  String get angaDharana;

  /// No description provided for @angaDhyana.
  ///
  /// In en, this message translates to:
  /// **'Attention flowing by itself'**
  String get angaDhyana;

  /// No description provided for @angaSamadhi.
  ///
  /// In en, this message translates to:
  /// **'The one attending dissolves'**
  String get angaSamadhi;

  /// No description provided for @limbOuter.
  ///
  /// In en, this message translates to:
  /// **'Outer limbs'**
  String get limbOuter;

  /// No description provided for @limbInner.
  ///
  /// In en, this message translates to:
  /// **'Inner limbs'**
  String get limbInner;

  /// No description provided for @limbNumber.
  ///
  /// In en, this message translates to:
  /// **'Limb {n}'**
  String limbNumber(int n);

  /// No description provided for @studySource.
  ///
  /// In en, this message translates to:
  /// **'Trans. {translator} · {license}'**
  String studySource(String translator, String license);

  /// No description provided for @studyPublicDomain.
  ///
  /// In en, this message translates to:
  /// **'public domain'**
  String get studyPublicDomain;

  /// No description provided for @studyAnnotated.
  ///
  /// In en, this message translates to:
  /// **'Annotated'**
  String get studyAnnotated;

  /// No description provided for @studyPracticed.
  ///
  /// In en, this message translates to:
  /// **'Practiced ×{count}'**
  String studyPracticed(int count);

  /// No description provided for @bodyStretches.
  ///
  /// In en, this message translates to:
  /// **'Stretches'**
  String get bodyStretches;

  /// No description provided for @bodyEngages.
  ///
  /// In en, this message translates to:
  /// **'Engages'**
  String get bodyEngages;

  /// No description provided for @bodyCareful.
  ///
  /// In en, this message translates to:
  /// **'Take care'**
  String get bodyCareful;

  /// No description provided for @bodySubtle.
  ///
  /// In en, this message translates to:
  /// **'subtle layer · orientation only'**
  String get bodySubtle;

  /// No description provided for @bodyPostures.
  ///
  /// In en, this message translates to:
  /// **'Postures'**
  String get bodyPostures;

  /// No description provided for @bodyTapMuscle.
  ///
  /// In en, this message translates to:
  /// **'Tap a muscle to find it in the posture'**
  String get bodyTapMuscle;

  /// No description provided for @bodyDisclaimer.
  ///
  /// In en, this message translates to:
  /// **'Guidance for practice, not medical advice. Pain is information — stop and ask a teacher.'**
  String get bodyDisclaimer;

  /// No description provided for @bodyPrimary.
  ///
  /// In en, this message translates to:
  /// **'Primary'**
  String get bodyPrimary;

  /// No description provided for @muscleExternalOblique.
  ///
  /// In en, this message translates to:
  /// **'External oblique'**
  String get muscleExternalOblique;

  /// No description provided for @muscleQuadratusLumborum.
  ///
  /// In en, this message translates to:
  /// **'Quadratus lumborum'**
  String get muscleQuadratusLumborum;

  /// No description provided for @muscleHamstrings.
  ///
  /// In en, this message translates to:
  /// **'Hamstrings'**
  String get muscleHamstrings;

  /// No description provided for @muscleQuadriceps.
  ///
  /// In en, this message translates to:
  /// **'Quadriceps'**
  String get muscleQuadriceps;

  /// No description provided for @muscleGlutes.
  ///
  /// In en, this message translates to:
  /// **'Glutes'**
  String get muscleGlutes;

  /// No description provided for @musclePsoas.
  ///
  /// In en, this message translates to:
  /// **'Psoas'**
  String get musclePsoas;

  /// No description provided for @musclePectorals.
  ///
  /// In en, this message translates to:
  /// **'Pectorals'**
  String get musclePectorals;

  /// No description provided for @muscleLatissimus.
  ///
  /// In en, this message translates to:
  /// **'Latissimus dorsi'**
  String get muscleLatissimus;

  /// No description provided for @muscleDeltoids.
  ///
  /// In en, this message translates to:
  /// **'Deltoids'**
  String get muscleDeltoids;

  /// No description provided for @muscleSpinalErectors.
  ///
  /// In en, this message translates to:
  /// **'Spinal erectors'**
  String get muscleSpinalErectors;

  /// No description provided for @muscleAdductors.
  ///
  /// In en, this message translates to:
  /// **'Adductors'**
  String get muscleAdductors;

  /// No description provided for @muscleCalves.
  ///
  /// In en, this message translates to:
  /// **'Calves'**
  String get muscleCalves;

  /// No description provided for @muscleSacroiliacJoint.
  ///
  /// In en, this message translates to:
  /// **'Sacroiliac joint'**
  String get muscleSacroiliacJoint;
}

class _LDelegate extends LocalizationsDelegate<L> {
  const _LDelegate();

  @override
  Future<L> load(Locale locale) {
    return SynchronousFuture<L>(lookupL(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es'].contains(locale.languageCode);

  @override
  bool shouldReload(_LDelegate old) => false;
}

L lookupL(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return LEn();
    case 'es':
      return LEs();
  }

  throw FlutterError(
    'L.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
