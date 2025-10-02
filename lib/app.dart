import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'config/app_theme.dart';
import 'models/workout.dart';
import 'models/playlist.dart';
import 'screens/home_screen.dart';
import 'screens/search_screen.dart';
import 'screens/plan_screen.dart';
import 'screens/progress_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/workout_detail_screen.dart';

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> with TickerProviderStateMixin {
  int _currentIndex = 0;
  late AnimationController _navigationController;
  List<Workout> _plan = [];

  // Sample workouts with enhanced data
  final List<Workout> sampleWorkouts = [
    Workout(
      id: 'w1',
      title: 'Morning Yoga Flow',
      durationMinutes: 20,
      category: 'Yoga',
      thumbnailUrl: 'assets/thumbnails/yoga_flow.png',
      videoUrl: 'https://example.com/yoga_flow.mp4',
      difficulty: 2,
      equipmentNeeded: ['Yoga Mat'],
      description:
          'Start your day with this gentle yoga flow that combines stretching and mindfulness to energize your body and calm your mind.',
    ),
    Workout(
      id: 'w2',
      title: 'HIIT Cardio Blast',
      durationMinutes: 15,
      category: 'HIIT',
      thumbnailUrl: 'assets/thumbnails/hiit_cardio.png',
      videoUrl: 'https://example.com/hiit_cardio.mp4',
      difficulty: 4,
      equipmentNeeded: ['None'],
      description:
          'High-intensity interval training that will get your heart pumping and torch calories in just 15 minutes.',
    ),
    Workout(
      id: 'w3',
      title: 'Full Body Strength',
      durationMinutes: 30,
      category: 'Strength',
      thumbnailUrl: 'assets/thumbnails/strength_full.png',
      videoUrl: 'https://example.com/strength_full.mp4',
      difficulty: 3,
      equipmentNeeded: ['Dumbbells', 'Resistance Bands'],
      description:
          'Build lean muscle and increase strength with this comprehensive full-body workout using minimal equipment.',
    ),
    Workout(
      id: 'w4',
      title: 'Cardio Dance Party',
      durationMinutes: 25,
      category: 'Cardio',
      thumbnailUrl: 'assets/thumbnails/cardio_dance.png',
      videoUrl: 'https://example.com/cardio_dance.mp4',
      difficulty: 2,
      equipmentNeeded: ['None'],
      description:
          'Fun, high-energy dance workout that will make you forget you\'re exercising while burning calories.',
    ),
    Workout(
      id: 'w5',
      title: 'Pilates Core Focus',
      durationMinutes: 20,
      category: 'Pilates',
      thumbnailUrl: 'assets/thumbnails/pilates_core.png',
      videoUrl: 'https://example.com/pilates_core.mp4',
      difficulty: 3,
      equipmentNeeded: ['Yoga Mat', 'Pilates Ball'],
      description:
          'Strengthen your core and improve flexibility with this targeted Pilates session focusing on deep abdominal muscles.',
    ),
    Workout(
      id: 'w6',
      title: 'Evening Stretch',
      durationMinutes: 15,
      category: 'Stretching',
      thumbnailUrl: 'assets/thumbnails/evening_stretch.png',
      videoUrl: 'https://example.com/evening_stretch.mp4',
      difficulty: 1,
      equipmentNeeded: ['Yoga Mat'],
      description:
          'Wind down your day with these gentle stretches designed to release tension and prepare your body for rest.',
    ),
    Workout(
      id: 'w7',
      title: 'Upper Body Power',
      durationMinutes: 22,
      category: 'Strength',
      thumbnailUrl: 'assets/thumbnails/upper_power.png',
      videoUrl: 'https://example.com/upper_power.mp4',
      difficulty: 4,
      equipmentNeeded: ['Dumbbells', 'Pull-up Bar'],
      description:
          'Intense upper body workout targeting chest, back, shoulders, and arms for maximum strength gains.',
    ),
    Workout(
      id: 'w8',
      title: 'Beginner HIIT',
      durationMinutes: 12,
      category: 'HIIT',
      thumbnailUrl: 'assets/thumbnails/beginner_hiit.png',
      videoUrl: 'https://example.com/beginner_hiit.mp4',
      difficulty: 2,
      equipmentNeeded: ['None'],
      description:
          'Perfect introduction to high-intensity training with modified exercises suitable for all fitness levels.',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _setupSystemUI();
    _setupAnimations();
    _loadPlan();
  }

  @override
  void dispose() {
    _navigationController.dispose();
    super.dispose();
  }

  void _setupSystemUI() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
    );
  }

  void _setupAnimations() {
    _navigationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _navigationController.forward();
  }

  Future<void> _loadPlan() async {
    final prefs = await SharedPreferences.getInstance();
    final planIds = prefs.getStringList('workout_plan') ?? [];
    setState(() {
      _plan = sampleWorkouts
          .where((workout) => planIds.contains(workout.id))
          .toList();
    });
  }

  Future<void> _savePlan() async {
    final prefs = await SharedPreferences.getInstance();
    final planIds = _plan.map((workout) => workout.id).toList();
    await prefs.setStringList('workout_plan', planIds);
  }

  void _addToPlan(Workout workout) {
    if (!_plan.any((w) => w.id == workout.id)) {
      setState(() {
        _plan.add(workout);
      });
      _savePlan();
    }
  }

  // Update the _removeFromPlan method to accept a String ID:
  void _removeFromPlan(String workoutId) {
    setState(() {
      _plan.removeWhere((w) => w.id == workoutId);
    });
    _savePlan();
  }

  void _addPlaylistToPlan(Playlist playlist) {
    for (final workout in playlist.workouts) {
      _addToPlan(workout);
    }
  }

  void _onTabChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screens = [
      HomeScreen(
        plan: _plan,
        onStartSearch: () => _onTabChanged(1),
        onStartPlan: () => _onTabChanged(2),
      ),
      SearchScreen(
        workouts: sampleWorkouts,
        onAdd: _addToPlan,
        plan: _plan,
        onAddPlaylist: _addPlaylistToPlan,
      ),
      PlanScreen(
        plan: _plan,
        onRemove: _removeFromPlan, // This now matches the expected signature
        onFindWorkout: () => _onTabChanged(1),
      ),
      const ProgressScreen(),
      const ProfileScreen(),
    ];

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: Scaffold(
        backgroundColor: AppTheme.darkBackground,
        body: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          transitionBuilder: (Widget child, Animation<double> animation) {
            return FadeTransition(
              opacity: animation,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0.02, 0),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              ),
            );
          },
          child: SafeArea(
            bottom: true,
            child: IndexedStack(
              key: ValueKey<int>(_currentIndex),
              index: _currentIndex,
              children: screens,
            ),
          ),
        ),
        bottomNavigationBar: _buildBottomNavigationBar(),
      ),
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/workout-detail':
            final args = settings.arguments as Map<String, dynamic>;
            return PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) {
                return WorkoutDetailScreen(
                  workout: args['workout'],
                  onAdd: args['onAdd'],
                  added: args['added'] ?? false,
                );
              },
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                    return SlideTransition(
                      position:
                          Tween<Offset>(
                            begin: const Offset(1.0, 0.0),
                            end: Offset.zero,
                          ).animate(
                            CurvedAnimation(
                              parent: animation,
                              curve: Curves.easeOutCubic,
                            ),
                          ),
                      child: child,
                    );
                  },
            );
          default:
            return null;
        }
      },
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[900],
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 12,
            bottom: MediaQuery.of(context).padding.bottom + 12,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildNavItem(Icons.home_rounded, 'Home', 0),
              _buildNavItem(Icons.search_rounded, 'Search', 1),
              _buildNavItem(Icons.list_rounded, 'Plan', 2),
              _buildNavItem(Icons.bar_chart_rounded, 'Progress', 3),
              _buildNavItem(Icons.person_rounded, 'Profile', 4),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    final isSelected = _currentIndex == index;
    return GestureDetector(
      onTap: () => _onTabChanged(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppTheme.primaryPurple.withOpacity(0.2)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: isSelected ? AppTheme.primaryPurple : Colors.white54,
              size: 24,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? AppTheme.primaryPurple : Colors.white54,
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
