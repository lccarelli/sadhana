import 'package:flutter/material.dart';

import '../../core/domain/practice_step.dart';
import '../../design_system/tokens.dart';
import '../../design_system/typography.dart';
import '../../l10n/l10n_x.dart';

class StepTile extends StatelessWidget {
  const StepTile({
    super.key,
    required this.index,
    required this.step,
    required this.onTap,
    required this.onRemove,
  });

  final int index;
  final PracticeStep step;
  final VoidCallback onTap;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final l = context.l;
    final c = context.colors;

    return Dismissible(
      key: ValueKey('dismiss-$index-${step.hashCode}'),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: Space.md),
        child: Icon(Icons.remove_circle_outline, color: c.ember, size: 20),
      ),
      onDismissed: (_) => onRemove(),
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 13),
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: c.rule)),
          ),
          child: Row(
            children: [
              SizedBox(
                width: 30,
                child: Text(
                  (index + 1).toString().padLeft(2, '0'),
                  style: AppType.numeric.copyWith(
                    fontSize: 11.5,
                    color: c.muted,
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l.stepKindLabel(step),
                      style: AppType.heading.copyWith(
                        fontSize: 16,
                        color: c.ink,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      l.stepSummary(step),
                      style: AppType.uiBody.copyWith(
                        fontSize: 12.5,
                        color: c.ink2,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.drag_handle, size: 18, color: c.rule),
            ],
          ),
        ),
      ),
    );
  }
}
