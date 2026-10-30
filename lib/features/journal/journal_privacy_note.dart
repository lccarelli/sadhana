import 'package:flutter/material.dart';

import '../../design_system/tokens.dart';
import '../../design_system/typography.dart';
import '../../l10n/l10n_x.dart';

class JournalPrivacyNote extends StatelessWidget {
  const JournalPrivacyNote({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      '⌂ ${context.l.journalPrivacy}',
      style: AppType.label.copyWith(
        fontSize: 9.5,
        letterSpacing: 0.4,
        color: context.colors.muted,
      ),
    );
  }
}
