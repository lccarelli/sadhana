import '../../../core/domain/asana.dart';

const virabhadrasanaII = Asana(
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
