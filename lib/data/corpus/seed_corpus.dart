import 'corpus_text.dart';
import 'seed/texts.dart';
import 'seed/translations_en.dart';
import 'seed/translations_es.dart';

abstract final class SeedCorpus {
  static const texts = seedTexts;

  static const translations = <CorpusTranslation>[
    ...seedTranslationsEn,
    ...seedTranslationsEs,
  ];
}
