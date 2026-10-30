import 'package:flutter/material.dart';

import '../../core/domain/asana.dart';
import '../../design_system/tokens.dart';
import '../../design_system/typography.dart';
import '../../design_system/widgets.dart';
import '../../l10n/l10n_x.dart';

class MuscleSection extends StatelessWidget {
  const MuscleSection({
    super.key,
    required this.label,
    required this.muscles,
    required this.highlighted,
    required this.onTap,
  });

  final String label;
  final List<AsanaMuscle> muscles;
  final MuscleGroup? highlighted;
  final ValueChanged<MuscleGroup> onTap;

  @override
  Widget build(BuildContext context) {
    final l = context.l;
    final c = context.colors;

    return Padding(
      padding: const EdgeInsets.only(bottom: Space.md),
      child: Hanging(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MonoLabel(label),
            const SizedBox(height: 4),
            for (final muscle in muscles)
              InkWell(
                onTap: () => onTap(muscle.group),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 9),
                  child: Row(
                    children: [
                      Container(
                        width: 7,
                        height: 7,
                        margin: const EdgeInsets.only(right: 10),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: highlighted == muscle.group
                              ? c.accent
                              : muscle.primary
                              ? c.accent.withValues(alpha: 0.45)
                              : c.rule,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          l.muscle(muscle.group),
                          style: AppType.uiBody.copyWith(
                            color: highlighted == muscle.group
                                ? c.accent
                                : c.ink,
                          ),
                        ),
                      ),
                      if (muscle.primary)
                        MonoLabel(l.bodyPrimary, color: c.muted),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
