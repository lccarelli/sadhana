import 'package:flutter/material.dart';

import '../../design_system/tokens.dart';
import '../../design_system/typography.dart';
import '../../design_system/widgets.dart';

class DurationRow extends StatelessWidget {
  const DurationRow({
    super.key,
    required this.label,
    required this.value,
    required this.step,
    required this.min,
    required this.onChanged,
  });

  final String label;
  final Duration value;
  final Duration step;
  final Duration min;
  final ValueChanged<Duration> onChanged;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;

    return Row(
      children: [
        Expanded(child: MonoLabel(label)),
        _Nudge(
          icon: Icons.remove,
          enabled: value - step >= min,
          onTap: () => onChanged(value - step),
        ),
        SizedBox(
          width: 76,
          child: Text(
            '${value.inMinutes}:'
            '${value.inSeconds.remainder(60).toString().padLeft(2, '0')}',
            textAlign: TextAlign.center,
            style: AppType.numeric.copyWith(fontSize: 19, color: c.ink),
          ),
        ),
        _Nudge(icon: Icons.add, onTap: () => onChanged(value + step)),
      ],
    );
  }
}

class Counter extends StatelessWidget {
  const Counter({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    this.min = 0,
    this.max = 60,
  });

  final String label;
  final int value;
  final int min;
  final int max;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;

    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MonoLabel(label),
          const SizedBox(height: 4),
          Row(
            children: [
              _Nudge(
                icon: Icons.remove,
                enabled: value > min,
                onTap: () => onChanged(value - 1),
              ),
              SizedBox(
                width: 38,
                child: Text(
                  '$value',
                  textAlign: TextAlign.center,
                  style: AppType.numeric.copyWith(fontSize: 19, color: c.ink),
                ),
              ),
              _Nudge(
                icon: Icons.add,
                enabled: value < max,
                onTap: () => onChanged(value + 1),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Nudge extends StatelessWidget {
  const _Nudge({required this.icon, required this.onTap, this.enabled = true});

  final IconData icon;
  final VoidCallback onTap;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return IconButton(
      onPressed: enabled ? onTap : null,
      visualDensity: VisualDensity.compact,
      icon: Icon(icon, size: 18, color: enabled ? c.accent : c.rule),
    );
  }
}
