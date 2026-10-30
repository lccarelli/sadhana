import 'package:flutter_test/flutter_test.dart';
import 'package:sadhana/core/domain/anga.dart';
import 'package:sadhana/data/corpus/seed_corpus.dart';
import 'package:sadhana/data/corpus/in_memory_corpus_repository.dart';

void main() {
  const repo = InMemoryCorpusRepository();

  group('corpus', () {
    test('serves a work in the reader language', () async {
      final es = await repo.byWork('ys', 'es');
      expect(es, isNotEmpty);
      expect(es.first.translation.localeCode, 'es');
    });

    test('sanskrit is identical across languages', () async {
      final es = await repo.byId('ys.1.2', 'es');
      final en = await repo.byId('ys.1.2', 'en');

      expect(es!.text.devanagari, en!.text.devanagari);
      expect(es.text.iast, en.text.iast);
      expect(
        es.translation.body,
        isNot(en.translation.body),
        reason: 'only the vernacular line is translated',
      );
    });

    test('falls back rather than showing a blank verse', () async {
      final pt = await repo.byId('ys.1.2', 'pt');
      expect(pt, isNotNull);
      expect(pt!.translation.localeCode, 'en');
    });

    test(
      'is queryable by limb — the taxonomy is real, not decorative',
      () async {
        final asana = await repo.byAnga(Anga.asana, 'es');
        expect(asana.map((t) => t.text.id), contains('ys.2.46'));
      },
    );

    test('every translation carries a translator and a licence', () {
      for (final t in SeedCorpus.translations) {
        expect(
          t.translator,
          isNotEmpty,
          reason: '${t.textId} has no translator',
        );
        expect(t.license, isNotEmpty, reason: '${t.textId} has no licence');
      }
    });

    test('every text is tagged with at least one limb', () {
      for (final t in SeedCorpus.texts) {
        expect(
          t.angas,
          isNotEmpty,
          reason: '${t.id} is untagged and unfindable',
        );
      }
    });
  });
}
