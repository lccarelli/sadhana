# Decisions

**Samyama** (संयम), signed *Laura de Trantor*. Yoga Sutra III.4 —
*trayam ekatra saṁyamaḥ*, "the three together are samyama": dharana, dhyana and
samadhi practised as one thing rather than three. The name is the thesis.

The Dart package is `sadhana` — named after the domain, not the brand, so the
commercial name can change without touching a single import. Store identity is
`com.trantor.samyama`; the launcher name is `Samyama` (7 characters, so it
survives iOS truncation).

## Commands

```bash
flutter pub get
flutter gen-l10n                                    # after editing any .arb
flutter pub run build_runner build --force-jit      # after editing drift tables
flutter analyze
flutter test
flutter run
```

**`--force-jit` is not optional.** `drift_flutter` pulls in native build hooks,
and build_runner's default AOT compilation of the build script cannot handle
them — it fails with an unhelpful *"Failed to compile build script"*. JIT mode
works and costs a few extra seconds. Do not spend an afternoon on this twice.

## The two decisions everything else follows from

### 1. Corpus and Sadhana are different worlds

| | **Corpus** (`lib/data/corpus/`) | **Sadhana** (`lib/data/sadhana/`) |
|---|---|---|
| Origin | Curated by us | Written by the practitioner |
| Writes | Rare, versioned | Constant, intimate |
| Sync | Pull, cacheable, shared | Local-first, private, never leaves without consent |
| If lost | Re-download | **Irreparable** |

A three-year practice journal is as private as a diary. These never share a
store, a repository, or a sync policy. This split is also what lets the corpus
be sold without ever touching user data.

### 2. A practice is data, not screens

`PracticeSequence` is a list of `PracticeStep`s; `SessionRunner` interprets
them. One runner serves pranayama, vinyasa, meditation and yoga nidra — and
practitioners compose their own sequences without a line of new runner code.
That claim is load-bearing and tested: see "the runner cannot tell them apart"
in `test/data/sequence_repository_test.dart`.

`PracticeStep` is **sealed**: adding a step kind breaks every `switch` at
compile time instead of silently rendering nothing.

## Layers

```
lib/
  core/domain/       pure Dart, ZERO Flutter imports — enforce this
  core/usecases/     SessionRunner: the interpreter
  data/corpus/       canonical content, read-mostly, shippable
  data/sadhana/      drift/SQLite — this device is the source of truth
  design_system/     tokens, theme, the clock controller
  features/          one folder per screen
  l10n/              *.arb + the domain→language edge (l10n_x.dart)
```

`core/domain` importing Flutter is the one rule worth being rigid about, and
`test/architecture/layers_test.dart` enforces it together with the other
layer boundaries. It is
what lets a 24-minute practice be tested in microseconds with no emulator:
`SessionRunner` owns no `Timer` and never reads the clock — time is pushed in
from outside via `advance()`.

## Persistence assumes practices are abandoned

**Most practices never get a clean finish.** Someone starts, does eight
minutes, and the phone locks. So `PracticeRecorder` writes the session row at
the *first breath* and checkpoints every 30 s while it runs, rather than
composing a record at the end. A record that only existed on completion would
under-report real practice badly, and the entire read side is built on
history as it happened.

Four rules follow from that:

- **`practisedSeconds` is practised time, not wall clock.** It comes from the
  runner's `elapsedTotal`, which does not advance while paused. Wall clock
  would reward leaving the app open.
- **Backgrounding pauses, it does not end.** Being interrupted is not giving
  up. The session stays open and a *forced* checkpoint fires, so if the OS
  kills us the seconds are already on disk.
- **`closeAbandonedSessions` runs once per launch.** It finalises anything a
  crash left open, using whatever the last checkpoint wrote. History must
  never show a practice that has been running since Tuesday.
- **`end()` is idempotent.** Completion, backgrounding and dispose all call
  it; the first close wins and later calls must not rewrite history.

Abandoned practices are *shown* in history, never hidden — an app that only
counts clean finishes teaches people not to start. They read as
"62% of the practice" in neutral colour, not as a failure state.

