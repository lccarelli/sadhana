import '../../core/domain/asana.dart';

/// The postures we ship, with their figures.
///
/// Corpus, not sadhana: read-mostly, curated by us, shippable. Same rules as
/// the texts — devanagari and IAST are invariant, only the vernacular name and
/// the guidance are translated.
///
/// The geometry is ours. Anatomical atlases are the single most expensive
/// thing to license in an app like this, and the reason most of them ship no
/// anatomy at all. Schematic silhouettes are also the honest register for a
/// study aid: precise enough to locate a muscle, never pretending to be a
/// medical illustration.
abstract final class AsanaCatalogue {
  static const asanas = <Asana>[
    _tadasana,
    _trikonasana,
    _virabhadrasanaII,
    _adhoMukhaSvanasana,
    _balasana,
  ];

  static Asana? byId(String id) =>
      asanas.where((a) => a.id == id).firstOrNull;

  static AsanaTranslation? translation(String asanaId, String localeCode) {
    final exact = _translations.where(
      (t) => t.asanaId == asanaId && t.localeCode == localeCode,
    );
    if (exact.isNotEmpty) return exact.first;

    // Same fallback rule as the texts: a posture may be described in one
    // language before another.
    return _translations
        .where((t) => t.asanaId == asanaId && t.localeCode == 'en')
        .firstOrNull;
  }

  // ------------------------------------------------------------- postures
  //
  // Geometry notes for whoever adds the next posture:
  //   · The design box is 200 × 150, y downward, and figures should use most
  //     of it — a pose crammed into the bottom third renders as a smudge.
  //   · Every figure carries a short neck stroke. Without one the head reads
  //     as a bead floating above the shoulders.
  //   · Muscle marks sit on the midpoint of the limb they belong to, rotated
  //     to that limb's direction. A mark floating off the body is worse than
  //     no mark: it teaches the wrong location.
  //   · Rotation is radians, clockwise, and aligns the mark's long axis with
  //     the limb. For a limb vector (dx, dy): rotation = atan2(-dx, dy).
  //   · Render them and look. `flutter test test/render_figures.dart` writes
  //     a PNG per posture — coordinates authored blind pass every assertion
  //     in the suite and still draw nonsense.

  static const _tadasana = Asana(
    id: 'asana.tadasana',
    devanagari: 'ताडासन',
    iast: 'tāḍāsana',
    figure: AsanaFigure(
      strokes: [
        [FigurePoint(94, 144), FigurePoint(96, 88)],
        [FigurePoint(106, 144), FigurePoint(104, 88)],
        [FigurePoint(100, 88), FigurePoint(100, 52)],
        [FigurePoint(100, 52), FigurePoint(100, 44)],
        [FigurePoint(86, 54), FigurePoint(114, 54)],
        [FigurePoint(86, 54), FigurePoint(84, 98)],
        [FigurePoint(114, 54), FigurePoint(116, 98)],
      ],
      head: FigurePoint(100, 34),
      headRadius: 9,
      marks: [
        MuscleMark(
          group: MuscleGroup.spinalErectors,
          center: FigurePoint(100, 70),
          rx: 5,
          ry: 16,
        ),
        MuscleMark(
          group: MuscleGroup.quadriceps,
          center: FigurePoint(95, 108),
          rx: 5,
          ry: 18,
        ),
        MuscleMark(
          group: MuscleGroup.calves,
          center: FigurePoint(105, 130),
          rx: 5,
          ry: 12,
        ),
      ],
    ),
    muscles: [
      AsanaMuscle(MuscleGroup.spinalErectors, MuscleAction.engages,
          primary: true),
      AsanaMuscle(MuscleGroup.quadriceps, MuscleAction.engages),
      AsanaMuscle(MuscleGroup.calves, MuscleAction.engages),
    ],
    vayu: 'prana',
  );

