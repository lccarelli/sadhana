import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/domain/practice_sequence.dart';
import '../data/corpus/corpus_text.dart';
import '../data/corpus/in_memory_corpus_repository.dart';
import '../data/sadhana/database.dart';
import '../data/sadhana/practice_recorder.dart';
import '../data/sadhana/sequence_repository.dart';
import '../design_system/theme_controller.dart';
import 'locale_controller.dart';

final themeControllerProvider = ChangeNotifierProvider<ThemeController>(
  (ref) => ThemeController(),
);

final localeControllerProvider = ChangeNotifierProvider<LocaleController>(
  (ref) => LocaleController(),
);

final corpusRepositoryProvider = Provider<CorpusRepository>(
  (ref) => const InMemoryCorpusRepository(),
);

final databaseProvider = Provider<SadhanaDatabase>((ref) {
  final db = SadhanaDatabase();

  unawaited(db.closeAbandonedSessions(at: DateTime.now()));

  ref.onDispose(db.close);
  return db;
});

PracticeRecorder createRecorder(WidgetRef ref) =>
    PracticeRecorder(ref.read(databaseProvider));

final sequenceRepositoryProvider = Provider<SequenceRepository>(
  (ref) => SequenceRepository(ref.watch(databaseProvider)),
);

final sequencesProvider = StreamProvider<List<PracticeSequence>>(
  (ref) => ref.watch(sequenceRepositoryProvider).watchAll(),
);

final selectedSequenceIdProvider = StateProvider<String?>((ref) => null);

final todaySequenceProvider = Provider<PracticeSequence>((ref) {
  final all = ref.watch(sequencesProvider).valueOrNull;
  if (all == null || all.isEmpty) return PracticeSequence.slowMorning;

  final chosen = ref.watch(selectedSequenceIdProvider);
  return all.where((s) => s.id == chosen).firstOrNull ?? all.first;
});

final workProvider =
    FutureProvider.family<
      List<LocalizedText>,
      ({String workId, String locale})
    >((ref, key) async {
      final repo = ref.watch(corpusRepositoryProvider);
      return repo.byWork(key.workId, key.locale);
    });

final continuityProvider = StreamProvider<List<int>>((ref) {
  final db = ref.watch(databaseProvider);
  return db.watchContinuity(today: DateTime.now());
});

final historyProvider = StreamProvider<List<PractisedSession>>((ref) {
  final db = ref.watch(databaseProvider);
  return db.watchHistory();
});

final encounterCountsProvider = StreamProvider<Map<String, int>>((ref) {
  final db = ref.watch(databaseProvider);
  return db.watchEncounterCounts();
});

final localeCodeProvider = Provider.family<String, Locale>((ref, deviceLocale) {
  final controller = ref.watch(localeControllerProvider);
  return controller.effectiveCode(deviceLocale);
});
