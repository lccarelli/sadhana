import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/providers.dart';
import '../../core/domain/asana.dart';
import '../../data/corpus/asana_catalogue.dart';
import '../../design_system/tokens.dart';
import '../../design_system/typography.dart';
import '../../design_system/widgets.dart';
import '../../l10n/l10n_x.dart';
import 'asana_figure_view.dart';
import 'asana_note.dart';
import 'muscle_section.dart';

class AsanaScreen extends ConsumerStatefulWidget {
  const AsanaScreen({super.key, required this.asana});

  final Asana asana;

  @override
  ConsumerState<AsanaScreen> createState() => _AsanaScreenState();
}

class _AsanaScreenState extends ConsumerState<AsanaScreen> {
  MuscleGroup? _highlighted;

  void _toggle(MuscleGroup group) =>
      setState(() => _highlighted = _highlighted == group ? null : group);

  @override
  Widget build(BuildContext context) {
    final l = context.l;
    final c = context.colors;
    final asana = widget.asana;
    final code = ref.watch(localeCodeProvider(Localizations.localeOf(context)));
    final translation = AsanaCatalogue.translation(asana.id, code);

    return Scaffold(
      appBar: AppBar(title: MonoLabel(l.limbNumber(3))),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          Space.screen,
          0,
          Space.screen,
          Space.xl,
        ),
        children: [
          Text(
            translation?.name ?? asana.iast,
            style: AppType.practiceTitle.copyWith(color: c.ink),
          ),
          const SizedBox(height: 4),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Sanskrit(asana.devanagari, size: 18),
              const SizedBox(width: 9),
              Text(asana.iast, style: AppType.iast.copyWith(color: c.muted)),
            ],
          ),

          AsanaFigureView(asana: asana, highlighted: _highlighted),

          Center(
            child: Text(
              l.bodyTapMuscle,
              style: AppType.uiBody.copyWith(fontSize: 12, color: c.muted),
            ),
          ),
          const SizedBox(height: Space.md),

          if (asana.stretches.isNotEmpty)
            MuscleSection(
              label: l.bodyStretches,
              muscles: asana.stretches.toList(),
              highlighted: _highlighted,
              onTap: _toggle,
            ),
          if (asana.engages.isNotEmpty)
            MuscleSection(
              label: l.bodyEngages,
              muscles: asana.engages.toList(),
              highlighted: _highlighted,
              onTap: _toggle,
            ),

          if (translation?.caution case final caution?) ...[
            const SizedBox(height: Space.sm),
            AsanaNote(label: l.bodyCareful, labelColor: c.ember, body: caution),
          ],

          if (translation?.subtle case final subtle?) ...[
            const SizedBox(height: Space.md),
            AsanaNote(label: l.bodySubtle, body: subtle, subtle: true),
          ],

          const SizedBox(height: Space.lg),
          Text(
            l.bodyDisclaimer,
            style: AppType.uiBody.copyWith(fontSize: 12, color: c.muted),
          ),
        ],
      ),
    );
  }
}
