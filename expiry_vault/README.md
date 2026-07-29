# ExpiryVault (pantry_pal)

**Never let your fridge surprise you again.**

ExpiryVault is a Flutter mobile app that gives households one visual home for
tracking expiry dates across food, medicine, and cosmetics — with reminders,
smart sorting, and a friendly, color-blocked "fridge/pantry shelf" UI.

Built for CSC2074 Mobile Application Development (Sunway University).

## Features

- **Item & inventory management** — add/edit/delete items with name, category,
  quantity, unit, expiry/purchase dates, optional photo, and notes.
- **Auto-calculated status** — Fresh / Expiring soon / Expired, based on a
  configurable reminder lead time.
- **Category shelves** — Produce, Dairy & Fridge, Pantry, Medicine, Cosmetics,
  Frozen.
- **Search, filter, and sort** — by name, category, status, expiry date, name,
  or date added.
- **Local notifications** — a reminder fires before an item expires; the
  in-app "Expiring soon" feed is the fallback/summary view.
- **Local persistence** — all data is stored on-device with Hive and survives
  app restarts.

## Tech stack

| Concern | Choice |
|---|---|
| Language/framework | Flutter & Dart |
| State management | Provider |
| Persistence | Hive (`hive`, `hive_flutter`) |
| Notifications | `flutter_local_notifications` + `timezone` |
| Fonts | `google_fonts` (Baloo 2 headings, Nunito body) |

## Project structure

```
lib/
  main.dart              # App entry point: Hive + notification init
  app.dart                # MaterialApp + global Provider setup
  theme/                  # Brand colors, text theme, ThemeData
  models/                 # PantryItem, AppSettings, ItemCategory, ItemStatus
  services/                # HiveService, NotificationService, ItemStatusService
  data/                   # Repositories (CRUD over Hive boxes)
  providers/              # ItemProvider, FilterProvider, SettingsProvider
  utils/                  # ItemQuery (filter/sort), date helpers, constants
  widgets/                # Shared UI components
  screens/                # One folder per screen (splash, home, category, ...)
test/                     # Unit tests for status/query/date logic
```

## Getting started

```bash
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs  # generates Hive adapters
flutter analyze
flutter test
flutter run   # requires an Android emulator/device (or other configured target)
```

> `flutter_local_notifications` requires Android core library desugaring,
> which is already enabled in `android/app/build.gradle.kts`.

## Testing in a browser (Chrome/Edge)

Data is already persisted locally (Hive) on every platform — but **`flutter run -d chrome` will look like data doesn't save**, because that command launches a brand-new, throwaway Chrome profile every time and deletes it when the session ends, wiping the browser storage Hive uses on web along with it. This is normal `flutter run -d chrome` behavior, not a bug in the app.

To test on web with data that actually persists between sessions, serve the app and open it in your **normal** Chrome window instead of letting `flutter run` spawn its own:

```bash
flutter run -d web-server --web-port=8080
```

Then open `http://localhost:8080` in a regular Chrome tab yourself. As long as you don't clear that tab's site data, your items will still be there next time you reload — even after stopping and restarting `flutter run -d web-server`.

For the assignment itself, prefer testing on an **Android emulator/device** (`flutter run`), which is the actual target platform and doesn't have this caveat.

## Regenerating Hive adapters

Whenever a `@HiveType`/`@HiveField` model changes, re-run:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```