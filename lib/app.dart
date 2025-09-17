import 'package:flutter/material.dart';
import 'config/app_theme.dart';
import 'models/workout.dart';
import 'screens/home_screen.dart';
import 'models/playlist.dart';
import 'screens/search_screen.dart';
import 'screens/plan_screen.dart';

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
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
    Workout(
      id: 'w3',
      title: 'Upper Body Strength',
      durationMinutes: 20,
      thumbnailUrl: '',
      videoUrl:
          'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
    ),
    Workout(
      id: 'w4',
      title: 'Lower Body Blast',
      durationMinutes: 25,
      thumbnailUrl: '',
      videoUrl:
          'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
    ),
    Workout(
      id: 'w5',
      title: 'Core Stability',
      durationMinutes: 15,
      thumbnailUrl: '',
      videoUrl:
          'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
    ),
    Workout(
      id: 'w6',
      title: 'Full Body Stretch',
      durationMinutes: 10,
      thumbnailUrl: '',
      videoUrl:
          'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
    ),
    Workout(
      id: 'w7',
      title: 'Cardio Burn',
      durationMinutes: 22,
      thumbnailUrl: '',
      videoUrl:
          'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
    ),
    Workout(
      id: 'w8',
      title: 'Balance and Mobility',
      durationMinutes: 18,
      thumbnailUrl: '',
      videoUrl:
          'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
    ),
    Workout(
      id: 'w9',
      title: 'Bodyweight Strength',
      durationMinutes: 20,
      thumbnailUrl: '',
      videoUrl:
          'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
    ),
    Workout(
      id: 'w10',
      title: 'Relaxing Yoga',
      durationMinutes: 30,
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

  void _goToSearch() {
    setState(() {
      _currentIndex = 1;
    });
  }

  void _goToPlan() {
    setState(() {
      _currentIndex = 2;
    });
  }

  void _addPlaylistToPlan(Playlist playlist) {
    setState(() {
      for (var workout in playlist.workouts) {
        if (!_plan.any((p) => p.id == workout.id)) {
          _plan.add(workout);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final screens = [
      HomeScreen(onStartSearch: _goToSearch, onStartPlan: _goToPlan),
      SearchScreen(
        workouts: sampleWorkouts,
        onAdd: _addToPlan,
        plan: _plan,
        onAddPlaylist: _addPlaylistToPlan,
      ),
      PlanScreen(plan: _plan, onRemove: _removeFromPlan),
    ];

    return Scaffold(
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
    );
  }
}

