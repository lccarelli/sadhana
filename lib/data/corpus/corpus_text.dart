import '../../core/domain/anga.dart';

class CorpusText {
  const CorpusText({
    required this.id,
    required this.workId,
    required this.reference,
    required this.devanagari,
    required this.iast,
    required this.angas,
  });

  final String id;

  final String workId;

  final String reference;

  final String devanagari;
  final String iast;
  final Set<Anga> angas;
}

class CorpusTranslation {
  const CorpusTranslation({
    required this.textId,
    required this.localeCode,
    required this.body,
    required this.translator,
    required this.license,
    this.commentary,
  });

  final String textId;

  final String localeCode;

  final String body;
  final String translator;
  final String license;
  final String? commentary;
}

class LocalizedText {
  const LocalizedText(this.text, this.translation);
  final CorpusText text;
  final CorpusTranslation translation;
}

abstract interface class CorpusRepository {
  Future<List<LocalizedText>> byWork(String workId, String localeCode);
  Future<LocalizedText?> byId(String textId, String localeCode);
  Future<List<LocalizedText>> byAnga(Anga anga, String localeCode);
}
