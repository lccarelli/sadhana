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

/// The entry written right after a practice, attached to the session that
/// produced it.
///
/// Two scales rather than stars or emoji, because Yoga Sutra II.46 already
/// named the right two axes: sthira (steady) and sukha (at ease).
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

    await ref.read(databaseProvider).addJournalEntry(
          JournalEntriesCompanion.insert(
            createdAt: DateTime.now(),
            sessionId: Value(widget.sessionId),
            sthira: Value(_sthira),
            sukha: Value(_sukha),
            note: Value(_note.text.trim()),
            // Denormalised so history can be filtered by limb without a join.
            angas: Value(widget.angas.map((a) => a.name).join(',')),
          ),
        );

    // No invalidation needed anywhere: history and the continuity strip are
    // drift streams and update themselves.
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
          _Scale(value: _sthira, onChanged: (v) => setState(() => _sthira = v)),

          const SizedBox(height: Space.md),
          MonoLabel(l.journalSukha),
          _Scale(value: _sukha, onChanged: (v) => setState(() => _sukha = v)),

          const SizedBox(height: Space.lg),
          Hanging(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MonoLabel(l.journalNote),
                const SizedBox(height: 6),
                TextField(
                  controller: _note,
                  maxLines: 5,
                  autofocus: false,
                  style: AppType.readingBody.copyWith(
                    fontSize: 14.5,
                    color: c.ink2,
                  ),
                  decoration: InputDecoration(
                    hintText: l.journalNoteHint,
                    hintStyle: AppType.readingBody.copyWith(
                      fontSize: 14.5,
                      color: c.muted,
                    ),
                    border: InputBorder.none,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: Space.md),
          Hanging(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MonoLabel(l.journalSavedWith),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 5,
                  runSpacing: 5,
                  children: [
                    for (final anga in widget.angas)
                      AngaChip(anga.iast, active: true),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: Space.lg),
          FilledButton(
            onPressed: _saving ? null : _save,
            child: Text(l.journalSave),
          ),

          const SizedBox(height: Space.md),
          Text(
            '⌂ ${l.journalPrivacy}',
            style: AppType.label.copyWith(
              fontSize: 9.5,
              letterSpacing: 0.4,
              color: c.muted,
            ),
          ),
        ],
      ),
    );
  }
}

/// Five boxes, not a slider: a practitioner reports a level, not a fraction.
class _Scale extends StatelessWidget {
  const _Scale({required this.value, required this.onChanged});

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
