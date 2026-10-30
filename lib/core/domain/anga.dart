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

  final int position;

  final String devanagari;

  final String iast;

  String get key => name;

  bool get isInner => position >= 6;
  bool get isOuter => !isInner;

  static Anga fromPosition(int position) =>
      Anga.values.firstWhere((a) => a.position == position);
}
