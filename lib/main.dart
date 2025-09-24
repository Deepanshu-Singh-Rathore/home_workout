import 'package:flutter/material.dart';
import 'package:home_workout_app/config/app_theme.dart';
import 'app.dart';

// -------------------- FIREBASE IMPORTS (commented for now) --------------------
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'firebase_options.dart';
// import 'screens/onboarding_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // -------------------- FIREBASE INITIALIZATION (commented for now) --------------------
  /*
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  */

  runApp(const RootApp());
}

class RootApp extends StatelessWidget {
  const RootApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme, // Light theme
      darkTheme: AppTheme.darkTheme, // Dark theme
      themeMode: ThemeMode.system, // Auto switch
      home: const MainApp(), // <-- TEMP: goes directly to MainApp
      // home: const AuthWrapper(), // <-- FIREBASE MODE (uncomment when ready)
    );
  }
}

// -------------------- FIREBASE AUTH WRAPPER (commented for now) --------------------
/*
class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            backgroundColor: AppTheme.kBackgroundColor,
            body: Center(
              child: CircularProgressIndicator(color: AppTheme.kAccentColor),
            ),
          );
        }
        if (snapshot.hasData) {
          return const MainApp();
        }
        return const OnboardingScreen();
      },
    );
  }
}
*/
