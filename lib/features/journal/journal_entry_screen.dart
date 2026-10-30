import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/providers.dart';
import '../../core/domain/anga.dart';
import '../../data/sadhana/database.dart';
import '../../design_system/tokens.dart';
import '../../design_system/typography.dart';
import '../../design_system/widgets.dart';
import '../../l10n/l10n_x.dart';
import 'journal_note_field.dart';
import 'journal_privacy_note.dart';
import 'journal_scale.dart';
import 'saved_with_angas.dart';

class JournalEntryScreen extends ConsumerStatefulWidget {
  const JournalEntryScreen({
    super.key,
    required this.sessionId,
    required this.practised,
    required this.angas,
  });

  final int? sessionId;
  final Duration practised;
  final Set<Anga> angas;

  @override
  ConsumerState<JournalEntryScreen> createState() => _JournalEntryScreenState();
}

class _JournalEntryScreenState extends ConsumerState<JournalEntryScreen> {
  final _note = TextEditingController();
  int? _sthira;
  int? _sukha;
  bool _saving = false;

  @override
  void dispose() {
    _note.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    setState(() => _saving = true);

    await ref
        .read(databaseProvider)
        .addJournalEntry(
          JournalEntriesCompanion.insert(
            createdAt: DateTime.now(),
            sessionId: Value(widget.sessionId),
            sthira: Value(_sthira),
            sukha: Value(_sukha),
            note: Value(_note.text.trim()),
            angas: Value(widget.angas.map((a) => a.name).join(',')),
          ),
        );

    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l;
    final c = context.colors;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          TextButton(
            onPressed: _saving ? null : () => Navigator.of(context).pop(),
            child: Text(l.journalSkip, style: TextStyle(color: c.muted)),
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
          MonoLabel(l.journalJustFinished(widget.practised.inMinutes)),
          const SizedBox(height: 4),
          Text(
            l.journalTitle,
            style: AppType.practiceTitle.copyWith(color: c.ink),
          ),

          const SizedBox(height: Space.md),
          MonoLabel(l.journalSthira),
          JournalScale(
            value: _sthira,
            onChanged: (v) => setState(() => _sthira = v),
          ),

          const SizedBox(height: Space.md),
          MonoLabel(l.journalSukha),
          JournalScale(
            value: _sukha,
            onChanged: (v) => setState(() => _sukha = v),
          ),

          const SizedBox(height: Space.lg),
          JournalNoteField(controller: _note),

          const SizedBox(height: Space.md),
          SavedWithAngas(angas: widget.angas),

          const SizedBox(height: Space.lg),
          FilledButton(
            onPressed: _saving ? null : _save,
            child: Text(l.journalSave),
          ),

          const SizedBox(height: Space.md),
          const JournalPrivacyNote(),
        ],
      ),
    );
  }
}
