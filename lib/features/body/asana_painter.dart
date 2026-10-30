import 'package:flutter/material.dart';

import '../../core/domain/asana.dart';

class AsanaPainter extends CustomPainter {
  const AsanaPainter({
    required this.asana,
    required this.highlighted,
    required this.body,
    required this.muscle,
  });

  final Asana asana;
  final MuscleGroup? highlighted;
  final Color body;
  final Color muscle;

  @override
  void paint(Canvas canvas, Size size) {
    final figure = asana.figure;

    final scale = (size.width / AsanaFigure.designWidth).clamp(
      0.0,
      size.height / AsanaFigure.designHeight,
    );
    final dx = (size.width - AsanaFigure.designWidth * scale) / 2;
    final dy = (size.height - AsanaFigure.designHeight * scale) / 2;

    canvas.save();
    canvas.translate(dx, dy);
    canvas.scale(scale);

    _paintMuscles(canvas);
    _paintBody(canvas, figure);

    canvas.restore();
  }

  void _paintMuscles(Canvas canvas) {
    final primaries = {
      for (final m in asana.muscles)
        if (m.primary) m.group,
    };

    for (final mark in asana.figure.marks) {
      final isHighlighted = highlighted == mark.group;
      final isPrimary = highlighted == null && primaries.contains(mark.group);

      final opacity = isHighlighted
          ? 0.75
          : isPrimary
          ? 0.42
          : 0.16;

      canvas.save();
      canvas.translate(mark.center.x, mark.center.y);
      canvas.rotate(mark.rotation);
      canvas.drawOval(
        Rect.fromCenter(
          center: Offset.zero,
          width: mark.rx * 2,
          height: mark.ry * 2,
        ),
        Paint()..color = muscle.withValues(alpha: opacity),
      );
      canvas.restore();
    }
  }

  void _paintBody(Canvas canvas, AsanaFigure figure) {
    final stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.6
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..color = body.withValues(alpha: 0.62);

    for (final polyline in figure.strokes) {
      if (polyline.length < 2) continue;
      final path = Path()..moveTo(polyline.first.x, polyline.first.y);
      for (final point in polyline.skip(1)) {
        path.lineTo(point.x, point.y);
      }
      canvas.drawPath(path, stroke);
    }

    canvas.drawCircle(
      Offset(figure.head.x, figure.head.y),
      figure.headRadius,
      stroke,
    );
  }

  @override
  bool shouldRepaint(AsanaPainter old) =>
      old.asana.id != asana.id ||
      old.highlighted != highlighted ||
      old.body != body ||
      old.muscle != muscle;
}
