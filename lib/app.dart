import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  late Animation<double> _navigationAnimation;

  final List<Workout> sampleWorkouts = [
    Workout(
      id: '1',
      title: 'Morning Power Workout',
      durationMinutes: 30,
      thumbnailUrl: 'assets/thumbnails/morning_power.png',
      videoUrl: 'https://example.com/morning_power.mp4',
    ),
    Workout(
      id: '2',
      title: 'HIIT Fat Burner',
      durationMinutes: 25,
      thumbnailUrl: 'assets/thumbnails/hiit_burner.png',
      videoUrl: 'https://example.com/hiit_burner.mp4',
    ),
    Workout(
      id: '3',
      title: 'Yoga Flow & Stretch',
      durationMinutes: 20,
      thumbnailUrl: 'assets/thumbnails/yoga_flow.png',
      videoUrl: 'https://example.com/yoga_flow.mp4',
    ),
    Workout(
      id: '4',
      title: 'Full Body Strength',
      durationMinutes: 35,
      thumbnailUrl: 'assets/thumbnails/full_body.png',
      videoUrl: 'https://example.com/full_body.mp4',
    ),
    Workout(
      id: '5',
      title: 'Core Destroyer',
      durationMinutes: 15,
      thumbnailUrl: 'assets/thumbnails/core_destroyer.png',
      videoUrl: 'https://example.com/core_destroyer.mp4',
    ),
    Workout(
      id: '6',
      title: 'Cardio Dance Party',
      durationMinutes: 40,
      thumbnailUrl: 'assets/thumbnails/cardio_dance.png',
      videoUrl: 'https://example.com/cardio_dance.mp4',
    ),
    Workout(
      id: '7',
      title: 'Upper Body Blast',
      durationMinutes: 28,
      thumbnailUrl: 'assets/thumbnails/upper_body.png',
      videoUrl: 'https://example.com/upper_body.mp4',
    ),
    Workout(
      id: '8',
      title: 'Lower Body Burn',
      durationMinutes: 32,
      thumbnailUrl: 'assets/thumbnails/lower_body.png',
      videoUrl: 'https://example.com/lower_body.mp4',
    ),
  ];

  final List<Workout> _plan = [];

  @override
  void initState() {
    super.initState();
    _setupSystemUI();
    _setupAnimations();
  }

  void _setupSystemUI() {
    // Set status bar to dark theme
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: AppTheme.darkCardGrey,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
    );
  }

  void _setupAnimations() {
    _navigationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _navigationAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _navigationController, curve: Curves.easeInOut),
    );

    _navigationController.forward();
  }

  @override
  void dispose() {
    _navigationController.dispose();
    super.dispose();
  }

  void _addToPlan(Workout workout) {
    setState(() {
      if (!_plan.any((p) => p.id == workout.id)) {
        _plan.add(workout);
        _showSnackBar('${workout.title} added to your plan!', Colors.green);
      }
    });
  }

  void _removeFromPlan(String id) {
    setState(() {
      final workout = _plan.firstWhere((w) => w.id == id);
      _plan.removeWhere((w) => w.id == id);
      _showSnackBar('${workout.title} removed from plan', Colors.red);
    });
  }

  void _addPlaylistToPlan(Playlist playlist) {
    int addedCount = 0;
    setState(() {
      for (var workout in playlist.workouts) {
        if (!_plan.any((p) => p.id == workout.id)) {
          _plan.add(workout);
          addedCount++;
        }
      }
    });

    if (addedCount > 0) {
      _showSnackBar(
        '$addedCount workouts from "${playlist.title}" added!',
        Colors.green,
      );
    }
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(color: Colors.white)),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  void _onTabChanged(int index) {
    setState(() => _currentIndex = index);

    // Haptic feedback
    HapticFeedback.lightImpact();

    // Restart animation
    _navigationController.reset();
    _navigationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    final screens = [
      HomeScreen(
        onStartSearch: () => _onTabChanged(1),
        onStartPlan: () => _onTabChanged(2),
      ),
      SearchScreen(
        workouts: sampleWorkouts,
        onAdd: _addToPlan,
        plan: _plan,
        onAddPlaylist: _addPlaylistToPlan,
      ),
      PlanScreen(plan: _plan, onRemove: _removeFromPlan),
      const ProgressScreen(),
      const ProfileScreen(),
    ];

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: Scaffold(
        backgroundColor: AppTheme.backgroundBlack,
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
        color: AppTheme.darkCardGrey,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(77),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Container(
          height: 70,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(0, Icons.home_rounded, Icons.home_outlined, 'Home'),
              _buildNavItem(1, Icons.search_rounded, Icons.search, 'Search'),
              _buildNavItem(
                2,
                Icons.calendar_today_rounded,
                Icons.calendar_today_outlined,
                'Plan',
              ),
              _buildNavItem(
                3,
                Icons.trending_up_rounded,
                Icons.trending_up,
                'Progress',
              ),
              _buildNavItem(
                4,
                Icons.person_rounded,
                Icons.person_outline,
                'Profile',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
    int index,
    IconData activeIcon,
    IconData inactiveIcon,
    String label,
  ) {
    final isSelected = _currentIndex == index;

    return GestureDetector(
      onTap: () => _onTabChanged(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.primaryIndigo.withAlpha(38)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: Icon(
                isSelected ? activeIcon : inactiveIcon,
                key: ValueKey('${index}_$isSelected'),
                color: isSelected ? AppTheme.primaryIndigo : AppTheme.greyText,
              ),
            ),
            const SizedBox(height: 4),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style: TextStyle(
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected ? AppTheme.primaryIndigo : AppTheme.greyText,
              ),
              child: Text(label),
            ),
          ],
        ),
      ),
    );
  }
}
