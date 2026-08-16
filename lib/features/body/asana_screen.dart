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

/// One posture. Tapping a muscle lights it up on the figure — the reason this
/// is drawn rather than shipped as an image, and the thing that makes it a
/// study aid instead of a picture.
class AsanaScreen extends ConsumerStatefulWidget {
  const AsanaScreen({super.key, required this.asana});

  final Asana asana;

  @override
  ConsumerState<AsanaScreen> createState() => _AsanaScreenState();
}

class _AsanaScreenState extends ConsumerState<AsanaScreen> {
  MuscleGroup? _highlighted;

  /// Tapping the selected muscle again clears it, back to showing the
  /// primaries. Nothing is ever a dead end.
  void _toggle(MuscleGroup group) => setState(
        () => _highlighted = _highlighted == group ? null : group,
      );

  @override
  Widget build(BuildContext context) {
    final l = context.l;
    final c = context.colors;
    final asana = widget.asana;
    final code = ref.watch(
      localeCodeProvider(Localizations.localeOf(context)),
    );
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
              Text(
                asana.iast,
                style: AppType.iast.copyWith(color: c.muted),
              ),
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
            _MuscleSection(
              label: l.bodyStretches,
              muscles: asana.stretches.toList(),
              highlighted: _highlighted,
              onTap: _toggle,
            ),
          if (asana.engages.isNotEmpty)
            _MuscleSection(
              label: l.bodyEngages,
              muscles: asana.engages.toList(),
              highlighted: _highlighted,
              onTap: _toggle,
            ),

          if (translation?.caution case final caution?) ...[
            const SizedBox(height: Space.sm),
            Hanging(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MonoLabel(l.bodyCareful, color: c.ember),
                  const SizedBox(height: 6),
                  Text(
                    caution,
                    style: AppType.readingBody.copyWith(
                      fontSize: 14.5,
                      color: c.ink,
                    ),
                  ),
                ],
              ),
            ),
          ],

          // The subtle layer sits with the anatomy but never inside it: a
          // different label, a different voice, and its disclaimer attached.
          if (translation?.subtle case final subtle?) ...[
            const SizedBox(height: Space.md),
            Hanging(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MonoLabel(l.bodySubtle),
                  const SizedBox(height: 6),
                  Text(
                    subtle,
                    style: AppType.readingBody.copyWith(
                      fontSize: 14.5,
                      fontStyle: FontStyle.italic,
                      color: c.ink2,
                    ),
                  ),
                ],
              ),
            ),
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

class _MuscleSection extends StatelessWidget {
  const _MuscleSection({
    required this.label,
    required this.muscles,
    required this.highlighted,
    required this.onTap,
  });

  final String label;
  final List<AsanaMuscle> muscles;
  final MuscleGroup? highlighted;
  final ValueChanged<MuscleGroup> onTap;

  @override
  Widget build(BuildContext context) {
    final l = context.l;
    final c = context.colors;

    return Padding(
      padding: const EdgeInsets.only(bottom: Space.md),
      child: Hanging(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MonoLabel(label),
            const SizedBox(height: 4),
            for (final muscle in muscles)
              InkWell(
                onTap: () => onTap(muscle.group),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 9),
                  child: Row(
                    children: [
                      // The dot doubles as the legend for the figure: what is
                      // lit there is filled here.
                      Container(
                        width: 7,
                        height: 7,
                        margin: const EdgeInsets.only(right: 10),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: highlighted == muscle.group
                              ? c.accent
                              : muscle.primary
                                  ? c.accent.withValues(alpha: 0.45)
                                  : c.rule,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          l.muscle(muscle.group),
                          style: AppType.uiBody.copyWith(
                            color: highlighted == muscle.group
                                ? c.accent
                                : c.ink,
                          ),
                        ),
                      ),
                      if (muscle.primary)
                        MonoLabel(l.bodyPrimary, color: c.muted),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