Reads are drift **streams** (`watchContinuity`, `watchHistory`,
`watchEncounterCounts`), so finishing a practice moves the continuity strip
with nobody remembering to invalidate a provider.

`TextEncounters` is the one real bridge between the app's two halves: a
`ReadingStep` reached during practice is recorded once per session, and that
is what the library's "Practiced ×3" chip counts.

## Composed practices are the payoff

Practitioners compose their own sequences, and **no runner code was written to
support that** — the runner already interpreted any list of steps. Nothing
downstream of `SequenceRepository` branches on where a sequence came from.

- **Shipped practices live in code** (`PracticeSequence.seeds`), not seeded
  into the database, so they can be improved in a release without migrating
  anyone's rows.
- **Editing a shipped practice makes a copy.** A practice someone has done for
  a year must not change under them because we improved ours. The editor says
  so before anything is written.
- **Steps are stored in a sparse table**, one nullable column group per kind,
  rather than a JSON blob. "Every practice containing trikonasana" is a
  question this app will want to answer in SQL. The sparseness is confined to
  `StepCodec`; nothing else touches those columns.
- **`StepCodec.encode` switches on the sealed type**, so adding a step kind
  breaks compilation — exactly when you want to be told it cannot be saved yet.
  `decode` **throws** on an unknown kind rather than skipping the step: a
  database from a newer version would otherwise hand back a practice with a
  hole in it, and someone would sit in a silence that was meant to be a
  reading.
- **Saving rewrites all steps in a transaction** instead of diffing them.
  Reordering renumbers most of them anyway, and a half-applied edit leaves a
  practice with two step threes.

`StepKind`'s names are on disk. Renaming one owes a migration.

## Anatomy is drawn, not licensed

`AsanaCatalogue` is corpus — same rules as the texts: devanagari and IAST are
invariant, only the name and guidance are translated. Figures are our own
geometry, which is not a stylistic preference: atlas illustrations are the most
expensive thing to license in an app like this and the reason most of them ship
no anatomy at all.

A `CustomPainter` rather than an asset, for two reasons an image cannot cover:
the figure recolours with the clock-driven theme, and tapping a muscle lights
it up on the body. That second one is the whole feature — it is what makes the
screen a study aid instead of a picture.

**Render the figures and look at them.**

    FIGURE_OUT=/tmp/figures flutter test test/render_figures.dart

That harness is not part of the suite (it does not end in `_test.dart`).
Coordinates authored blind pass every assertion in `asana_catalogue_test.dart`
and still draw nonsense — the first pass produced a triangle pose that read as
a tent and a child's pose that was a flat zigzag.

Geometry conventions for adding a posture:

- The design box is 200 × 150, y downward. Figures use most of it; a pose
  crammed into the bottom third renders as a smudge.
- Every figure carries a short neck stroke, or the head reads as a bead
  floating above the shoulders.
- Muscle marks sit on the midpoint of their limb, rotated to its direction.
  A mark floating off the body teaches the wrong location.
- Rotation is radians, clockwise. For a limb vector (dx, dy):
  `rotation = atan2(-dx, dy)`.
- `Point` is not `Offset` on purpose: `Offset` lives in `dart:ui`, and
  `core/domain` imports no Flutter.
- `Muscle` is a closed enum, so "every practice that stretches the psoas"
  stays answerable. Subtle-layer notes (e.g. *samana*) are kept apart from
  the anatomy and always carry their disclaimer.

Two symmetry rules are enforced by tests, in both directions: every muscle a
posture lists must have a mark to light, and every mark must belong to a
listed muscle. Otherwise you get dead taps or silent decoration.

## Migrations are tested against a real v1 database

`test/data/migration_test.dart` builds a v1 database from **hardcoded** DDL,
fills it with practice history, and opens it with the current code. The schema
is hardcoded on purpose: derived from the live table definitions it would
follow them forward and prove nothing.

Every schema bump gets a case here. The journal is the one thing in this app
that cannot be recreated.

