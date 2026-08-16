import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/providers.dart';
import '../../design_system/tokens.dart';
import '../../design_system/typography.dart';
import '../../design_system/widgets.dart';
import '../../l10n/l10n_x.dart';
import '../practice/practice_screen.dart';
import '../sequences/sequence_list_screen.dart';
import '../settings/settings_screen.dart';

class TodayScreen extends ConsumerWidget {
  const TodayScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l;
    final c = context.colors;
    final sequence = ref.watch(todaySequenceProvider);
    final continuity = ref.watch(continuityProvider);

    return Scaffold(
      appBar: AppBar(
        title: MonoLabel(_greeting(context)),
        actions: [
          IconButton(
            icon: const Icon(Icons.tune, size: 20),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const SettingsScreen()),
            ),
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
          Text(l.todayTitle, style: AppType.practiceTitle.copyWith(color: c.ink)),
          const SizedBox(height: Space.lg),

          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: c.surface,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // The whole header swaps the practice. Choosing what to do
                // today is the most common thing to want from this card, so it
                // is one tap and not buried in a menu.
                InkWell(
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const SequenceListScreen(),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(child: MonoLabel(l.todaySavedSequence)),
                      Text(
                        l.sequencesChoose,
                        style: AppType.label.copyWith(color: c.accent),
                      ),
                      Icon(Icons.chevron_right, size: 15, color: c.accent),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  l.sequenceTitle(sequence),
                  style: AppType.heading.copyWith(color: c.ink),
                ),
                const SizedBox(height: 7),
                Text(
                  l.todayStepsAndTime(
                    sequence.steps.length,
                    sequence.duration.inMinutes,
                  ),
                  style: AppType.uiBody.copyWith(fontSize: 12, color: c.muted),
                ),
                const SizedBox(height: 11),
                Wrap(
                  spacing: 5,
                  runSpacing: 5,
                  children: [
                    for (final anga in sequence.angas)
                      AngaChip(anga.iast, active: true),
                  ],
                ),
                const SizedBox(height: Space.md),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => PracticeScreen(sequence: sequence),
                      ),
                    ),
                    child: Text(l.todayStart),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: Space.lg),
          Hanging(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MonoLabel(l.todayContinuity(14)),
                const SizedBox(height: 9),
                ContinuityStrip(
                  secondsPerDay: continuity.maybeWhen(
                    data: (days) => days,
                    orElse: () => List<int>.filled(14, 0),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: Space.lg),
          Hanging(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MonoLabel(l.todayReading),
                const SizedBox(height: 3),
                Text(
                  'Yoga Sutras — Pada I',
                  style: AppType.readingBody.copyWith(fontSize: 14, color: c.ink),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Deliberately not "Good morning" — the app follows the practitioner's
  /// hours, and 5:40 is not morning to everyone.
  String _greeting(BuildContext context) {
    final now = TimeOfDay.now();
    return '${now.hour.toString().padLeft(2, '0')}:'
        '${now.minute.toString().padLeft(2, '0')}';
  }
}
