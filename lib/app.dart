import 'package:flutter/material.dart';
import 'config/app_theme.dart';
import 'models/workout.dart';
import 'screens/home_screen.dart';
import 'screens/search_screen.dart';
import 'screens/plan_screen.dart';

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _currentIndex = 0;

  final List<Workout> sampleWorkouts = [
    Workout(
      id: 'w1',
      title: 'Full Body HIIT',
      durationMinutes: 12,
      thumbnailUrl: '',
      videoUrl:
          'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
    ),
    Workout(
      id: 'w2',
      title: 'Morning Yoga Flow',
      durationMinutes: 18,
      thumbnailUrl: '',
      videoUrl:
          'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
    ),
  ];

  final List<Workout> _plan = [];

  void _addToPlan(Workout w) {
    setState(() {
      if (!_plan.any((p) => p.id == w.id)) _plan.add(w);
    });
  }

  void _removeFromPlan(String id) {
    setState(() {
      _plan.removeWhere((w) => w.id == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final screens = [
      HomeScreen(onStart: () => setState(() => _currentIndex = 1)),
      SearchScreen(workouts: sampleWorkouts, onAdd: _addToPlan, plan: _plan),
      PlanScreen(plan: _plan, onRemove: _removeFromPlan),
    ];

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Home Workout UI',
      theme: AppTheme.darkTheme,
      home: Scaffold(
        body: IndexedStack(index: _currentIndex, children: screens),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (i) => setState(() => _currentIndex = i),
          backgroundColor: AppTheme.kBackgroundColor,
          selectedItemColor: AppTheme.kAccentColor,
          unselectedItemColor: Colors.grey,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today),
              label: 'Plan',
            ),
          ],
        ),
      ),
    );
  }
}
