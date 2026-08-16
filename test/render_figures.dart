// Not a test — a rendering harness. Run with:
//   flutter test test/render_figures.dart
// It writes one PNG per posture so the figures can actually be looked at.
// Coordinates authored blind pass every assertion and still draw nonsense.
import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sadhana/data/corpus/asana_catalogue.dart';
import 'package:sadhana/design_system/app_theme.dart';
import 'package:sadhana/features/body/asana_figure_view.dart';

void main() {
  testWidgets('render every posture', (tester) async {
    final outDir = Directory(
      Platform.environment['FIGURE_OUT'] ?? '/tmp/figures',
    )..createSync(recursive: true);

    for (final asana in AsanaCatalogue.asanas) {
      final key = GlobalKey();

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light(),
          home: Scaffold(
            body: Center(
              child: RepaintBoundary(
                key: key,
                child: SizedBox(
                  width: 320,
                  height: 240,
                  child: ColoredBox(
                    color: const Color(0xFFE7E9E6),
                    child: AsanaFigureView(asana: asana, height: 240),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final boundary =
          key.currentContext!.findRenderObject()! as RenderRepaintBoundary;

      await tester.runAsync(() async {
        final image = await boundary.toImage(pixelRatio: 2);
        final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
        File('${outDir.path}/${asana.id.replaceAll('.', '_')}.png')
            .writeAsBytesSync(bytes!.buffer.asUint8List());
      });
    }
  });
}
