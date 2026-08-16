import '../../core/domain/anga.dart';
import 'corpus_text.dart';

/// Seed corpus, in memory. Replaced by a shipped SQLite asset once the corpus
/// is large; the [CorpusRepository] interface is what keeps that swap cheap.
///
/// LICENSING — the real risk in this project, and the reason every row below
/// carries a translator and a licence. The Sanskrit itself is ancient and
/// free. Translations are not: most modern ones are under copyright.
/// The renderings here are our own plain-language versions, which makes them
/// ours to ship. Before launch, either keep them (and have them reviewed by
/// someone who reads Sanskrit) or swap in a verified public-domain edition —
/// Woods 1914 and Vivekananda 1896 for the Sutras, Pancham Sinh 1915 for the
/// Hatha Yoga Pradipika. Do not mix the two without changing the attribution.
abstract final class SeedCorpus {
  static const _ownTranslation = 'Monster of Yoga';
  static const _ownLicense = 'original translation';

  static const texts = <CorpusText>[
    CorpusText(
      id: 'ys.1.1',
      workId: 'ys',
      reference: 'I.1',
      devanagari: 'अथ योगानुशासनम्',
      iast: 'atha yogānuśāsanam',
      angas: {Anga.niyama},
    ),
    CorpusText(
      id: 'ys.1.2',
      workId: 'ys',
      reference: 'I.2',
      devanagari: 'योगश्चित्तवृत्तिनिरोधः',
      iast: 'yogaś citta-vṛtti-nirodhaḥ',
      angas: {Anga.dharana, Anga.dhyana, Anga.samadhi},
    ),
    CorpusText(
      id: 'ys.1.3',
      workId: 'ys',
      reference: 'I.3',
      devanagari: 'तदा द्रष्टुः स्वरूपेऽवस्थानम्',
      iast: "tadā draṣṭuḥ svarūpe 'vasthānam",
      angas: {Anga.samadhi},
    ),
    CorpusText(
      id: 'ys.1.12',
      workId: 'ys',
      reference: 'I.12',
      devanagari: 'अभ्यासवैराग्याभ्यां तन्निरोधः',
      iast: 'abhyāsa-vairāgyābhyāṁ tan-nirodhaḥ',
      angas: {Anga.niyama, Anga.dharana},
    ),
    CorpusText(
      id: 'ys.1.14',
      workId: 'ys',
      reference: 'I.14',
      devanagari: 'स तु दीर्घकालनैरन्तर्यसत्कारासेवितो दृढभूमिः',
      iast: 'sa tu dīrgha-kāla-nairantarya-satkārāsevito dṛḍha-bhūmiḥ',
      angas: {Anga.niyama},
    ),
    CorpusText(
      id: 'ys.1.21',
      workId: 'ys',
      reference: 'I.21',
      devanagari: 'तीव्रसंवेगानामासन्नः',
      iast: 'tīvra-saṁvegānām āsannaḥ',
      angas: {Anga.samadhi},
    ),
    // The app is named after this one.
    CorpusText(
      id: 'ys.3.4',
      workId: 'ys',
      reference: 'III.4',
      devanagari: 'त्रयमेकत्र संयमः',
      iast: 'trayam ekatra saṁyamaḥ',
      angas: {Anga.dharana, Anga.dhyana, Anga.samadhi},
    ),
    CorpusText(
      id: 'ys.2.46',
      workId: 'ys',
      reference: 'II.46',
      devanagari: 'स्थिरसुखमासनम्',
      iast: 'sthira-sukham āsanam',
      angas: {Anga.asana},
    ),
  ];

