import 'package:flutter/material.dart';

import '../../design_system/tokens.dart';

class StepProgress extends StatelessWidget {
  const StepProgress({super.key, required this.count, required this.current});

  final int count;
  final int current;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (var i = 0; i < count; i++)
          AnimatedContainer(
            duration: Beat.quarter,
            margin: const EdgeInsets.symmetric(horizontal: 2.5),
            width: i == current ? 28 : 15,
            height: 2.5,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(2),
              color: i == current ? c.accent : (i < current ? c.muted : c.rule),
            ),
          ),
      ],
    );
  }
}