## The eight limbs are the taxonomy

Not a section. Every entity — text, asana, session, journal entry — is tagged
by `Anga`. The ladder is drawn with opacity on **one** accent, never eight
hues: it is a progression, not eight categories.

## Theme follows the clock, not the OS

Light 07:00–20:00, dark otherwise (`ClockThemeResolver`). Three rules make it
bearable rather than annoying:

1. **Never changes mid-practice** — `ThemeController.hold()` / `.release()`.
   A flash from white to black during savasana is unforgivable.
2. Cross-fades over one beat (900 ms) via `AppColors.lerp`.
3. Always overridable in Settings. That is accessibility, not preference.

Boundary hours are fields, not constants, so tying them to real sunrise by
geolocation later changes only where two numbers come from.

## Motion comes from the breath

One beat = 900 ms, a quarter of a calm four-count inhale. Every duration in
`Beat` is a fraction of it. An app about the breath should not animate at
300 ms because 300 is a round number.

## Language: two layers, never confuse them

- **UI strings** → one `.arb` per language, `flutter gen-l10n`. Adding a
  language is adding one file. A missing key fails the build.
- **Corpus content** → a `locale` column in the database. Sutras are *content*,
  not interface: putting them in `.arb` means shipping an app release to add a
  translation.
- **Sanskrit is never translated.** Devanagari and IAST identify a verse; only
  the vernacular line below changes. `test/l10n/arb_parity_test.dart` fails if
  devanagari ever appears in an `.arb`.

English runs 15–20% shorter than Spanish. Never let a layout depend on a title
breaking into exactly two lines — test in the long language.

## Interaction rules

- **The practice screen is not a tab.** It is pushed full-screen with no
  navigation bar, no small controls and large type: it is read sideways from
  a mat. Tap anywhere pauses, swipe moves between steps, the system UI is
  hidden and the screen stays on (`PracticeFocusMode`).
- **Leaving a practice needs no confirmation.** Someone reaching for the exit
  is usually being interrupted, and nothing is lost: the session closes as
  partial.
- **Finishing goes straight to the journal**, replacing the route so Back does
  not land in a finished practice.
- **Haptics follow the breath phase**, so a practice can be followed with the
  eyes closed. The animation is never load-bearing.
- **Steppers, not sliders or text fields** in the step editor: a four-count
  inhale is 4, not 4.3, and nobody opens a keyboard on a mat. Postures are
  picked from the catalogue, never typed.
- **Journal scales are sthira and sukha, 1–5** (Yoga Sutra II.46), as five
  boxes. Not stars, not emoji.
- **Continuity is density, not a streak.** A light day fades; it does not
  break anything (Yoga Sutra I.14).
- **Each language names itself** in the picker, and the Today greeting is not
  "Good morning": 5:40 is not morning to everyone.
- **Ember is semantic only**: exhalation and destructive actions.

## Known limitations

- `continuityProvider` captures `today` when first built, so an app left open
  across midnight keeps yesterday's buckets. Fix it with a day-change
  listener, the same one a daily reminder would need.
- `SessionRunner.advance` handles a delta spanning several steps. Whether
  fast-forwarding through a long absence is desirable is an app-layer policy
  (clamp the delta or pause on resume).

## Open before launch

- **Fonts** — Devanagari must be bundled; Android has no guaranteed Indic
  face. See `assets/fonts/README.md`. Blocking.
- **Corpus licensing** — the real risk in this project, and bigger than any
  code problem. Seeded translations are our own plain-language renderings
  (so ours to ship) and should be reviewed by someone who reads Sanskrit, or
  swapped for a verified public-domain edition: Woods 1914 or Vivekananda 1896
  for the Sutras, Pancham Sinh 1915 for the Hatha Yoga Pradipika. Do not mix
  the two without changing the attribution. `translator` and `license` are
  mandatory fields on every translation for this reason.
- **Trademark check** — `Samyama` was chosen partly because it is rare enough
  to register. Verify that before the first release; the bundle id
  `com.trantor.samyama` cannot be changed once the app is published.
