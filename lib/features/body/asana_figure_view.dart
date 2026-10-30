import 'package:flutter/material.dart';

import '../../core/domain/asana.dart';
import '../../design_system/tokens.dart';
import 'asana_painter.dart';

class AsanaFigureView extends StatelessWidget {
  const AsanaFigureView({
    super.key,
    required this.asana,
    this.highlighted,
    this.height = 220,
  });

  final Asana asana;

  final MuscleGroup? highlighted;

  final double height;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;

    return SizedBox(
      height: height,
      width: double.infinity,
      child: CustomPaint(
        painter: AsanaPainter(
          asana: asana,
          highlighted: highlighted,
          body: c.ink,
          muscle: c.accent,
        ),
        child: Semantics(label: asana.iast, child: const SizedBox.expand()),
      ),
    );
  }
}
