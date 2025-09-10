import 'package:flutter/material.dart';
import 'package:home_workout_app/config/app_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app.dart';
import 'screens/onboarding_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MainEntryPoint());
}

class MainEntryPoint extends StatefulWidget {
  const MainEntryPoint({super.key});

  @override
  State<MainEntryPoint> createState() => _MainEntryPointState();
}

class _MainEntryPointState extends State<MainEntryPoint> {
  bool _hasUserData = false;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _checkUserData();
  }

  Future<void> _checkUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final name = prefs.getString('name');
    setState(() {
      _hasUserData = name != null && name.isNotEmpty;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const MaterialApp(
        home: Scaffold(body: Center(child: CircularProgressIndicator())),
      );
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: _hasUserData ? const MyApp() : const OnboardingScreen(),
    );
  }
}
