import 'package:flutter/material.dart';

import '../../design_system/tokens.dart';
import '../../design_system/typography.dart';
import '../../l10n/l10n_x.dart';

class JournalEmpty extends StatelessWidget {
  const JournalEmpty({super.key});

  @override
  Widget build(BuildContext context) {
    final l = context.l;
    final c = context.colors;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(Space.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              l.journalEmpty,
              textAlign: TextAlign.center,
              style: AppType.heading.copyWith(color: c.ink2),
            ),
            const SizedBox(height: Space.sm),
            Text(
              l.journalEmptyDetail,
              textAlign: TextAlign.center,
              style: AppType.uiBody.copyWith(fontSize: 13.5, color: c.muted),
            ),
          ],
        ),
      ),
    );
  }
}
