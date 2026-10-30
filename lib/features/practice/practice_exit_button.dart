import 'package:flutter/material.dart';

import '../../design_system/tokens.dart';
import '../../l10n/l10n_x.dart';

class PracticeExitButton extends StatelessWidget {
  const PracticeExitButton({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      child: IconButton(
        onPressed: onPressed,
        tooltip: context.l.runnerExit,
        icon: Icon(Icons.close, size: 20, color: context.colors.muted),
      ),
    );
  }
}
