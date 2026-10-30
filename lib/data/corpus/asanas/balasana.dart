import '../../../core/domain/asana.dart';

const balasana = Asana(
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
    AsanaMuscle(
      MuscleGroup.spinalErectors,
      MuscleAction.stretches,
      primary: true,
    ),
    AsanaMuscle(MuscleGroup.latissimus, MuscleAction.stretches),
    AsanaMuscle(MuscleGroup.quadriceps, MuscleAction.stretches),
  ],
  vayu: 'apana',
);
