import 'package:flutter/material.dart';

import '../../design_system/tokens.dart';

class JournalScale extends StatelessWidget {
  const JournalScale({super.key, required this.value, required this.onChanged});

  final int? value;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Padding(
      padding: const EdgeInsets.only(top: 9),
      child: Row(
        children: [
          for (var i = 1; i <= 5; i++)
            Expanded(
              child: GestureDetector(
                onTap: () => onChanged(i),
                child: Container(
                  height: 30,
                  margin: const EdgeInsets.only(right: 5),
                  decoration: BoxDecoration(
                    color: value != null && i <= value!
                        ? c.accentSoft
                        : Colors.transparent,
                    border: Border.all(
                      color: value != null && i <= value! ? c.accent : c.rule,
                    ),
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
