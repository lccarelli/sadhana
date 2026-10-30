import 'package:flutter/material.dart';

import '../../data/sadhana/step_codec.dart';
import '../../design_system/tokens.dart';
import '../../design_system/typography.dart';
import '../../design_system/widgets.dart';
import '../../l10n/l10n_x.dart';

class AddStepBar extends StatelessWidget {
  const AddStepBar({super.key, required this.onPick});

  final ValueChanged<StepKind> onPick;

  @override
  Widget build(BuildContext context) {
    final l = context.l;
    final c = context.colors;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          Space.screen,
          Space.sm,
          Space.screen,
          Space.sm,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(height: 1, color: c.rule),
            const SizedBox(height: Space.sm),
            MonoLabel(l.editorAddStep),
            const SizedBox(height: 6),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  for (final kind in StepKind.values)
                    Padding(
                      padding: const EdgeInsets.only(right: 6),
                      child: ActionChip(
                        onPressed: () => onPick(kind),
                        side: BorderSide(color: c.rule),
                        backgroundColor: Colors.transparent,
                        label: Text(
                          l.stepKindLabel(StepCodec.blank(kind)),
                          style: AppType.uiBody.copyWith(
                            fontSize: 13,
                            color: c.ink,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
