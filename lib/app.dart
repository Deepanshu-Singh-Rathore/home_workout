// lib/app.dart
import 'package:flutter/material.dart';
import 'config/app_theme.dart';
import 'models/workout.dart';

import 'models/playlist.dart';
import 'screens/search_screen.dart';
import 'screens/plan_screen.dart';
import 'screens/progress_screen.dart';
import 'screens/profile_screen.dart';

// Updated HomeScreen to receive theme props
class HomeScreen extends StatefulWidget {
  final VoidCallback onStartSearch;
  final VoidCallback onStartPlan;
  final bool isDarkMode;
  final ValueChanged<bool> onThemeChanged;

  const HomeScreen({
    super.key,
    required this.onStartSearch,
    required this.onStartPlan,
    required this.isDarkMode,
    required this.onThemeChanged,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _name = "";
  String _goal = "";
  double _bmi = 0;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    // For now using mock data - integrate with SharedPreferences later
    setState(() {
      _name = "User";
      _goal = "Get Fit";
      _bmi = 22.5;
    });
  }

  String _bmiStatus(double bmi) {
    if (bmi == 0) return "N/A";
    if (bmi < 18.5) return "Underweight";
    if (bmi < 24.9) return "Normal";
    if (bmi < 29.9) return "Overweight";
    return "Obese";
  }

  void _openProfileMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.person),
              title: Text("Logged in as $_name"),
            ),
            const Divider(),
            SwitchListTile(
              secondary: Icon(
                widget.isDarkMode ? Icons.dark_mode : Icons.light_mode,
              ),
              title: Text(widget.isDarkMode ? "Dark Mode" : "Light Mode"),
              value: widget.isDarkMode,
              onChanged: widget.onThemeChanged,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Close"),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: ListView(
            children: [
              // Greeting
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      "Welcome back, $_name ",
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => _openProfileMenu(context),
                    child: CircleAvatar(
                      radius: 28,
                      backgroundColor: theme.colorScheme.secondary,
                      child: Icon(
                        Icons.person,
                        color: theme.colorScheme.onSecondary,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Goal + BMI cards
              Row(
                children: [
                  Expanded(
                    child: _dashboardCard(
                      icon: Icons.flag,
                      title: "Goal",
                      value: _goal,
                      gradient: LinearGradient(
                        colors: [
                          theme.colorScheme.primary,
                          theme.colorScheme.secondary,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _dashboardCard(
                      icon: Icons.monitor_weight,
                      title: "BMI",
                      value: "${_bmi.toStringAsFixed(1)}${_bmiStatus(_bmi)}",
                      gradient: LinearGradient(
                        colors: [
                          theme.colorScheme.primary,
                          theme.colorScheme.secondary,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Workout + Plan buttons
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: widget.onStartSearch,
                      icon: const Icon(Icons.search),
                      label: const Text("Find Workouts"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.colorScheme.primary,
                        foregroundColor: theme.colorScheme.onPrimary,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: widget.onStartPlan,
                      icon: const Icon(Icons.fitness_center),
                      label: const Text("My Plan"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.colorScheme.secondary,
                        foregroundColor: theme.colorScheme.onSecondary,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _dashboardCard({
    required IconData icon,
    required String title,
    required String value,
    required Gradient gradient,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 28, color: Colors.white),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(color: Colors.white70, fontSize: 14),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  int _currentIndex = 0;
  ThemeMode _themeMode = ThemeMode.light;

  final List<Workout> sampleWorkouts = [
    Workout(
      id: '1',
      title: 'Morning Strength Training',
      durationMinutes: 30,
      thumbnailUrl: 'assets/thumbnails/pushup.png',
      videoUrl: 'https://example.com/video1.mp4',
    ),
    Workout(
      id: '2',
      title: 'High-Intensity Cardio Blast',
      durationMinutes: 25,
      thumbnailUrl: 'assets/thumbnails/squats.png',
      videoUrl: 'https://example.com/video2.mp4',
    ),
    Workout(
      id: '3',
      title: 'Flexibility & Stretching',
      durationMinutes: 20,
      thumbnailUrl: 'assets/thumbnails/plank.png',
      videoUrl: 'https://example.com/video3.mp4',
    ),
    Workout(
      id: '4',
      title: 'Full Body HIIT',
      durationMinutes: 35,
      thumbnailUrl: 'assets/thumbnails/mountain_climbers.png',
      videoUrl: 'https://example.com/video4.mp4',
    ),
    Workout(
      id: '5',
      title: 'Core Power Workout',
      durationMinutes: 15,
      thumbnailUrl: 'assets/thumbnails/pushup.png',
      videoUrl: 'https://example.com/video5.mp4',
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

  void _addPlaylistToPlan(Playlist playlist) {
    setState(() {
      for (var workout in playlist.workouts) {
        if (!_plan.any((p) => p.id == workout.id)) {
          _plan.add(workout);
        }
      }
    });
  }

  void _toggleTheme(bool isDark) {
    setState(() {
      _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screens = [
      HomeScreen(
        onStartSearch: () => setState(() => _currentIndex = 1),
        onStartPlan: () => setState(() => _currentIndex = 2),
        isDarkMode: _themeMode == ThemeMode.dark,
        onThemeChanged: _toggleTheme,
      ),
      SearchScreen(
        workouts: sampleWorkouts,
        onAdd: _addToPlan,
        plan: _plan,
        onAddPlaylist: _addPlaylistToPlan,
      ),
      PlanScreen(plan: _plan, onRemove: _removeFromPlan),
      const ProgressScreen(),
      ProfileScreen(
        isDarkMode: _themeMode == ThemeMode.dark,
        onThemeChanged: _toggleTheme,
      ),
    ];

    final currentTheme = _themeMode == ThemeMode.dark
        ? AppTheme.darkTheme
        : AppTheme.lightTheme;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: _themeMode,
      home: Theme(
        data: currentTheme,
        child: Scaffold(
          body: IndexedStack(index: _currentIndex, children: screens),
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
              color: currentTheme.bottomNavigationBarTheme.backgroundColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: BottomNavigationBar(
              currentIndex: _currentIndex,
              onTap: (i) => setState(() => _currentIndex = i),
              type: BottomNavigationBarType.fixed,
              backgroundColor: Colors.transparent,
              elevation: 0,
              selectedItemColor: currentTheme.colorScheme.primary,
              unselectedItemColor: currentTheme.iconTheme.color?.withOpacity(
                0.6,
              ),
              selectedLabelStyle: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
              unselectedLabelStyle: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 11,
              ),
              items: [
                BottomNavigationBarItem(
                  icon: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: _currentIndex == 0
                        ? BoxDecoration(
                            color: currentTheme.colorScheme.primary.withOpacity(
                              0.1,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          )
                        : null,
                    child: Icon(
                      _currentIndex == 0 ? Icons.home : Icons.home_outlined,
                      size: 24,
                    ),
                  ),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: _currentIndex == 1
                        ? BoxDecoration(
                            color: currentTheme.colorScheme.primary.withOpacity(
                              0.1,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          )
                        : null,
                    child: Icon(
                      _currentIndex == 1 ? Icons.search : Icons.search_outlined,
                      size: 24,
                    ),
                  ),
                  label: 'Search',
                ),
                BottomNavigationBarItem(
                  icon: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: _currentIndex == 2
                        ? BoxDecoration(
                            color: currentTheme.colorScheme.primary.withOpacity(
                              0.1,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          )
                        : null,
                    child: Icon(
                      _currentIndex == 2
                          ? Icons.calendar_today
                          : Icons.calendar_today_outlined,
                      size: 24,
                    ),
                  ),
                  label: 'Plan',
                ),
                BottomNavigationBarItem(
                  icon: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: _currentIndex == 3
                        ? BoxDecoration(
                            color: currentTheme.colorScheme.primary.withOpacity(
                              0.1,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          )
                        : null,
                    child: Icon(
                      _currentIndex == 3
                          ? Icons.show_chart
                          : Icons.show_chart_outlined,
                      size: 24,
                    ),
                  ),
                  label: 'Progress',
                ),
                BottomNavigationBarItem(
                  icon: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: _currentIndex == 4
                        ? BoxDecoration(
                            color: currentTheme.colorScheme.primary.withOpacity(
                              0.1,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          )
                        : null,
                    child: Icon(
                      _currentIndex == 4 ? Icons.person : Icons.person_outline,
                      size: 24,
                    ),
                  ),
                  label: 'Profile',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
