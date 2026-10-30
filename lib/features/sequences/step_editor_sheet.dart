import 'package:flutter/material.dart';

import '../../core/domain/practice_step.dart';
import '../../design_system/tokens.dart';
import '../../design_system/typography.dart';
import '../../design_system/widgets.dart';
import '../../l10n/l10n_x.dart';
import 'step_controls.dart';

Future<PracticeStep?> showStepEditor(
  BuildContext context, {
  required PracticeStep step,
}) => showModalBottomSheet<PracticeStep>(
  context: context,
  isScrollControlled: true,
  backgroundColor: context.colors.surface,
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
  ),
  builder: (_) => _StepEditor(initial: step),
);

class _StepEditor extends StatefulWidget {
  const _StepEditor({required this.initial});
  final PracticeStep initial;

  @override
  State<_StepEditor> createState() => _StepEditorState();
}

class _StepEditorState extends State<_StepEditor> {
  late PracticeStep _step = widget.initial;

  @override
  Widget build(BuildContext context) {
    final l = context.l;
    final c = context.colors;

    return Padding(
      padding: EdgeInsets.only(
        left: Space.screen,
        right: Space.screen,
        top: Space.md,
        bottom: MediaQuery.of(context).viewInsets.bottom + Space.lg,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              width: 36,
              height: 3,
              decoration: BoxDecoration(
                color: c.rule,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: Space.md),
          MonoLabel(l.stepKindLabel(_step)),
          const SizedBox(height: 4),
          Text(
            l.stepSummary(_step),
            style: AppType.heading.copyWith(color: c.ink),
          ),
          const SizedBox(height: Space.lg),
          StepControls(
            step: _step,
            onChanged: (next) => setState(() => _step = next),
          ),
          const SizedBox(height: Space.lg),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(_step),
            child: Text(l.editorSave),
          ),
        ],
      ),
    );
  }
}
