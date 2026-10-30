import 'anga.dart';

class FigurePoint {
  const FigurePoint(this.x, this.y);
  final double x;
  final double y;
}

enum MuscleGroup {
  externalOblique,
  quadratusLumborum,
  hamstrings,
  quadriceps,
  glutes,
  psoas,
  pectorals,
  latissimus,
  deltoids,
  spinalErectors,
  adductors,
  calves,
  sacroiliacJoint,
}

enum MuscleAction { stretches, engages }

class AsanaMuscle {
  const AsanaMuscle(this.group, this.action, {this.primary = false});

  final MuscleGroup group;
  final MuscleAction action;

  final bool primary;
}

class MuscleMark {
  const MuscleMark({
    required this.group,
    required this.center,
    required this.rx,
    required this.ry,
    this.rotation = 0,
  });

  final MuscleGroup group;
  final FigurePoint center;
  final double rx;
  final double ry;

  final double rotation;
}

class AsanaFigure {
  const AsanaFigure({
    required this.strokes,
    required this.head,
    required this.headRadius,
    required this.marks,
  });

  static const designWidth = 200.0;
  static const designHeight = 150.0;

  final List<List<FigurePoint>> strokes;
  final FigurePoint head;
  final double headRadius;
  final List<MuscleMark> marks;

  MuscleMark? markFor(MuscleGroup group) =>
      marks.where((m) => m.group == group).firstOrNull;
}

class Asana {
  const Asana({
    required this.id,
    required this.devanagari,
    required this.iast,
    required this.figure,
    required this.muscles,
    this.angas = const {Anga.asana},
    this.vayu,
  });

  final String id;
  final String devanagari;
  final String iast;
  final AsanaFigure figure;
  final List<AsanaMuscle> muscles;
  final Set<Anga> angas;

  final String? vayu;

  Iterable<AsanaMuscle> get stretches =>
      muscles.where((m) => m.action == MuscleAction.stretches);

  Iterable<AsanaMuscle> get engages =>
      muscles.where((m) => m.action == MuscleAction.engages);
}

class AsanaTranslation {
  const AsanaTranslation({
    required this.asanaId,
    required this.localeCode,
    required this.name,
    this.caution,
    this.subtle,
  });

  final String asanaId;
  final String localeCode;

  final String name;

  final String? caution;

  final String? subtle;
}
