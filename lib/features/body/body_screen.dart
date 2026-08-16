import 'package:flutter/material.dart';

import '../../data/corpus/asana_catalogue.dart';
import '../../design_system/tokens.dart';
import '../../design_system/typography.dart';
import '../../design_system/widgets.dart';
import '../../l10n/l10n_x.dart';
import 'asana_figure_view.dart';
import 'asana_screen.dart';

/// The postures we ship, each drawn rather than photographed.
class BodyScreen extends StatelessWidget {
  const BodyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l = context.l;
    final c = context.colors;

    return Scaffold(
      appBar: AppBar(title: MonoLabel(l.navBody)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          Space.screen,
          0,
          Space.screen,
          Space.xl,
        ),
        children: [
          Text(
            l.bodyPostures,
            style: AppType.practiceTitle.copyWith(color: c.ink),
          ),
          const SizedBox(height: Space.md),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: Space.md,
            crossAxisSpacing: Space.md,
            childAspectRatio: 0.82,
            children: [
              for (final asana in AsanaCatalogue.asanas)
                InkWell(
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => AsanaScreen(asana: asana),
                    ),
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: c.surface,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: AsanaFigureView(asana: asana, height: 110),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          l.asanaName(asana.id),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppType.heading.copyWith(
                            fontSize: 15,
                            color: c.ink,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Sanskrit(asana.devanagari, size: 13),
                      ],
                    ),
                  ),
                ),
            ],
          ),

          const SizedBox(height: Space.lg),
          Text(
            l.bodyDisclaimer,
            style: AppType.uiBody.copyWith(fontSize: 12, color: c.muted),
          ),
        ],
      ),
    );
  }
}
