This repository is a Flutter app that uses Firebase, Provider for state management, and several platform integrations (notifications, Google Sign-In, local storage).

Quick context
- Project root: Flutter app (see `pubspec.yaml`).
- Firebase config: `lib/firebase_options.dart` and native files under `android/app` (contains `google-services.json`) and iOS `Runner` targets.
- State pattern: `provider` with `ChangeNotifier` providers registered in `lib/main.dart` (see `CourseProvider`, `TaskProvider`, `UserProvider`).

How the app boots
- `lib/main.dart` ensures Flutter bindings, calls `Firebase.initializeApp()`, then initializes `NotificationService().init()` before `runApp()`.
- Any global service required at startup should be initialized in `main.dart`.

Key directories and what to touch
- `lib/core/`: app-wide constants and shared utilities.
- `lib/providers/`: `ChangeNotifier` classes. Add new providers here and register them in `lib/main.dart`'s `MultiProvider` list.
- `lib/services/`: thin wrappers over platform services (e.g., `auth_service.dart`, `notification_service.dart`). Keep business logic minimal here; providers orchestrate app state.
- `lib/screens/` and `lib/widgets/`: UI layers. Prefer keeping UI logic in widgets/screens and business logic in providers/services.

Notable patterns and examples
- Authentication: `lib/services/auth_service.dart` exposes Firebase-auth methods (email/password + Google Sign-In). Example use from a provider or widget:

  final auth = AuthService();
  final cred = await auth.signInWithGoogle();

- Providers naming: classes end with `Provider` (e.g., `TaskProvider`). They are `ChangeNotifier` types used with `Provider` package.
- Responsive sizing uses `flutter_screenutil` via `ScreenUtilInit` in `main.dart` — initialize before rendering MaterialApp.

Dependencies and integration points
- See `pubspec.yaml` for the dependency list (Firebase packages, `provider`, `sqflite`, `shared_preferences`, `flutter_local_notifications`, `google_sign_in`).
- Native Firebase integration: do not change `android/app/google-services.json` or iOS plist without updating `lib/firebase_options.dart` or re-running Firebase setup.

Build / Run / Test commands
- Install deps: `flutter pub get`
- Run on device/emulator: `flutter run -d <device>` (Android/iOS)
- Build APK: `flutter build apk --release`
- Run tests: `flutter test`
- Lint: follow `flutter_lints`. Run `dart analyze` or `flutter analyze`.

Developer conventions
- Keep services small and testable: `services/*` should wrap third-party APIs (Firebase, notifications, local storage).
- Providers own app state and call services; UI subscribes to providers via `Consumer` / `Provider.of`.
- Side-effects (navigation, dialogs) belong to UI; providers emit state changes only.
- Use `kDebugMode` guarded logs where present (see `auth_service.dart`).

What to watch for when editing
- Changing provider constructors requires updating `lib/main.dart` registration.
- Changes to Firebase auth/firestore rules or schema must be coordinated with `lib/services` and `lib/providers`.
- Notifications: `NotificationService().init()` runs at app start — modify carefully and test on device.

Files to inspect for examples
- `lib/main.dart` — app init and provider registration.
- `lib/services/auth_service.dart` — Firebase Auth + Google Sign-In example.
- `lib/services/notification_service.dart` — local notifications initialization.
- `pubspec.yaml` — dependency and assets manifest.

If you need to make larger design changes
- Prefer introducing a new `Provider` and service pair rather than mutating large existing providers.
- Add small, focused unit tests under `test/` for providers/services.

When unsure, ask about
- Which platform(s) you will run on (Android, iOS) before touching native config.
- Whether provider state should be persisted (e.g., `shared_preferences` or local DB via `sqflite`).

Please review and tell me which parts need more examples or deeper detail.
