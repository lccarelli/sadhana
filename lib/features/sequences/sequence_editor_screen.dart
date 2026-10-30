import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/providers.dart';
import '../../core/domain/practice_sequence.dart';
import '../../core/domain/practice_step.dart';
import '../../data/sadhana/step_codec.dart';
import '../../design_system/tokens.dart';
import '../../design_system/widgets.dart';
import '../../l10n/l10n_x.dart';
import 'add_step_bar.dart';
import 'sequence_editor_header.dart';
import 'step_editor_sheet.dart';
import 'step_list.dart';

class SequenceEditorScreen extends ConsumerStatefulWidget {
  const SequenceEditorScreen({super.key, this.editing});

  final PracticeSequence? editing;

  @override
  ConsumerState<SequenceEditorScreen> createState() =>
      _SequenceEditorScreenState();
}

class _SequenceEditorScreenState extends ConsumerState<SequenceEditorScreen> {
  late final TextEditingController _title = TextEditingController(
    text: widget.editing?.authoredByUser ?? false ? widget.editing!.title : '',
  );

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
      storageId: source?.storageId,
      title: _title.text.trim().isEmpty ? l.editorUntitled : _title.text.trim(),
      steps: _steps,
      derivedFrom: source != null && !source.authoredByUser ? source.id : null,
    );

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
          SequenceEditorHeader(
            title: _title,
            isCopy: isCopy,
            stepCount: _steps.length,
            total: _total,
          ),

          Expanded(
            child: StepList(
              steps: _steps,
              onReorder: (from, to) => setState(() {
                if (to > from) to -= 1;
                _steps.insert(to, _steps.removeAt(from));
              }),
              onEdit: _editStep,
              onRemove: (i) => setState(() => _steps.removeAt(i)),
            ),
          ),

          AddStepBar(onPick: _addStep),
        ],
      ),
    );
  }
}
