import '../../../core/domain/asana.dart';

const trikonasana = Asana(
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
    AsanaMuscle(
      MuscleGroup.externalOblique,
      MuscleAction.stretches,
      primary: true,
    ),
    AsanaMuscle(MuscleGroup.quadratusLumborum, MuscleAction.stretches),
    AsanaMuscle(MuscleGroup.hamstrings, MuscleAction.stretches, primary: true),
    AsanaMuscle(MuscleGroup.quadriceps, MuscleAction.engages),
    AsanaMuscle(MuscleGroup.sacroiliacJoint, MuscleAction.stretches),
  ],
  vayu: 'samana',
);
