import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/domain/practice_sequence.dart';
import '../data/corpus/corpus_text.dart';
import '../data/corpus/seed_corpus.dart';
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

/// Corpus — read-mostly, shippable, shared. Swap the implementation for a
/// drift-backed one when the seed outgrows a Dart file; nothing above this
/// line has to know.
final corpusRepositoryProvider = Provider<CorpusRepository>(
  (ref) => const InMemoryCorpusRepository(),
);

/// Sadhana — write-heavy, private, local-first. Opposite lifecycle to the
/// corpus, which is why it is a different provider over a different store.
final databaseProvider = Provider<SadhanaDatabase>((ref) {
  final db = SadhanaDatabase();

  // Runs once per launch, which is exactly when it should: a crash or a
  // force-quit leaves a session with no end time, and history must never show
  // a practice that has been running since Tuesday.
  unawaited(db.closeAbandonedSessions(at: DateTime.now()));

  ref.onDispose(db.close);
  return db;
});

/// One recorder per practice. Stateful by design — it holds the open session
/// id — so it is created fresh by the practice screen rather than shared.
PracticeRecorder createRecorder(WidgetRef ref) =>
    PracticeRecorder(ref.read(databaseProvider));

final sequenceRepositoryProvider = Provider<SequenceRepository>(
  (ref) => SequenceRepository(ref.watch(databaseProvider)),
);

/// Everything practisable: the ones we ship plus the ones they composed.
final sequencesProvider = StreamProvider<List<PracticeSequence>>(
  (ref) => ref.watch(sequenceRepositoryProvider).watchAll(),
);

/// What the Today card offers. Null means "we choose" — and we choose the
/// first shipped practice, not the most recent, so a new practitioner opening
/// the app is never staring at a blank card.
final selectedSequenceIdProvider = StateProvider<String?>((ref) => null);

final todaySequenceProvider = Provider<PracticeSequence>((ref) {
  final all = ref.watch(sequencesProvider).valueOrNull;
  if (all == null || all.isEmpty) return PracticeSequence.slowMorning;

  final chosen = ref.watch(selectedSequenceIdProvider);
  // A deleted practice falls back rather than leaving Today empty.
  return all.where((s) => s.id == chosen).firstOrNull ?? all.first;
});

/// A whole work, in the reader's language. The locale is part of the key, so
/// switching language re-queries rather than restarting the app.
final workProvider = FutureProvider.family<List<LocalizedText>,
    ({String workId, String locale})>((ref, key) async {
  final repo = ref.watch(corpusRepositoryProvider);
  return repo.byWork(key.workId, key.locale);
});

/// Practice density for the last two weeks. Feeds the continuity strip.
///
/// A stream, not a future: finishing a practice has to move the strip without
/// anyone remembering to invalidate anything. Drift pushes the new rows.
///
/// Known limitation: `today` is captured when the provider is first built, so
/// an app left open across midnight keeps yesterday's buckets until it is
/// invalidated. Fix when there is a day-change listener to hang it on — the
/// same one a daily practice reminder would need.
final continuityProvider = StreamProvider<List<int>>((ref) {
  final db = ref.watch(databaseProvider);
  return db.watchContinuity(today: DateTime.now());
});

/// Practice history, newest first, each with its journal entry if written.
final historyProvider = StreamProvider<List<PractisedSession>>((ref) {
  final db = ref.watch(databaseProvider);
  return db.watchHistory();
});

/// textId → how many times it was met inside a practice. One query for the
/// whole library rather than one per verse.
final encounterCountsProvider = StreamProvider<Map<String, int>>((ref) {
  final db = ref.watch(databaseProvider);
  return db.watchEncounterCounts();
});

/// The language in effect, as a plain code for querying the corpus.
final localeCodeProvider = Provider.family<String, Locale>((ref, deviceLocale) {
  final controller = ref.watch(localeControllerProvider);
  return controller.effectiveCode(deviceLocale);
});
