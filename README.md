# ExpiryVault

A friendly household expiry tracker for food, medicine, and cosmetics, built with Flutter.

## Features

- Track expiry dates for pantry, medicine, and cosmetic items
- Organize items by category with a home dashboard
- See what's expiring soon in a dedicated feed
- Search and filter your items
- Local reminders via notifications
- Optional photo attachment per item
- Local, offline-first storage (Hive)

## Tech Stack

- [Flutter](https://flutter.dev/) / Dart
- [Provider](https://pub.dev/packages/provider) for state management
- [Hive](https://pub.dev/packages/hive) for local persistence
- [flutter_local_notifications](https://pub.dev/packages/flutter_local_notifications) for expiry reminders

## Project Structure

The Flutter app lives in [expiry_vault/](expiry_vault/):

```
expiry_vault/
├── lib/
│   ├── data/        # Repositories (items, settings)
│   ├── models/       # Data models (pantry item, category, status, settings)
│   ├── providers/    # State management
│   ├── screens/      # App screens (onboarding, home, search, settings, etc.)
│   ├── services/     # Hive, notifications, item status logic
│   ├── themes/       # App theming
│   ├── utils/        # Helpers and constants
│   └── widgets/      # Reusable UI components
└── test/             # Tests
```

## Prerequisites

- **Flutter SDK** (stable channel, Dart SDK `^3.11.5` — run `flutter --version` to check). If you don't have it, follow the [official install guide](https://docs.flutter.dev/get-started/install) for your OS.
- **An editor** — [VS Code](https://code.visualstudio.com/) with the Flutter extension, or Android Studio.
- A way to run the app:
  - **Android**: Android Studio + an emulator, or a physical device with USB debugging enabled.
  - **iOS/macOS**: Xcode + a simulator (macOS only).
  - **Windows/Linux desktop**: the matching Flutter desktop support enabled (`flutter config --enable-windows-desktop` / `--enable-linux-desktop`).
  - **Web**: a Chrome install.
- Run `flutter doctor` and resolve anything it flags before continuing.

## Setup

1. Clone the repo and go into the Flutter project (the app lives in the `expiry_vault/` subfolder, not the repo root):
   ```bash
   git clone <this-repo-url>
   cd expiry_vault/expiry_vault
   ```
2. Install dependencies:
   ```bash
   flutter pub get
   ```
3. Generate the Hive adapter code. The models (`PantryItem`, `ItemCategory`, `AppSettings`) use `hive_generator`/`build_runner` for their `.g.dart` files — regenerate them if you change a model, or if they're missing after a fresh clone:
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```
4. Check which devices/platforms are available to you:
   ```bash
   flutter devices
   ```
5. Run the app on a device/emulator/simulator of your choice:
   ```bash
   flutter run
   ```
   Or target a specific platform:
   ```bash
   flutter run -d chrome     # Web
   flutter run -d windows    # Windows desktop
   flutter run -d macos      # macOS desktop
   ```

### Notes on notifications

The app schedules local reminders via `flutter_local_notifications` (see [expiry_vault/lib/services/notification_service.dart](expiry_vault/expiry_vault/lib/services/notification_service.dart)):

- On first run, the app needs the user to grant notification permission (handled at runtime, not at install time on most platforms).
- On Android 13+, this requires the `POST_NOTIFICATIONS` permission; on iOS, an alert/badge/sound permission prompt.
- If reminders don't appear, check that permissions were granted and that the device isn't in a battery-saver mode that defers exact alarms.

## Building a release

```bash
flutter build apk        # Android APK
flutter build appbundle  # Android App Bundle (Play Store)
flutter build ios        # iOS (requires macOS + Xcode)
flutter build windows    # Windows desktop
flutter build web        # Web
```

## Testing

```bash
cd expiry_vault/expiry_vault
flutter test
```

## Troubleshooting

- **`flutter pub get` fails / version mismatch** — make sure your installed Flutter/Dart SDK satisfies `sdk: ^3.11.5` in [pubspec.yaml](expiry_vault/expiry_vault/pubspec.yaml); run `flutter upgrade` if not.
- **Missing `.g.dart` files or Hive adapter errors** — re-run the `build_runner` command from step 3 above.
- **`flutter doctor` shows missing toolchains** — you only need the toolchain for the platform(s) you intend to run on (e.g. skip Xcode setup if you're only testing on Android/web).
