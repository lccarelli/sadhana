import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/providers.dart';
import '../../core/domain/practice_sequence.dart';
import '../../core/domain/practice_step.dart';
import '../../data/sadhana/step_codec.dart';
import '../../design_system/tokens.dart';
import '../../design_system/typography.dart';
import '../../design_system/widgets.dart';
import '../../l10n/l10n_x.dart';
import 'step_editor_sheet.dart';

/// Composes a practice.
///
/// This screen is the payoff of modelling a practice as data: everything it
/// produces is a plain list of steps, and the runner already knows how to
/// interpret any list of steps. No new runner code was written to support
/// practices the practitioner invented.
class SequenceEditorScreen extends ConsumerStatefulWidget {
  const SequenceEditorScreen({super.key, this.editing});

  /// Null when composing from scratch.
  final PracticeSequence? editing;

  @override
  ConsumerState<SequenceEditorScreen> createState() =>
      _SequenceEditorScreenState();
}

class _SequenceEditorScreenState extends ConsumerState<SequenceEditorScreen> {
  late final TextEditingController _title = TextEditingController(
    text: widget.editing?.authoredByUser ?? false ? widget.editing!.title : '',
  );

  /// The draft lives as a plain list, not a PracticeSequence: an empty
  /// practice is a legitimate state here and an illegal one in the domain.
  late final List<PracticeStep> _steps = [...?widget.editing?.steps];

  bool _saving = false;

  @override
  void dispose() {
    _title.dispose();
    super.dispose();
  }

  Duration get _total =>
      _steps.fold(Duration.zero, (sum, s) => sum + s.duration);

  Future<void> _addStep(StepKind kind) async {
    final step = await showStepEditor(context, step: StepCodec.blank(kind));
    if (step != null) setState(() => _steps.add(step));
  }

  Future<void> _editStep(int index) async {
    final step = await showStepEditor(context, step: _steps[index]);
    if (step != null) setState(() => _steps[index] = step);
  }

  Future<void> _save() async {
    if (_steps.isEmpty) return;
    setState(() => _saving = true);

    final l = context.l;
    final repo = ref.read(sequenceRepositoryProvider);
    final source = widget.editing;

    final saved = await repo.save(
      // Editing a shipped practice writes a new one; only our own are updated
      // in place. See SequenceRepository.duplicate for why.
      storageId: source?.storageId,
      title: _title.text.trim().isEmpty ? l.editorUntitled : _title.text.trim(),
      steps: _steps,
      derivedFrom: source != null && !source.authoredByUser ? source.id : null,
    );

    // Practise what you just composed, rather than leaving Today on whatever
    // was selected before.
    ref.read(selectedSequenceIdProvider.notifier).state = saved.id;

    if (mounted) Navigator.of(context).pop(saved);
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l;
    final c = context.colors;
    final isCopy = widget.editing != null && !widget.editing!.authoredByUser;

    return Scaffold(
      appBar: AppBar(
        title: MonoLabel(
          widget.editing == null ? l.sequencesNew : l.sequencesEdit,
        ),
        actions: [
          TextButton(
            onPressed: _steps.isEmpty || _saving ? null : _save,
            child: Text(
              l.editorSave,
              style: TextStyle(
                color: _steps.isEmpty ? c.muted : c.accent,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              Space.screen,
              0,
              Space.screen,
              Space.sm,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (isCopy) ...[
                  Text(
                    l.sequencesSeededNotice,
                    style: AppType.uiBody.copyWith(
                      fontSize: 12.5,
                      color: c.ember,
                    ),
                  ),
                  const SizedBox(height: Space.sm),
                ],
                TextField(
                  controller: _title,
                  style: AppType.practiceTitle.copyWith(color: c.ink),
                  decoration: InputDecoration(
                    hintText: l.editorTitleHint,
                    hintStyle: AppType.practiceTitle.copyWith(color: c.muted),
                    border: InputBorder.none,
                    isDense: true,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  l.editorTotal(_steps.length, _total.inMinutes),
                  style: AppType.uiBody.copyWith(fontSize: 12.5, color: c.muted),
                ),
              ],
            ),
          ),

          Expanded(
            child: _steps.isEmpty
                ? Center(
                    child: Text(
                      l.editorNoSteps,
                      style: AppType.uiBody.copyWith(color: c.muted),
                    ),
                  )
                : ReorderableListView.builder(
                    padding: const EdgeInsets.symmetric(
                      horizontal: Space.screen,
                    ),
                    itemCount: _steps.length,
                    onReorder: (from, to) => setState(() {
                      if (to > from) to -= 1;
                      _steps.insert(to, _steps.removeAt(from));
                    }),
                    itemBuilder: (context, i) => _StepTile(
                      key: ValueKey('${_steps[i].hashCode}-$i'),
                      index: i,
                      step: _steps[i],
                      onTap: () => _editStep(i),
                      onRemove: () => setState(() => _steps.removeAt(i)),
                    ),
                  ),
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                Space.screen,
                Space.sm,
                Space.screen,
                Space.sm,
              ),
              child: _AddStepBar(onPick: _addStep),
            ),
          ),
        ],
      ),
    );
  }
}

class _StepTile extends StatelessWidget {
  const _StepTile({
    super.key,
    required this.index,
    required this.step,
    required this.onTap,
    required this.onRemove,
  });

  final int index;
  final PracticeStep step;
  final VoidCallback onTap;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final l = context.l;
    final c = context.colors;

    return Dismissible(
      key: ValueKey('dismiss-$index-${step.hashCode}'),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: Space.md),
        child: Icon(Icons.remove_circle_outline, color: c.ember, size: 20),
      ),
      onDismissed: (_) => onRemove(),
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 13),
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: c.rule)),
          ),
          child: Row(
            children: [
              SizedBox(
                width: 30,
                child: Text(
                  (index + 1).toString().padLeft(2, '0'),
                  style: AppType.numeric.copyWith(
                    fontSize: 11.5,
                    color: c.muted,
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l.stepKindLabel(step),
                      style: AppType.heading.copyWith(fontSize: 16, color: c.ink),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      l.stepSummary(step),
                      style: AppType.uiBody.copyWith(
                        fontSize: 12.5,
                        color: c.ink2,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.drag_handle, size: 18, color: c.rule),
            ],
          ),
        ),
      ),
    );
  }
}

/// Adding a step is one tap to a row of kinds, not a dialog. Composing a
/// practice should feel like laying out cards.
class _AddStepBar extends StatelessWidget {
  const _AddStepBar({required this.onPick});

  final ValueChanged<StepKind> onPick;

  @override
  Widget build(BuildContext context) {
    final l = context.l;
    final c = context.colors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(height: 1, color: c.rule),
        const SizedBox(height: Space.sm),
        MonoLabel(l.editorAddStep),
        const SizedBox(height: 6),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              for (final kind in StepKind.values)
                Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: ActionChip(
                    onPressed: () => onPick(kind),
                    side: BorderSide(color: c.rule),
                    backgroundColor: Colors.transparent,
                    label: Text(
                      l.stepKindLabel(StepCodec.blank(kind)),
                      style: AppType.uiBody.copyWith(
                        fontSize: 13,
                        color: c.ink,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
