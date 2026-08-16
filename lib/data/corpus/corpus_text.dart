import '../../core/domain/anga.dart';

/// A text's identity. Invariant across every language the app ever ships.
///
/// Devanagari and IAST live here, not in the .arb files, because they are not
/// translations — they are what identifies the verse. Losing that distinction
/// is how apps end up unable to add a language without a release.
class CorpusText {
  const CorpusText({
    required this.id,
    required this.workId,
    required this.reference,
    required this.devanagari,
    required this.iast,
    required this.angas,
  });

  /// Stable across languages and releases: 'ys.1.2'.
  final String id;

  /// 'ys' — Yoga Sutras. 'hyp' — Hatha Yoga Pradipika.
  final String workId;

  /// Human citation: 'I.2'.
  final String reference;

  final String devanagari;
  final String iast;
  final Set<Anga> angas;
}

/// One text rendered into one language. Many per [CorpusText].
///
/// [translator] and [license] are mandatory, not decorative: the corpus is the
/// asset being sold, and every line of it has to be defensible.
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

  /// 'es', 'en', 'pt' — matches the .arb locales but is stored, not compiled.
  final String localeCode;

  final String body;
  final String translator;
  final String license;
  final String? commentary;
}

/// A text plus the translation for the reader's language.
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
