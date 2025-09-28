# Copilot Instructions for home_workout Flutter Project

## Project Overview
- This is a cross-platform Flutter app for home workouts, supporting Android, iOS, web, macOS, Linux, and Windows.
- Main features: user profile, workout plans, daily summaries, suggested workouts, and search/filter functionality.
- Major UI screens: `lib/screens/home_screen.dart`, `lib/screens/profile_screen.dart`, `lib/screens/search_screen.dart`.
- Data models are in `lib/models/` (e.g., `workout.dart`).
- App-wide theme and color constants are in `lib/config/app_theme.dart`.

## Architecture & Patterns
- Follows standard Flutter stateful widget/component structure.
- Animation controllers are used for UI transitions (see `initState`, `_setupAnimations`, and custom animations in screens).
- All navigation is handled via Flutter's Navigator and modal sheets.
- Cards and UI containers use custom `BoxDecoration` (not theme-based) for shadows, rounded corners, and colors.
- Buttons use the theme, but gradients and custom colors are set directly in widgets for visual emphasis.
- Input fields use gray backgrounds for contrast against the black app background.

## Developer Workflow
- **Build/Run:** Use `flutter run` for local development. Supports hot reload.
- **Test:** No custom test runner; use `flutter test` for any Dart/Flutter tests in the `test/` directory.
- **Debug:** Use VS Code or Android Studio Flutter tools for widget inspection and debugging.
- **Assets:** Images and videos are in `assets/` and referenced in models and widgets. Update `pubspec.yaml` if adding new assets.
- **Theme:** Update `lib/config/app_theme.dart` for global color changes. Do not use theme for card decorations; use explicit `BoxDecoration` in widgets.

## Project-Specific Conventions
- All colors, gradients, and shadows for cards and buttons are set directly in widget constructors, not via theme extensions.
- Button color: Default is gray, changes to purple on press (see theme for MaterialStateProperty usage).
- Input boxes: Always use `Colors.grey[800]` for background.
- Text: Always white for readability on black backgrounds.
- Card backgrounds: Use `Colors.grey[900]` or `AppTheme.cardBackground`.
- Do not use `AppTheme.cardDecoration` (define `BoxDecoration` inline).
- Animation controllers are disposed in `dispose()` for every screen.
- Use `MediaQuery.of(context).padding.bottom` for bottom padding to avoid overflow errors.

## Integration Points
- No external API calls; all data is local or hardcoded in models.
- SharedPreferences is used for local user data persistence (see `_loadUserData` in screens).
- No custom build scripts or CI/CD; standard Flutter workflow applies.

## Key Files & Directories
- `lib/screens/`: Main UI screens and navigation logic.
- `lib/models/`: Data models for workouts, playlists, etc.
- `lib/config/app_theme.dart`: Theme and color constants.
- `assets/`: Images, icons, and videos for workouts.
- `pubspec.yaml`: Asset registration and dependencies.

## Example Patterns
- Card decoration:
  ```dart
  decoration: BoxDecoration(
    color: Colors.grey[900],
    borderRadius: BorderRadius.circular(16),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.08),
        blurRadius: 8,
        offset: Offset(0, 2),
      ),
    ],
  )
  ```
- Button theme:
  ```dart
  style: ButtonStyle(
    backgroundColor: MaterialStateProperty.resolveWith<Color>(
      (states) => states.contains(MaterialState.pressed)
        ? Colors.purple
        : Colors.grey[800]!,
    ),
    foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
  )
  ```
- Input field:
  ```dart
  decoration: InputDecoration(
    filled: true,
    fillColor: Colors.grey[800],
    ...
  )
  ```

---

**If any conventions or patterns are unclear, please provide feedback so this guide can be improved for future AI agents.**
