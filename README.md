# Samyama

**संयम** — *trayam ekatra saṁyamaḥ* (Yoga Sutra III.4): dharana, dhyana and samadhi practised as one thing.

A Flutter app for yoga practice and study: guided sessions, the classical texts with their Sanskrit, an anatomy atlas drawn in code, and a private practice journal. Bilingual (ES/EN) from day one.

Signed *Laura de Trantor*.

## What it does

| Tab | |
|---|---|
| **Today** | Pick a practice and start. Continuity strip of recent days. |
| **Study** | Sutras and texts: Devanagari, IAST, translation. "Practised ×N" counts the texts reached during sessions. |
| **Journal** | Private entries tagged by limb (*anga*). |
| **Body** | Asana catalogue with anatomical figures. Tap a muscle and it lights on the body. |
| **Path** | History, including partial practices, shown as they happened. |

Practitioners can compose their own sequences from breath, posture, focus, reading and silence steps.

## Architecture

```
lib/
  core/domain/     pure Dart, no Flutter imports
  core/usecases/   SessionRunner, the interpreter of practices
  data/corpus/     canonical content: texts, asanas (read-mostly, shippable)
  data/sadhana/    drift/SQLite: sessions, journal, sequences (local-first, private)
  design_system/   tokens, typography, clock-driven theme
  features/        one folder per screen
  l10n/            one .arb per language + domain-to-language mapping
```

Key decisions:

- **Corpus and Sadhana are separate worlds.** Canonical content is shared and re-downloadable; the practitioner's history is private and irreplaceable. They never share a store or a sync policy.
- **A practice is data.** `PracticeSequence` is a list of sealed `PracticeStep`s interpreted by one `SessionRunner`. The runner owns no timer and never reads the clock, so a 24-minute practice is tested in microseconds.
- **Abandoned practices count.** The session row is written at the first breath and checkpointed every 30 s; backgrounding pauses instead of ending; leftovers from a crash are closed on the next launch.
- **The theme follows the clock**, not the OS: light 07:00–20:00, dark otherwise. It never changes mid-practice and is always overridable.
- **Motion follows the breath**: one beat = 900 ms, and every animation is a fraction of it.
- **Two language layers.** UI strings live in `.arb` files; corpus content carries a `locale`. Sanskrit is never translated.
- **Anatomy is drawn, not licensed.** Figures are `CustomPainter` geometry, so they recolour with the theme and react to taps.

Full rationale in [`docs/decisions.md`](docs/decisions.md).

The Dart package is `sadhana` (the domain), not the brand, so the commercial name can change without touching an import.

## Requirements

- Flutter 3.38+ / Dart 3.10+
- Xcode (iOS) or Android SDK

## Commands

```bash
flutter pub get
flutter gen-l10n                                  # after editing any .arb
flutter pub run build_runner build --force-jit    # after editing drift tables
flutter analyze
flutter test
flutter run
```

`--force-jit` is required: `drift_flutter` brings native build hooks that the default AOT build script cannot compile.

Render the asana figures to PNG to inspect them:

```bash
FIGURE_OUT=/tmp/figures flutter test test/render_figures.dart
```

## Tests

| Suite | Covers |
|---|---|
| `test/core` | Breath patterns and the session runner state machine |
| `test/data` | Repositories, recorder checkpoints, step codec, corpus and asana catalogue invariants |
| `test/data/migration_test.dart` | Opens a hand-written v1 database with the current schema |
| `test/design_system` | Clock theme boundaries, hold/release during practice |
| `test/l10n` | Key parity across `.arb` files; no Devanagari in UI strings |

## Before release

- Bundle **Noto Sans Devanagari** and a display serif (see `assets/fonts/README.md`).
- Review corpus translations or replace them with verified public-domain editions.
- Trademark check for *Samyama*; the bundle id `com.trantor.samyama` is permanent once published.

## Status

`0.1.0` — working scaffold: five tabs, two shipped practices, eight texts, five asanas, schema v2.
