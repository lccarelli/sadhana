import '../../core/domain/anga.dart';
import 'corpus_text.dart';
import 'seed_corpus.dart';

class InMemoryCorpusRepository implements CorpusRepository {
  const InMemoryCorpusRepository();

  @override
  Future<List<LocalizedText>> byWork(String workId, String localeCode) async =>
      SeedCorpus.texts
          .where((t) => t.workId == workId)
          .map((t) => _join(t, localeCode))
          .whereType<LocalizedText>()
          .toList();

  @override
  Future<LocalizedText?> byId(String textId, String localeCode) async {
    final text = SeedCorpus.texts.where((t) => t.id == textId).firstOrNull;
    return text == null ? null : _join(text, localeCode);
  }

  @override
  Future<List<LocalizedText>> byAnga(Anga anga, String localeCode) async =>
      SeedCorpus.texts
          .where((t) => t.angas.contains(anga))
          .map((t) => _join(t, localeCode))
          .whereType<LocalizedText>()
          .toList();

  LocalizedText? _join(CorpusText text, String localeCode) {
    final exact = SeedCorpus.translations
        .where((t) => t.textId == text.id && t.localeCode == localeCode)
        .firstOrNull;
    if (exact != null) return LocalizedText(text, exact);

    final fallback = SeedCorpus.translations
        .where((t) => t.textId == text.id && t.localeCode == 'en')
        .firstOrNull;
    return fallback == null ? null : LocalizedText(text, fallback);
  }
}
