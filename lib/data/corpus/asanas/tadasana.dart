import '../../../core/domain/asana.dart';

const tadasana = Asana(
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
    AsanaMuscle(
      MuscleGroup.spinalErectors,
      MuscleAction.engages,
      primary: true,
    ),
    AsanaMuscle(MuscleGroup.quadriceps, MuscleAction.engages),
    AsanaMuscle(MuscleGroup.calves, MuscleAction.engages),
  ],
  vayu: 'prana',
);
