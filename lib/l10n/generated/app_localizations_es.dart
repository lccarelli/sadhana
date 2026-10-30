// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class LEs extends L {
  LEs([String locale = 'es']) : super(locale);

  @override
  String get appName => 'Samyama';

  @override
  String get appSignature => 'Laura de Trantor';

  @override
  String get navToday => 'Hoy';

  @override
  String get navStudy => 'Estudio';

  @override
  String get navJournal => 'Bitácora';

  @override
  String get navBody => 'Cuerpo';

  @override
  String get navPath => 'Camino';

  @override
  String get todayTitle => 'Tu sadhana de hoy';

  @override
  String get todaySavedSequence => 'Secuencia guardada';

  @override
  String get todayStart => 'Comenzar';

  @override
  String todayStepsAndTime(int steps, int minutes) {
    return '$steps pasos · $minutes min';
  }

  @override
  String todayContinuity(int days) {
    return 'Continuidad · $days días';
  }

  @override
  String get todayReading => 'Leyendo';

  @override
  String get todayReadingWork => 'Yoga Sutras — Pada I';

  @override
  String get seqSlowMorning => 'Mañana lenta';

  @override
  String get seqEveningUnwind => 'Noche que afloja';

  @override
  String get sequencesTitle => 'Prácticas';

  @override
  String get sequencesIncluded => 'Incluidas';

  @override
  String get sequencesYours => 'Tuyas';

  @override
  String get sequencesNew => 'Práctica nueva';

  @override
  String get sequencesEmpty => 'Todavía no armaste ninguna práctica';

  @override
  String get sequencesChoose => 'Elegir';

  @override
  String get sequencesEdit => 'Editar';

  @override
  String get sequencesDuplicate => 'Duplicar';

  @override
  String get sequencesDelete => 'Borrar';

  @override
  String sequencesDeleted(String title) {
    return 'Se borró $title';
  }

  @override
  String get sequencesUndo => 'Deshacer';

  @override
  String sequencesCopySuffix(String title) {
    return '$title (copia)';
  }

  @override
  String get sequencesSeededNotice =>
      'Las prácticas incluidas no se editan — esto abre tu propia copia.';

  @override
  String get editorTitleHint => 'Ponele un nombre';

  @override
  String get editorUntitled => 'Práctica sin nombre';

  @override
  String get editorSteps => 'Pasos';

  @override
  String get editorAddStep => 'Agregar paso';

  @override
  String get editorNoSteps => 'Una práctica necesita al menos un paso';

  @override
  String get editorSave => 'Guardar';

  @override
  String get editorDiscard => '¿Descartar los cambios?';

  @override
  String editorTotal(int steps, int minutes) {
    return '$steps pasos · $minutes min';
  }

  @override
  String get stepBreath => 'Respiración';

  @override
  String get stepAsana => 'Postura';

  @override
  String get stepFocus => 'Foco';

  @override
  String get stepSilence => 'Silencio';

  @override
  String get stepReading => 'Lectura';

  @override
  String get stepCycles => 'Ciclos';

  @override
  String get stepPattern => 'Patrón';

  @override
  String get stepDuration => 'Duración';

  @override
  String get stepSide => 'Lado';

  @override
  String get stepSideBoth => 'Sin especificar';

  @override
  String get stepPosture => 'Postura';

  @override
  String get stepFocusObject => 'Objeto de atención';

  @override
  String get stepText => 'Texto';

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
    return '$count ciclos';
  }

  @override
  String get breathInhale => 'Inhala';

  @override
  String get breathHoldIn => 'Sostén';

  @override
  String get breathExhale => 'Exhala';

  @override
  String get breathHoldOut => 'Vacío';

  @override
  String runnerCycle(int cycle, int total, String pattern) {
    return 'Ciclo $cycle de $total · $pattern';
  }

  @override
  String runnerNext(String step) {
    return 'Sigue · $step';
  }

  @override
  String get runnerLastStep => 'Último paso';

  @override
  String get runnerPaused => 'En pausa';

  @override
  String get runnerExit => 'Salir de la práctica';

  @override
  String get runnerComplete => 'Completa';

  @override
  String get runnerHold => 'Sostener';

  @override
  String get runnerSilence => 'Silencio';

  @override
  String get runnerFocus => 'Foco';

  @override
  String get runnerReading => 'Lectura';

  @override
  String get runnerSideLeft => 'Izquierda';

  @override
  String get runnerSideRight => 'Derecha';

  @override
  String get focusBreathAtNostrils => 'La respiración en las fosas nasales';

  @override
  String get journalTitle => '¿Cómo estuvo?';

  @override
  String journalJustFinished(int minutes) {
    return 'Recién terminada · $minutes min';
  }

  @override
  String get journalSthira => 'Firmeza — sthira';

  @override
  String get journalSukha => 'Comodidad — sukha';

  @override
  String get journalNote => 'Nota';

  @override
  String get journalNoteHint => 'Lo que pasó. Nadie más va a leer esto.';

  @override
  String get journalSavedWith => 'Se guarda con';

  @override
  String get journalPrivacy =>
      'Solo en este dispositivo. Nada de esto sale del teléfono.';

  @override
  String get journalSave => 'Guardar';

  @override
  String get journalSaved => 'Guardado';

  @override
  String get journalSkip => 'Ahora no';

  @override
  String get journalEmpty => 'Todavía no hay nada registrado';

  @override
  String get journalEmptyDetail =>
      'Las prácticas aparecen acá apenas terminás una — o abandonás una. Las dos cuentan.';

  @override
  String get journalNoNote => 'Sin nota';

  @override
  String journalPartial(int percent) {
    return '$percent% de la práctica';
  }

  @override
  String get journalHistory => 'Prácticas';

  @override
  String journalMinutes(int minutes) {
    return '$minutes min';
  }

  @override
  String journalTotalPractices(int count, String hours) {
    return '$count prácticas · ${hours}h en total';
  }

  @override
  String get settingsTitle => 'Ajustes';

  @override
  String get settingsTheme => 'Tema';

  @override
  String get settingsThemeAuto => 'Automático';

  @override
  String settingsThemeAutoDetail(int lightHour, int darkHour) {
    return 'Claro desde las $lightHour:00, oscuro desde las $darkHour:00';
  }

  @override
  String get settingsThemeLight => 'Claro';

  @override
  String get settingsThemeDark => 'Oscuro';

  @override
  String get settingsLanguage => 'Idioma';

  @override
  String get settingsAbout => 'Acerca de';

  @override
  String get angaYama => 'Cómo te relacionás con el mundo';

  @override
  String get angaNiyama => 'Cómo te relacionás con vos';

  @override
  String get angaAsana => 'Postura firme y cómoda';

  @override
  String get angaPranayama => 'La extensión del aliento';

  @override
  String get angaPratyahara => 'Los sentidos hacia adentro';

  @override
  String get angaDharana => 'Fijar la atención';

  @override
  String get angaDhyana => 'Que la atención fluya sola';

  @override
  String get angaSamadhi => 'Que se disuelva quien atiende';

  @override
  String get limbOuter => 'Angas externos';

  @override
  String get limbInner => 'Angas internos';

  @override
  String limbNumber(int n) {
    return 'Anga $n';
  }

  @override
  String studySource(String translator, String license) {
    return 'Trad. $translator · $license';
  }

  @override
  String get studyPublicDomain => 'dominio público';

  @override
  String get studyAnnotated => 'Anotado';

  @override
  String studyPracticed(int count) {
    return 'Practicado ×$count';
  }

  @override
  String get bodyStretches => 'Estira';

  @override
  String get bodyEngages => 'Activa';

  @override
  String get bodyCareful => 'Cuidar';

  @override
  String get bodySubtle => 'capa sutil · orientativo';

  @override
  String get bodyPostures => 'Posturas';

  @override
  String get bodyTapMuscle => 'Tocá un músculo para ubicarlo en la postura';

  @override
  String get bodyDisclaimer =>
      'Orientación para la práctica, no consejo médico. El dolor es información — pará y preguntale a quien te enseña.';

  @override
  String get bodyPrimary => 'Principal';

  @override
  String get muscleExternalOblique => 'Oblicuo externo';

  @override
  String get muscleQuadratusLumborum => 'Cuadrado lumbar';

  @override
  String get muscleHamstrings => 'Isquiotibiales';

  @override
  String get muscleQuadriceps => 'Cuádriceps';

  @override
  String get muscleGlutes => 'Glúteos';

  @override
  String get musclePsoas => 'Psoas';

  @override
  String get musclePectorals => 'Pectorales';

  @override
  String get muscleLatissimus => 'Dorsal ancho';

  @override
  String get muscleDeltoids => 'Deltoides';

  @override
  String get muscleSpinalErectors => 'Erectores espinales';

  @override
  String get muscleAdductors => 'Aductores';

  @override
  String get muscleCalves => 'Gemelos';

  @override
  String get muscleSacroiliacJoint => 'Articulación sacroilíaca';
}
