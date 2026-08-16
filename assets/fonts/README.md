# Fonts

Two faces have to be bundled before release. Both are currently falling back
to system fonts, which is fine on iOS and wrong on Android.

## 1. Devanagari — blocking

**Noto Sans Devanagari** (SIL Open Font License 1.1, free to bundle and sell).

    https://fonts.google.com/noto/specimen/Noto+Sans+Devanagari

Download the static `NotoSansDevanagari-Regular.ttf` into this folder, then
uncomment the `fonts:` block in `pubspec.yaml`.

Adds roughly 200 KB. Non-negotiable: Android has no guaranteed Indic face, and
without this the sanskrit renders as empty boxes on a large slice of devices.
Test conjunct ligatures on Android 8 specifically — `स्थिरसुखमासनम्` and
`तीव्रसंवेगानामासन्नः` are good stress cases.

## 2. Display serif — should do

The type system asks for a scholarly serif (Iowan Old Style / Charter). Those
ship with iOS but not Android, so Android currently falls back to Roboto and
loses the entire reading voice.

Free alternatives with the right feel and a licence that permits bundling in a
paid app:

- **Source Serif 4** — OFL, sturdy, excellent at small sizes
- **Crimson Pro** — OFL, warmer, more old-style
- **EB Garamond** — OFL, most classical, lightest on the page

Pick one, drop the regular and italic here as `display-regular.ttf` /
`display-italic.ttf`, and uncomment the second `fonts:` entry. Then delete the
iOS-only names from `Faces.display` in `lib/design_system/typography.dart` so
both platforms render identically.
