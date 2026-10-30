import '../../../core/domain/asana.dart';

const adhoMukhaSvanasana = Asana(
  id: 'asana.adho_mukha_svanasana',
  devanagari: 'अधोमुखश्वानासन',
  iast: 'adho mukha śvānāsana',
  figure: AsanaFigure(
    strokes: [
      [FigurePoint(34, 140), FigurePoint(86, 78), FigurePoint(110, 44)],
      [FigurePoint(110, 44), FigurePoint(174, 140)],
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
    AsanaMuscle(MuscleGroup.hamstrings, MuscleAction.stretches, primary: true),
    AsanaMuscle(MuscleGroup.calves, MuscleAction.stretches, primary: true),
    AsanaMuscle(MuscleGroup.latissimus, MuscleAction.stretches),
    AsanaMuscle(MuscleGroup.deltoids, MuscleAction.engages),
  ],
  vayu: 'apana',
);
