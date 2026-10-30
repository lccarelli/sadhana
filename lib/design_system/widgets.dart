import 'package:flutter/material.dart';

import 'tokens.dart';
import 'typography.dart';

class Hanging extends StatelessWidget {
  const Hanging({
    super.key,
    required this.child,
    this.strong = false,
    this.gap = 10,
  });

  final Widget child;
  final bool strong;
  final double gap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(height: strong ? 1.5 : 1, color: strong ? c.muted : c.rule),
        SizedBox(height: gap),
        child,
      ],
    );
  }
}

class MonoLabel extends StatelessWidget {
  const MonoLabel(this.text, {super.key, this.color, this.align});

  final String text;
  final Color? color;
  final TextAlign? align;

  @override
  Widget build(BuildContext context) => Text(
    text.toUpperCase(),
    textAlign: align,
    style: AppType.label.copyWith(color: color ?? context.colors.muted),
  );
}

class AngaChip extends StatelessWidget {
  const AngaChip(this.label, {super.key, this.active = false});

  final String label;
  final bool active;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
      decoration: BoxDecoration(
        border: Border.all(color: active ? c.accent : c.rule),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label.toUpperCase(),
        style: AppType.label.copyWith(
          fontSize: 9,
          color: active ? c.accent : c.muted,
        ),
      ),
    );
  }
}

class Sanskrit extends StatelessWidget {
  const Sanskrit(this.devanagari, {super.key, this.size, this.color});

  final String devanagari;
  final double? size;
  final Color? color;

  @override
  Widget build(BuildContext context) => Text(
    devanagari,
    style: AppType.sanskrit.copyWith(
      fontSize: size,
      color: color ?? context.colors.accent,
    ),
  );
}

class ContinuityStrip extends StatelessWidget {
  const ContinuityStrip({super.key, required this.secondsPerDay});

  final List<int> secondsPerDay;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final peak = secondsPerDay.fold<int>(0, (m, s) => s > m ? s : m);

    return Row(
      children: [
        for (final seconds in secondsPerDay)
          Expanded(
            child: Container(
              height: 20,
              margin: const EdgeInsets.only(right: 3),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(2),
                color: seconds == 0
                    ? c.surface2
                    : c.accent.withValues(
                        alpha: peak == 0 ? 0.34 : (0.3 + 0.7 * seconds / peak),
                      ),
              ),
            ),
          ),
      ],
    );
  }
}
