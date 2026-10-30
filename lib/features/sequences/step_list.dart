import 'package:flutter/material.dart';

import '../../core/domain/practice_step.dart';
import '../../design_system/tokens.dart';
import '../../design_system/typography.dart';
import '../../l10n/l10n_x.dart';
import 'step_tile.dart';

class StepList extends StatelessWidget {
  const StepList({
    super.key,
    required this.steps,
    required this.onReorder,
    required this.onEdit,
    required this.onRemove,
  });

  final List<PracticeStep> steps;
  final ReorderCallback onReorder;
  final ValueChanged<int> onEdit;
  final ValueChanged<int> onRemove;

  @override
  Widget build(BuildContext context) {
    if (steps.isEmpty) {
      return Center(
        child: Text(
          context.l.editorNoSteps,
          style: AppType.uiBody.copyWith(color: context.colors.muted),
        ),
      );
    }

    return ReorderableListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: Space.screen),
      itemCount: steps.length,
      onReorder: onReorder,
      itemBuilder: (context, i) => StepTile(
        key: ValueKey('${steps[i].hashCode}-$i'),
        index: i,
        step: steps[i],
        onTap: () => onEdit(i),
        onRemove: () => onRemove(i),
      ),
    );
  }
}
