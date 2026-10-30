import 'package:flutter/material.dart';

import '../../core/domain/anga.dart';
import '../../design_system/widgets.dart';
import '../../l10n/l10n_x.dart';

class SavedWithAngas extends StatelessWidget {
  const SavedWithAngas({super.key, required this.angas});

  final Set<Anga> angas;

  @override
  Widget build(BuildContext context) {
    return Hanging(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MonoLabel(context.l.journalSavedWith),
          const SizedBox(height: 8),
          Wrap(
            spacing: 5,
            runSpacing: 5,
            children: [
              for (final anga in angas) AngaChip(anga.iast, active: true),
            ],
          ),
        ],
      ),
    );
  }
}
