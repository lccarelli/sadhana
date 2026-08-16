import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../design_system/tokens.dart';

/// The breathing ring. Fills over the current phase and empties into the
/// next; the orb inside scales with the lungs and turns ember on the exhale.
class BreathRing extends StatelessWidget {
  const BreathRing({
    super.key,
    required this.progress,
    required this.expanded,
    required this.exhaling,
    this.size = 214,
  });

  /// 0..1 through the current phase.
  final double progress;

  /// Whether the lungs are full — drives the orb scale.
  final bool expanded;

  /// Ember instead of verdigris. Semantic, never decorative.
  final bool exhaling;

  final double size;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final arc = exhaling ? c.ember : c.accent;

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: Size.square(size),
            painter: _RingPainter(
              progress: progress.clamp(0, 1),
              track: c.rule,
              arc: arc,
            ),
          ),
          AnimatedContainer(
            duration: const Duration(seconds: 1),
            curve: Beat.ease,
            width: size * 0.49 * (expanded ? 1.24 : 0.80),
            height: size * 0.49 * (expanded ? 1.24 : 0.80),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: arc),
              gradient: RadialGradient(
                center: const Alignment(0, -0.16),
                colors: [c.accentSoft, c.accentSoft.withValues(alpha: 0)],
                stops: const [0, 0.72],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  const _RingPainter({
    required this.progress,
    required this.track,
    required this.arc,
  });

  final double progress;
  final Color track;
  final Color arc;

  @override
  void paint(Canvas canvas, Size size) {
    final centre = size.center(Offset.zero);
    final radius = size.width / 2 - 4;

    canvas.drawCircle(
      centre,
      radius,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5
        ..color = track,
    );

    if (progress <= 0) return;

    canvas.drawArc(
      Rect.fromCircle(center: centre, radius: radius),
      -math.pi / 2,
      progress * 2 * math.pi,
      false,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3
        ..strokeCap = StrokeCap.round
        ..color = arc,
    );
  }

  @override
  bool shouldRepaint(_RingPainter old) =>
      old.progress != progress || old.arc != arc || old.track != track;
}
