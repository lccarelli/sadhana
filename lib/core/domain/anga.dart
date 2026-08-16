/// The eight limbs. Not a section of the app — the taxonomy every entity
/// hangs from: a text, an asana, a session, a journal entry.
///
/// Devanagari and IAST are invariant across languages: they identify the
/// concept, they are not a translation. Only the vernacular gloss is
/// localized, and it lives in the .arb files under the [key] below.
enum Anga {
  yama(1, 'यम', 'yama'),
  niyama(2, 'नियम', 'niyama'),
  asana(3, 'आसन', 'āsana'),
  pranayama(4, 'प्राणायाम', 'prāṇāyāma'),
  pratyahara(5, 'प्रत्याहार', 'pratyāhāra'),
  dharana(6, 'धारणा', 'dhāraṇā'),
  dhyana(7, 'ध्यान', 'dhyāna'),
  samadhi(8, 'समाधि', 'samādhi');

  const Anga(this.position, this.devanagari, this.iast);

  /// 1..8 — Patanjali's order. The progression is real, so it is numbered.
  final int position;

  /// Never translated.
  final String devanagari;

  /// Never translated.
  final String iast;

  /// Lookup key for the localized gloss (see app_*.arb).
  String get key => name;

  /// Patanjali splits the eight: the first five are outer limbs, the last
  /// three inner. The app's whole arc is the move from bahiranga to
  /// antaranga, so the distinction is modelled, not just described.
  bool get isInner => position >= 6;
  bool get isOuter => !isInner;

  static Anga fromPosition(int position) =>
      Anga.values.firstWhere((a) => a.position == position);
}
