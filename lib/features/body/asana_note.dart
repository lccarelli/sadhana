import 'package:flutter/material.dart';

import '../../design_system/tokens.dart';
import '../../design_system/typography.dart';
import '../../design_system/widgets.dart';

class AsanaNote extends StatelessWidget {
  const AsanaNote({
    super.key,
    required this.label,
    required this.body,
    this.labelColor,
    this.subtle = false,
  });

  final String label;
  final String body;
  final Color? labelColor;
  final bool subtle;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;

    return Hanging(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MonoLabel(label, color: labelColor),
          const SizedBox(height: 6),
          Text(
            body,
            style: AppType.readingBody.copyWith(
              fontSize: 14.5,
              fontStyle: subtle ? FontStyle.italic : null,
              color: subtle ? c.ink2 : c.ink,
            ),
          ),
        ],
      ),
    );
  }
}
