import '../../core/domain/asana.dart';
import 'asanas/adho_mukha_svanasana.dart';
import 'asanas/balasana.dart';
import 'asanas/tadasana.dart';
import 'asanas/trikonasana.dart';
import 'asanas/virabhadrasana_ii.dart';
import 'asanas/translations_en.dart';
import 'asanas/translations_es.dart';

abstract final class AsanaCatalogue {
  static const asanas = <Asana>[
    tadasana,
    trikonasana,
    virabhadrasanaII,
    adhoMukhaSvanasana,
    balasana,
  ];

  static Asana? byId(String id) => asanas.where((a) => a.id == id).firstOrNull;

  static AsanaTranslation? translation(String asanaId, String localeCode) {
    final exact = _translations.where(
      (t) => t.asanaId == asanaId && t.localeCode == localeCode,
    );
    if (exact.isNotEmpty) return exact.first;

    return _translations
        .where((t) => t.asanaId == asanaId && t.localeCode == 'en')
        .firstOrNull;
  }

  static const _translations = <AsanaTranslation>[
    ...asanaTranslationsEn,
    ...asanaTranslationsEs,
  ];
}
