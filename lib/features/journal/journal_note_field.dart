import 'package:flutter/material.dart';

import '../../design_system/tokens.dart';
import '../../design_system/typography.dart';
import '../../design_system/widgets.dart';
import '../../l10n/l10n_x.dart';

class JournalNoteField extends StatelessWidget {
  const JournalNoteField({super.key, required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    final l = context.l;
    final c = context.colors;

    return Hanging(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MonoLabel(l.journalNote),
          const SizedBox(height: 6),
          TextField(
            controller: controller,
            maxLines: 5,
            autofocus: false,
            style: AppType.readingBody.copyWith(fontSize: 14.5, color: c.ink2),
            decoration: InputDecoration(
              hintText: l.journalNoteHint,
              hintStyle: AppType.readingBody.copyWith(
                fontSize: 14.5,
                color: c.muted,
              ),
              border: InputBorder.none,
            ),
          ),
        ],
      ),
    );
  }
}
