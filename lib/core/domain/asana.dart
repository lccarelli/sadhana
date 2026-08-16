import 'anga.dart';

/// A point in the figure's design space, 200 × 150, y downward.
///
/// Deliberately not `Offset`: that lives in `dart:ui`, and `core/domain`
/// imports no Flutter. Six lines of ceremony to keep the rule intact, and the
/// painter converts at the edge.
class FigurePoint {
  const FigurePoint(this.x, this.y);
  final double x;
  final double y;
}

/// What a posture asks of the body.
///
/// A closed set on purpose. An open string field would drift into fifty
/// spellings of "hamstrings" and make "every practice that stretches the
/// psoas" unanswerable — which is the question this whole screen exists for.
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

  /// The one or two the practitioner should actually feel. Drawn stronger.
  final bool primary;
}

/// Where a muscle group sits in a particular posture. Positions are
/// per-posture because the same muscle is somewhere else in every shape.
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

  /// Radians.
  final double rotation;
}

/// A drawable posture: polylines for the body, a head, and muscle marks.
///
/// Our own geometry rather than a licensed anatomical atlas. That is not a
/// stylistic preference — atlas illustrations are the single most expensive
/// thing to license in an app like this, and the reason most of them never
/// ship an anatomy section at all.
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

/// A posture's identity. Devanagari and IAST are invariant across languages,
/// exactly as for a corpus text — the vernacular name is the only part that
/// gets translated. See [AsanaTranslation].
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

  /// Subtle-layer note, e.g. 'samana'. Always presented with its disclaimer,
  /// never mixed into the anatomical claims.
  final String? vayu;

  Iterable<AsanaMuscle> get stretches =>
      muscles.where((m) => m.action == MuscleAction.stretches);

  Iterable<AsanaMuscle> get engages =>
      muscles.where((m) => m.action == MuscleAction.engages);
}

/// One posture rendered into one language.
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

  /// "Triangle", "Triángulo" — the everyday name, not the Sanskrit.
  final String name;

  /// What to watch for. Wellness guidance, never clinical advice.
  final String? caution;

  /// The subtle-layer gloss, kept typographically apart from the anatomy.
  final String? subtle;
}
