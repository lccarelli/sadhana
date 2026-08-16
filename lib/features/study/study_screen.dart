import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/providers.dart';
import '../../data/corpus/corpus_text.dart';
import '../../design_system/tokens.dart';
import '../../design_system/typography.dart';
import '../../design_system/widgets.dart';
import '../../l10n/l10n_x.dart';

/// Corpus reading. Devanagari, transliteration and the vernacular in one
/// column — the first two identical in every language, only the third
/// translated.
class StudyScreen extends ConsumerWidget {
  const StudyScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l;
    final c = context.colors;
    final code = ref.watch(
      localeCodeProvider(Localizations.localeOf(context)),
    );
    final texts = ref.watch(workProvider((workId: 'ys', locale: code)));

    // One query for the whole work, not one per verse. Empty until the first
    // practice touches a text, which is exactly right.
    final encounters =
        ref.watch(encounterCountsProvider).valueOrNull ?? const <String, int>{};

    return Scaffold(
      appBar: AppBar(title: MonoLabel(l.navStudy)),
      body: texts.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('$e')),
        data: (list) => ListView(
          padding: const EdgeInsets.fromLTRB(
            Space.screen,
            0,
            Space.screen,
            Space.xl,
          ),
          children: [
            Text(
              'Yoga Sutras',
              style: AppType.practiceTitle.copyWith(color: c.ink),
            ),
            const SizedBox(height: 8),
            if (list.isNotEmpty)
              Text(
                l.studySource(
                  list.first.translation.translator,
                  list.first.translation.license,
                ),
                style: AppType.uiBody.copyWith(fontSize: 11.5, color: c.muted),
              ),
            const SizedBox(height: Space.md),
            for (final item in list)
              _Sutra(
                item: item,
                practisedCount: encounters[item.text.id] ?? 0,
              ),
          ],
        ),
      ),
    );
  }
}

class _Sutra extends StatelessWidget {
  const _Sutra({required this.item, required this.practisedCount});

  final LocalizedText item;

  /// How many practices actually reached this text. The real bridge between
  /// the two halves of the app — the library knows what happened on the mat.
  final int practisedCount;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;

    return Padding(
      padding: const EdgeInsets.only(bottom: Space.md),
      child: Hanging(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MonoLabel(item.text.reference),
            const SizedBox(height: 6),
            Sanskrit(item.text.devanagari, color: c.ink),
            const SizedBox(height: 5),
            Text(item.text.iast, style: AppType.iast.copyWith(color: c.muted)),
            const SizedBox(height: 9),
            Text(
              item.translation.body,
              style: AppType.readingBody.copyWith(fontSize: 15, color: c.ink),
            ),
            if (item.translation.commentary != null) ...[
              const SizedBox(height: 8),
              Text(
                item.translation.commentary!,
                style: AppType.uiBody.copyWith(fontSize: 12.5, color: c.ink2),
              ),
            ],
            const SizedBox(height: 11),
            Wrap(
              spacing: 5,
              runSpacing: 5,
              children: [
                for (final anga in item.text.angas) AngaChip(anga.iast),
                if (practisedCount > 0)
                  AngaChip(
                    context.l.studyPracticed(practisedCount),
                    active: true,
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
