import 'package:flutter/material.dart';

import '../../core/domain/anga.dart';
import '../../design_system/tokens.dart';
import '../../design_system/typography.dart';
import '../../design_system/widgets.dart';
import '../../l10n/l10n_x.dart';

/// The eight limbs as a ladder.
///
/// Numbered because they genuinely are a sequence — Patanjali's order carries
/// information. The progression is drawn with opacity on a single accent
/// rather than eight hues, so the eye reads a path instead of eight
/// unrelated categories.
class PathScreen extends StatelessWidget {
  const PathScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l = context.l;
    final c = context.colors;

    return Scaffold(
      appBar: AppBar(title: MonoLabel(l.navPath)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          Space.screen,
          0,
          Space.screen,
          Space.xl,
        ),
        children: [
          for (final anga in Anga.values) ...[
            if (anga == Anga.yama) MonoLabel(l.limbOuter),
            if (anga == Anga.dharana) ...[
              const SizedBox(height: Space.md),
              MonoLabel(l.limbInner, color: c.accent),
            ],
            _Rung(anga: anga),
          ],
        ],
      ),
    );
  }
}

class _Rung extends StatelessWidget {
  const _Rung({required this.anga});
  final Anga anga;

  @override
  Widget build(BuildContext context) {
    final l = context.l;
    final c = context.colors;

    // 0.46 at yama through 1.0 at samadhi: the ladder is felt, not labelled.
    final weight = 0.46 + 0.54 * ((anga.position - 1) / 7);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 13),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: c.rule)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 30,
            child: Text(
              anga.position.toString().padLeft(2, '0'),
              style: AppType.numeric.copyWith(fontSize: 11.5, color: c.muted),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      anga.iast,
                      style: AppType.heading.copyWith(
                        color: c.ink.withValues(alpha: weight),
                      ),
                    ),
                    const SizedBox(width: 9),
                    Sanskrit(
                      anga.devanagari,
                      size: 16,
                      color: c.accent.withValues(alpha: weight),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  l.anga(anga),
                  style: AppType.uiBody.copyWith(fontSize: 13.5, color: c.ink2),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