  /// Front view, tilted to the right: feet wide, both legs straight, the torso
  /// extending sideways over the front leg, top arm up, bottom arm down the
  /// shin, gaze following the top hand.
  static const _trikonasana = Asana(
    id: 'asana.trikonasana',
    devanagari: 'त्रिकोणासन',
    iast: 'trikoṇāsana',
    figure: AsanaFigure(
      strokes: [
        [FigurePoint(28, 144), FigurePoint(100, 86)],
        [FigurePoint(100, 86), FigurePoint(172, 144)],
        [FigurePoint(100, 86), FigurePoint(146, 66)],
        [FigurePoint(146, 66), FigurePoint(154, 60)],
        [FigurePoint(146, 66), FigurePoint(130, 16)],
        [FigurePoint(146, 66), FigurePoint(162, 122)],
      ],
      head: FigurePoint(160, 52),
      headRadius: 9,
      marks: [
        MuscleMark(
          group: MuscleGroup.externalOblique,
          center: FigurePoint(123, 76),
          rx: 7,
          ry: 20,
          rotation: 1.16,
        ),
        MuscleMark(
          group: MuscleGroup.quadratusLumborum,
          center: FigurePoint(110, 82),
          rx: 5,
          ry: 10,
          rotation: 1.16,
        ),
        MuscleMark(
          group: MuscleGroup.hamstrings,
          center: FigurePoint(136, 115),
          rx: 6,
          ry: 24,
          rotation: -0.893,
        ),
        MuscleMark(
          group: MuscleGroup.quadriceps,
          center: FigurePoint(64, 115),
          rx: 6,
          ry: 24,
          rotation: 0.893,
        ),
        MuscleMark(
          group: MuscleGroup.sacroiliacJoint,
          center: FigurePoint(100, 88),
          rx: 9,
          ry: 7,
        ),
      ],
    ),
    muscles: [
      AsanaMuscle(MuscleGroup.externalOblique, MuscleAction.stretches,
          primary: true),
      AsanaMuscle(MuscleGroup.quadratusLumborum, MuscleAction.stretches),
      AsanaMuscle(MuscleGroup.hamstrings, MuscleAction.stretches,
          primary: true),
      AsanaMuscle(MuscleGroup.quadriceps, MuscleAction.engages),
      AsanaMuscle(MuscleGroup.sacroiliacJoint, MuscleAction.stretches),
    ],
    vayu: 'samana',
  );

  static const _virabhadrasanaII = Asana(
    id: 'asana.virabhadrasana_ii',
    devanagari: 'वीरभद्रासन द्वितीय',
    iast: 'vīrabhadrāsana II',
    figure: AsanaFigure(
      strokes: [
        [FigurePoint(26, 144), FigurePoint(100, 80)],
        [FigurePoint(100, 80), FigurePoint(150, 106), FigurePoint(150, 144)],
        [FigurePoint(100, 80), FigurePoint(100, 50)],
        [FigurePoint(100, 50), FigurePoint(104, 42)],
        [FigurePoint(30, 52), FigurePoint(100, 50), FigurePoint(170, 52)],
      ],
      head: FigurePoint(108, 33),
      headRadius: 9,
      marks: [
        MuscleMark(
          group: MuscleGroup.quadriceps,
          center: FigurePoint(125, 93),
          rx: 7,
          ry: 24,
          rotation: -1.09,
        ),
        MuscleMark(
          group: MuscleGroup.adductors,
          center: FigurePoint(63, 112),
          rx: 6,
          ry: 30,
          rotation: 0.858,
        ),
        MuscleMark(
          group: MuscleGroup.glutes,
          center: FigurePoint(98, 84),
          rx: 10,
          ry: 7,
        ),
        MuscleMark(
          group: MuscleGroup.deltoids,
          center: FigurePoint(100, 51),
          rx: 26,
          ry: 5,
        ),
      ],
    ),
    muscles: [
      AsanaMuscle(MuscleGroup.quadriceps, MuscleAction.engages, primary: true),
      AsanaMuscle(MuscleGroup.deltoids, MuscleAction.engages, primary: true),
      AsanaMuscle(MuscleGroup.adductors, MuscleAction.stretches),
      AsanaMuscle(MuscleGroup.glutes, MuscleAction.engages),
    ],
    vayu: 'prana',
  );

  /// Side view. Hands to shoulders is the arm, shoulders to hips the torso —
  /// drawn as a bend rather than one line so the head has a shoulder to hang
  /// from.
  static const _adhoMukhaSvanasana = Asana(
    id: 'asana.adho_mukha_svanasana',
    devanagari: 'अधोमुखश्वानासन',
    iast: 'adho mukha śvānāsana',
    figure: AsanaFigure(
      strokes: [
        [FigurePoint(34, 140), FigurePoint(86, 78), FigurePoint(110, 44)],
        [FigurePoint(110, 44), FigurePoint(174, 140)],
        // The neck drops inside the V so the head hangs clear of the arm
        // line. Sitting it on the line made it read as a bead on a string.
        [FigurePoint(86, 78), FigurePoint(85, 94)],
      ],
      head: FigurePoint(84, 103),
      headRadius: 8.5,
      marks: [
        MuscleMark(
          group: MuscleGroup.hamstrings,
          center: FigurePoint(142, 92),
          rx: 7,
          ry: 26,
          rotation: -0.588,
        ),
        MuscleMark(
          group: MuscleGroup.calves,
          center: FigurePoint(160, 120),
          rx: 6,
          ry: 14,
          rotation: -0.588,
        ),
        MuscleMark(
          group: MuscleGroup.latissimus,
          center: FigurePoint(96, 64),
          rx: 7,
          ry: 16,
          rotation: 0.61,
        ),
        MuscleMark(
          group: MuscleGroup.deltoids,
          center: FigurePoint(86, 78),
          rx: 7,
          ry: 9,
          rotation: 0.61,
        ),
      ],
    ),
    muscles: [
      AsanaMuscle(MuscleGroup.hamstrings, MuscleAction.stretches,
          primary: true),
      AsanaMuscle(MuscleGroup.calves, MuscleAction.stretches, primary: true),
      AsanaMuscle(MuscleGroup.latissimus, MuscleAction.stretches),
      AsanaMuscle(MuscleGroup.deltoids, MuscleAction.engages),
    ],
    vayu: 'apana',
  );

