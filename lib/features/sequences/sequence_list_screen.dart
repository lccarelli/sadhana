import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/providers.dart';
import '../../core/domain/practice_sequence.dart';
import '../../design_system/tokens.dart';
import '../../design_system/typography.dart';
import '../../design_system/widgets.dart';
import '../../l10n/l10n_x.dart';
import 'sequence_editor_screen.dart';

/// Every practice on offer. Shipped ones first, then the practitioner's own.
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
          MaterialPageRoute(builder: (_) => const SequenceEditorScreen()),
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
              96, // clear of the FAB
            ),
            children: [
              MonoLabel(l.sequencesIncluded),
              const SizedBox(height: Space.sm),
              for (final sequence in seeded)
                _SequenceTile(
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
                  _SequenceTile(
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

class _SequenceTile extends ConsumerWidget {
  const _SequenceTile({required this.sequence, required this.isSelected});

  final PracticeSequence sequence;
  final bool isSelected;

  Future<void> _edit(BuildContext context, WidgetRef ref) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => SequenceEditorScreen(editing: sequence),
      ),
    );
  }

  Future<void> _duplicate(BuildContext context, WidgetRef ref) async {
    final l = context.l;
    final copy = await ref.read(sequenceRepositoryProvider).duplicate(
          sequence,
          title: l.sequencesCopySuffix(l.sequenceTitle(sequence)),
        );
    ref.read(selectedSequenceIdProvider.notifier).state = copy.id;
  }

  Future<void> _delete(BuildContext context, WidgetRef ref) async {
    final l = context.l;
    final messenger = ScaffoldMessenger.of(context);
    final repo = ref.read(sequenceRepositoryProvider);

    // Kept in memory so Undo can put it back. Restoring writes a new row, so
    // the practice comes back with a new id — invisible to the practitioner,
    // and the reason the selection is re-pointed below.
    final title = l.sequenceTitle(sequence);
    final steps = [...sequence.steps];

    await repo.delete(sequence);

    messenger.showSnackBar(
      SnackBar(
        content: Text(l.sequencesDeleted(title)),
        action: SnackBarAction(
          label: l.sequencesUndo,
          onPressed: () async {
            final restored = await repo.save(title: title, steps: steps);
            ref.read(selectedSequenceIdProvider.notifier).state = restored.id;
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l;
    final c = context.colors;

    return InkWell(
      onTap: () {
        ref.read(selectedSequenceIdProvider.notifier).state = sequence.id;
        Navigator.of(context).pop();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 13),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: c.rule)),
        ),
        child: Row(
          children: [
            SizedBox(
              width: 26,
              child: isSelected
                  ? Icon(Icons.check, size: 16, color: c.accent)
                  : null,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l.sequenceTitle(sequence),
                    style: AppType.heading.copyWith(
                      fontSize: 17,
                      color: isSelected ? c.accent : c.ink,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    l.editorTotal(
                      sequence.steps.length,
                      sequence.duration.inMinutes,
                    ),
                    style: AppType.uiBody.copyWith(
                      fontSize: 12.5,
                      color: c.muted,
                    ),
                  ),
                  const SizedBox(height: 7),
                  Wrap(
                    spacing: 5,
                    runSpacing: 5,
                    children: [
                      for (final anga in sequence.angas) AngaChip(anga.iast),
                    ],
                  ),
                ],
              ),
            ),
            PopupMenuButton<String>(
              icon: Icon(Icons.more_horiz, size: 18, color: c.muted),
              itemBuilder: (context) => [
                // Editing a shipped practice opens a copy rather than changing
                // it — the editor says so before anything is written.
                PopupMenuItem(value: 'edit', child: Text(l.sequencesEdit)),
                PopupMenuItem(
                  value: 'duplicate',
                  child: Text(l.sequencesDuplicate),
                ),
                if (sequence.authoredByUser)
                  PopupMenuItem(
                    value: 'delete',
                    child: Text(
                      l.sequencesDelete,
                      style: TextStyle(color: c.ember),
                    ),
                  ),
              ],
              onSelected: (value) => switch (value) {
                'edit' => _edit(context, ref),
                'duplicate' => _duplicate(context, ref),
                'delete' => _delete(context, ref),
                _ => null,
              },
            ),
          ],
        ),
      ),
    );
  }
}
