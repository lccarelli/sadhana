import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/providers.dart';
import '../../design_system/tokens.dart';
import '../../design_system/typography.dart';
import '../../design_system/widgets.dart';
import '../../l10n/l10n_x.dart';
import 'sequence_editor_screen.dart';
import 'sequence_tile.dart';

class SequenceListScreen extends ConsumerWidget {
  const SequenceListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l;
    final c = context.colors;
    final sequences = ref.watch(sequencesProvider);
    final selected = ref.watch(todaySequenceProvider);

    return Scaffold(
      appBar: AppBar(title: MonoLabel(l.sequencesTitle)),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: c.accent,
        foregroundColor: c.onAccent,
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute<void>(builder: (_) => const SequenceEditorScreen()),
        ),
        icon: const Icon(Icons.add, size: 18),
        label: Text(l.sequencesNew),
      ),
      body: sequences.when(
        loading: () => const SizedBox.shrink(),
        error: (e, _) => Center(child: Text('$e')),
        data: (all) {
          final seeded = all.where((s) => !s.authoredByUser).toList();
          final own = all.where((s) => s.authoredByUser).toList();

          return ListView(
            padding: const EdgeInsets.fromLTRB(
              Space.screen,
              0,
              Space.screen,
              96,
            ),
            children: [
              MonoLabel(l.sequencesIncluded),
              const SizedBox(height: Space.sm),
              for (final sequence in seeded)
                SequenceTile(
                  sequence: sequence,
                  isSelected: sequence.id == selected.id,
                ),

              const SizedBox(height: Space.lg),
              MonoLabel(l.sequencesYours, color: c.accent),
              const SizedBox(height: Space.sm),
              if (own.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: Space.md),
                  child: Text(
                    l.sequencesEmpty,
                    style: AppType.uiBody.copyWith(
                      fontSize: 13.5,
                      color: c.muted,
                    ),
                  ),
                )
              else
                for (final sequence in own)
                  SequenceTile(
                    sequence: sequence,
                    isSelected: sequence.id == selected.id,
                  ),
            ],
          );
        },
      ),
    );
  }
}
