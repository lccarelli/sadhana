import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/providers.dart';
import '../../design_system/tokens.dart';
import '../../design_system/typography.dart';
import '../../design_system/widgets.dart';
import '../../l10n/l10n_x.dart';
import '../settings/settings_screen.dart';
import 'continuity_section.dart';
import 'practice_card.dart';

class TodayScreen extends ConsumerWidget {
  const TodayScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l;
    final c = context.colors;
    final sequence = ref.watch(todaySequenceProvider);

    return Scaffold(
      appBar: AppBar(
        title: MonoLabel(_greeting(context)),
        actions: [
          IconButton(
            icon: const Icon(Icons.tune, size: 20),
            onPressed: () => Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (_) => const SettingsScreen())),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          Space.screen,
          0,
          Space.screen,
          Space.xl,
        ),
        children: [
          Text(
            l.todayTitle,
            style: AppType.practiceTitle.copyWith(color: c.ink),
          ),
          const SizedBox(height: Space.lg),

          PracticeCard(sequence: sequence),

          const SizedBox(height: Space.lg),
          const ContinuitySection(),

          const SizedBox(height: Space.lg),
          Hanging(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MonoLabel(l.todayReading),
                const SizedBox(height: 3),
                Text(
                  l.todayReadingWork,
                  style: AppType.readingBody.copyWith(
                    fontSize: 14,
                    color: c.ink,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _greeting(BuildContext context) {
    final now = TimeOfDay.now();
    return '${now.hour.toString().padLeft(2, '0')}:'
        '${now.minute.toString().padLeft(2, '0')}';
  }
}
