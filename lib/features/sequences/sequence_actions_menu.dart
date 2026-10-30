import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/providers.dart';
import '../../core/domain/practice_sequence.dart';
import '../../design_system/tokens.dart';
import '../../l10n/l10n_x.dart';
import 'sequence_editor_screen.dart';

enum SequenceAction { edit, duplicate, delete }

class SequenceActionsMenu extends ConsumerWidget {
  const SequenceActionsMenu({super.key, required this.sequence});

  final PracticeSequence sequence;

  Future<void> _edit(BuildContext context) => Navigator.of(context).push(
    MaterialPageRoute<void>(
      builder: (_) => SequenceEditorScreen(editing: sequence),
    ),
  );

  Future<void> _duplicate(BuildContext context, WidgetRef ref) async {
    final l = context.l;
    final copy = await ref
        .read(sequenceRepositoryProvider)
        .duplicate(
          sequence,
          title: l.sequencesCopySuffix(l.sequenceTitle(sequence)),
        );
    ref.read(selectedSequenceIdProvider.notifier).state = copy.id;
  }

  Future<void> _delete(BuildContext context, WidgetRef ref) async {
    final l = context.l;
    final messenger = ScaffoldMessenger.of(context);
    final repo = ref.read(sequenceRepositoryProvider);

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

    return PopupMenuButton<SequenceAction>(
      icon: Icon(Icons.more_horiz, size: 18, color: c.muted),
      itemBuilder: (context) => [
        PopupMenuItem(value: SequenceAction.edit, child: Text(l.sequencesEdit)),
        PopupMenuItem(
          value: SequenceAction.duplicate,
          child: Text(l.sequencesDuplicate),
        ),
        if (sequence.authoredByUser)
          PopupMenuItem(
            value: SequenceAction.delete,
            child: Text(l.sequencesDelete, style: TextStyle(color: c.ember)),
          ),
      ],
      onSelected: (action) => switch (action) {
        SequenceAction.edit => _edit(context),
        SequenceAction.duplicate => _duplicate(context, ref),
        SequenceAction.delete => _delete(context, ref),
      },
    );
  }
}