  /// Side view: shins along the floor, the seat resting back on the heels,
  /// the torso folded forward and down, arms extended past the head.
  static const _balasana = Asana(
    id: 'asana.balasana',
    devanagari: 'बालासन',
    iast: 'bālāsana',
    figure: AsanaFigure(
      strokes: [
        [FigurePoint(176, 100), FigurePoint(100, 100)],
        [FigurePoint(100, 100), FigurePoint(152, 56)],
        [FigurePoint(152, 56), FigurePoint(74, 88)],
        [FigurePoint(74, 88), FigurePoint(64, 84)],
        [FigurePoint(74, 90), FigurePoint(22, 100)],
      ],
      head: FigurePoint(56, 80),
      headRadius: 9,
      marks: [
        MuscleMark(
          group: MuscleGroup.spinalErectors,
          center: FigurePoint(113, 72),
          rx: 6,
          ry: 34,
          rotation: 1.181,
        ),
        MuscleMark(
          group: MuscleGroup.latissimus,
          center: FigurePoint(130, 65),
          rx: 6,
          ry: 16,
          rotation: 1.181,
        ),
        MuscleMark(
          group: MuscleGroup.quadriceps,
          center: FigurePoint(126, 78),
          rx: 6,
          ry: 22,
          rotation: 0.87,
        ),
      ],
    ),
    muscles: [
      AsanaMuscle(MuscleGroup.spinalErectors, MuscleAction.stretches,
          primary: true),
      AsanaMuscle(MuscleGroup.latissimus, MuscleAction.stretches),
      AsanaMuscle(MuscleGroup.quadriceps, MuscleAction.stretches),
    ],
    vayu: 'apana',
  );

  // --------------------------------------------------------- translations

  static const _translations = <AsanaTranslation>[
    // ---- English ----
    AsanaTranslation(
      asanaId: 'asana.tadasana',
      localeCode: 'en',
      name: 'Mountain',
      caution: 'Locking the knees back turns a standing posture into a brace.',
      subtle: 'Prana vayu · the upward, gathering breath',
    ),
    AsanaTranslation(
      asanaId: 'asana.trikonasana',
      localeCode: 'en',
      name: 'Triangle',
      caution: 'Hyperextension of the front knee.',
      subtle: 'Samana vayu · the digestive fire',
    ),
    AsanaTranslation(
      asanaId: 'asana.virabhadrasana_ii',
      localeCode: 'en',
      name: 'Warrior II',
      caution: 'The front knee tracking inward, past the second toe.',
      subtle: 'Prana vayu · the upward, gathering breath',
    ),
    AsanaTranslation(
      asanaId: 'asana.adho_mukha_svanasana',
      localeCode: 'en',
      name: 'Downward-facing dog',
      caution:
          'Rounding the lower back to force the heels down. Bend the knees '
          'instead — the spine is the point, not the heels.',
      subtle: 'Apana vayu · the downward, releasing breath',
    ),
    AsanaTranslation(
      asanaId: 'asana.balasana',
      localeCode: 'en',
      name: "Child's pose",
      caution: 'Knee pressure. A blanket behind the knees changes everything.',
      subtle: 'Apana vayu · the downward, releasing breath',
    ),

    // ---- Español ----
    AsanaTranslation(
      asanaId: 'asana.tadasana',
      localeCode: 'es',
      name: 'Montaña',
      caution:
          'Trabar las rodillas hacia atrás convierte una postura de pie en un '
          'apuntalamiento.',
      subtle: 'Prana vayu · el aliento que sube y reúne',
    ),
    AsanaTranslation(
      asanaId: 'asana.trikonasana',
      localeCode: 'es',
      name: 'Triángulo',
      caution: 'Hiperextensión de la rodilla adelantada.',
      subtle: 'Samana vayu · el fuego digestivo',
    ),
    AsanaTranslation(
      asanaId: 'asana.virabhadrasana_ii',
      localeCode: 'es',
      name: 'Guerrero II',
      caution: 'Que la rodilla de adelante se vaya hacia adentro del segundo dedo.',
      subtle: 'Prana vayu · el aliento que sube y reúne',
    ),
    AsanaTranslation(
      asanaId: 'asana.adho_mukha_svanasana',
      localeCode: 'es',
      name: 'Perro boca abajo',
      caution:
          'Redondear la zona lumbar para forzar los talones al piso. Mejor '
          'flexionar las rodillas — lo que importa es la columna, no los talones.',
      subtle: 'Apana vayu · el aliento que baja y suelta',
    ),
    AsanaTranslation(
      asanaId: 'asana.balasana',
      localeCode: 'es',
      name: 'Postura del niño',
      caution: 'Presión en las rodillas. Una manta atrás cambia todo.',
      subtle: 'Apana vayu · el aliento que baja y suelta',
    ),
  ];
}