  static const translations = <CorpusTranslation>[
    // ---- English ----
    CorpusTranslation(
      textId: 'ys.1.1',
      localeCode: 'en',
      body: 'Now, the teaching of yoga.',
      translator: _ownTranslation,
      license: _ownLicense,
    ),
    CorpusTranslation(
      textId: 'ys.1.2',
      localeCode: 'en',
      body: 'Yoga is the stilling of the fluctuations of the mind.',
      translator: _ownTranslation,
      license: _ownLicense,
    ),
    CorpusTranslation(
      textId: 'ys.1.3',
      localeCode: 'en',
      body: 'Then the seer abides in its own nature.',
      translator: _ownTranslation,
      license: _ownLicense,
    ),
    CorpusTranslation(
      textId: 'ys.1.12',
      localeCode: 'en',
      body: 'That stilling comes through practice and through letting go.',
      translator: _ownTranslation,
      license: _ownLicense,
    ),
    CorpusTranslation(
      textId: 'ys.1.14',
      localeCode: 'en',
      body: 'Practice takes root when kept up for a long time, without '
          'interruption, and with devotion.',
      translator: _ownTranslation,
      license: _ownLicense,
      commentary: 'The sutra behind the continuity strip: what matters is not '
          'intensity on one day but the absence of gaps.',
    ),
    CorpusTranslation(
      textId: 'ys.1.21',
      localeCode: 'en',
      body: 'For those of intense ardour, it is near.',
      translator: _ownTranslation,
      license: _ownLicense,
      commentary: 'tīvra saṁvega — the technical term for immoderate zeal in '
          'practice.',
    ),
    CorpusTranslation(
      textId: 'ys.3.4',
      localeCode: 'en',
      body: 'The three together are samyama.',
      translator: _ownTranslation,
      license: _ownLicense,
      commentary: 'Dharana, dhyana and samadhi practised as one thing rather '
          'than three. The app is named after this sutra.',
    ),
    CorpusTranslation(
      textId: 'ys.2.46',
      localeCode: 'en',
      body: 'Posture is steady and at ease.',
      translator: _ownTranslation,
      license: _ownLicense,
      commentary: 'The two journal scales, sthira and sukha, come from here.',
    ),

    // ---- Español ----
    CorpusTranslation(
      textId: 'ys.1.1',
      localeCode: 'es',
      body: 'Ahora, la enseñanza del yoga.',
      translator: _ownTranslation,
      license: _ownLicense,
    ),
    CorpusTranslation(
      textId: 'ys.1.2',
      localeCode: 'es',
      body: 'El yoga es el cese de las fluctuaciones de la mente.',
      translator: _ownTranslation,
      license: _ownLicense,
    ),
    CorpusTranslation(
      textId: 'ys.1.3',
      localeCode: 'es',
      body: 'Entonces el que ve descansa en su propia naturaleza.',
      translator: _ownTranslation,
      license: _ownLicense,
    ),
    CorpusTranslation(
      textId: 'ys.1.12',
      localeCode: 'es',
      body: 'Ese cese llega por la práctica y por el desapego.',
      translator: _ownTranslation,
      license: _ownLicense,
    ),
    CorpusTranslation(
      textId: 'ys.1.14',
      localeCode: 'es',
      body: 'La práctica arraiga cuando se sostiene largo tiempo, sin '
          'interrupción y con devoción.',
      translator: _ownTranslation,
      license: _ownLicense,
      commentary: 'El sutra detrás de la franja de continuidad: no importa la '
          'intensidad de un día sino la ausencia de huecos.',
    ),
    CorpusTranslation(
      textId: 'ys.1.21',
      localeCode: 'es',
      body: 'Para los de vehemencia intensa, está cerca.',
      translator: _ownTranslation,
      license: _ownLicense,
      commentary: 'tīvra saṁvega — el término técnico para el ardor desmedido '
          'en la práctica.',
    ),
    CorpusTranslation(
      textId: 'ys.3.4',
      localeCode: 'es',
      body: 'Los tres juntos son samyama.',
      translator: _ownTranslation,
      license: _ownLicense,
      commentary: 'Dharana, dhyana y samadhi practicados como una sola cosa y '
          'no como tres. La app se llama así por este sutra.',
    ),
    CorpusTranslation(
      textId: 'ys.2.46',
      localeCode: 'es',
      body: 'La postura es firme y cómoda.',
      translator: _ownTranslation,
      license: _ownLicense,
      commentary: 'De acá salen las dos escalas de la bitácora, sthira y sukha.',
    ),
  ];
}

/// In-memory implementation. Swapped for a drift-backed one when the corpus
/// outgrows a Dart file.
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

  /// Falls back to English when a text has not been translated yet — a text
  /// may legitimately exist in one language before another.
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
