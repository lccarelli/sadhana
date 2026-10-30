import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/providers.dart';
import '../../design_system/widgets.dart';
import '../../l10n/l10n_x.dart';

class ContinuitySection extends ConsumerWidget {
  const ContinuitySection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final continuity = ref.watch(continuityProvider);

    return Hanging(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MonoLabel(context.l.todayContinuity(14)),
          const SizedBox(height: 9),
          ContinuityStrip(
            secondsPerDay: continuity.maybeWhen(
              data: (days) => days,
              orElse: () => List<int>.filled(14, 0),
            ),
          ),
        ],
      ),
    );
  }
}
