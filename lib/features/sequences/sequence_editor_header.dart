import 'package:flutter/material.dart';

import '../../design_system/tokens.dart';
import '../../design_system/typography.dart';
import '../../l10n/l10n_x.dart';

class SequenceEditorHeader extends StatelessWidget {
  const SequenceEditorHeader({
    super.key,
    required this.title,
    required this.isCopy,
    required this.stepCount,
    required this.total,
  });

  final TextEditingController title;
  final bool isCopy;
  final int stepCount;
  final Duration total;

  @override
  Widget build(BuildContext context) {
    final l = context.l;
    final c = context.colors;

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        Space.screen,
        0,
        Space.screen,
        Space.sm,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isCopy) ...[
            Text(
              l.sequencesSeededNotice,
              style: AppType.uiBody.copyWith(fontSize: 12.5, color: c.ember),
            ),
            const SizedBox(height: Space.sm),
          ],
          TextField(
            controller: title,
            style: AppType.practiceTitle.copyWith(color: c.ink),
            decoration: InputDecoration(
              hintText: l.editorTitleHint,
              hintStyle: AppType.practiceTitle.copyWith(color: c.muted),
              border: InputBorder.none,
              isDense: true,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            l.editorTotal(stepCount, total.inMinutes),
            style: AppType.uiBody.copyWith(fontSize: 12.5, color: c.muted),
          ),
        ],
      ),
    );
  }
}
