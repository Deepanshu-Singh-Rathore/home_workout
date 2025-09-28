//lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../config/app_theme.dart';
import '../models/workout.dart';
import 'dart:math' as math;

class HomeScreen extends StatefulWidget {
  final VoidCallback onStartSearch;
  final VoidCallback onStartPlan;

  const HomeScreen({
    super.key,
    required this.onStartSearch,
    required this.onStartPlan,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  String _name = "";
  String _goal = "";
  double _bmi = 0;
  String? _profileImagePath;

  // Animation Controllers
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late AnimationController _scaleController;
  late AnimationController _floatController;

  // Animations
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _floatAnimation;

  // Sample suggested workouts
  final List<Workout> _suggestedWorkouts = [
    Workout(
      id: 'quick1',
      title: 'Morning Energy Boost',
      durationMinutes: 15,
      thumbnailUrl: 'assets/thumbnails/morning.png',
      videoUrl: 'https://example.com/morning.mp4',
    ),
    Workout(
      id: 'quick2',
      title: 'Quick Cardio Burn',
      durationMinutes: 10,
      thumbnailUrl: 'assets/thumbnails/cardio.png',
      videoUrl: 'https://example.com/cardio.mp4',
    ),
    Workout(
      id: 'quick3',
      title: 'Power Stretch',
      durationMinutes: 12,
      thumbnailUrl: 'assets/thumbnails/stretch.png',
      videoUrl: 'https://example.com/stretch.mp4',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _loadUserData();
    _startAnimations();
  }

  void _setupAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 1800),
      vsync: this,
    );

    _floatController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeOut));

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0.0, 0.5), end: Offset.zero).animate(
          CurvedAnimation(parent: _slideController, curve: Curves.elasticOut),
        );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.elasticOut),
    );

    _floatAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _floatController, curve: Curves.easeInOut),
    );
  }

  void _startAnimations() {
    _fadeController.forward();

    Future.delayed(const Duration(milliseconds: 300), () {
      _slideController.forward();
    });

    Future.delayed(const Duration(milliseconds: 600), () {
      _scaleController.forward();
    });

    _floatController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _scaleController.dispose();
    _floatController.dispose();
    super.dispose();
  }

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _name = prefs.getString("name") ?? "Fitness Warrior";
      _goal = prefs.getString("goal") ?? "Transform Your Body";
      _bmi = prefs.getDouble("bmi") ?? 22.5;
      _profileImagePath = prefs.getString("profile_image");
    });
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return "Good Morning";
    } else if (hour < 17) {
      return "Good Afternoon";
    } else {
      return "Good Evening";
    }
  }

  String _bmiStatus(double bmi) {
    if (bmi == 0) return "Calculate BMI";
    if (bmi < 18.5) return "Underweight";
    if (bmi < 24.9) return "Healthy Weight";
    if (bmi < 29.9) return "Overweight";
    return "Obese";
  }

  Color _getBmiColor(double bmi) {
    if (bmi == 0) return AppTheme.greyText;
    if (bmi < 18.5) return AppTheme.primaryIndigo;
    if (bmi < 24.9) return Colors.green;
    if (bmi < 29.9)
      return Colors
          .orange; // Changed from AppTheme.successGreen to Colors.orange
    return Colors.red;
  }

  void _openProfileMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => SafeArea(
        child: SingleChildScrollView(
          child: Container(
            decoration: const BoxDecoration(
              color: AppTheme.darkCardGrey,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(24),
              ),
            ),
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Handle bar
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppTheme.greyText.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 24),

                // Profile info
                Row(
                  children: [
                    _buildProfileAvatar(60),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _name,
                            style: const TextStyle(
                              color: AppTheme.whiteText,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            _goal,
                            style: const TextStyle(
                              color: AppTheme.greyText,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: _editProfile,
                      icon: const Icon(
                        Icons.edit_rounded,
                        color: AppTheme.primaryIndigo,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 32),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Close"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _editProfile() {
    // Profile editing functionality - you can expand this
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Profile editing coming soon!'),
        backgroundColor: AppTheme.primaryIndigo,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A), // Dark indigo background
      body: SafeArea(
        bottom: true,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Animated Greeting Section
              FadeTransition(
                opacity: _fadeAnimation,
                child: _buildGreetingSection(),
              ),

              const SizedBox(height: 24),

              // Daily Summary Card
              SlideTransition(
                position: _slideAnimation,
                child: _buildDailySummaryCard(),
              ),

              const SizedBox(height: 24),

              // Goal & BMI Cards
              ScaleTransition(
                scale: _scaleAnimation,
                child: _buildStatsCards(),
              ),

              const SizedBox(height: 24),

              // Action Buttons
              SlideTransition(
                position: _slideAnimation,
                child: _buildActionButtons(),
              ),

              const SizedBox(height: 32),

              // Suggested Workouts
              FadeTransition(
                opacity: _fadeAnimation,
                child: _buildSuggestedWorkouts(),
              ),

              SizedBox(height: MediaQuery.of(context).padding.bottom + 80),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGreetingSection() {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _getGreeting(),
                style: const TextStyle(
                  color: AppTheme.greyText, // #A5B4FC
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              AnimatedBuilder(
                animation: _floatAnimation,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(
                      0,
                      math.sin(_floatAnimation.value * 2 * math.pi) * 3,
                    ), // Fixed: Removed const from here
                    child: ShaderMask(
                      shaderCallback: (bounds) => LinearGradient(
                        colors: [
                          AppTheme.primaryIndigo,
                          AppTheme.primaryIndigo,
                        ],
                      ).createShader(bounds),
                      child: Text(
                        _name,
                        style: TextStyle(
                          // Fixed: Removed const from here
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: () => _openProfileMenu(context),
          child: AnimatedBuilder(
            animation: _scaleAnimation, // Fixed: Removed const from here
            builder: (context, child) {
              // Fixed: Removed const from here
              return Transform.scale(
                scale: 0.8 + (_scaleAnimation.value * 0.2),
                child: _buildProfileAvatar(50),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildProfileAvatar(double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          size / 2,
        ), // Fixed: Removed const from here
        gradient: const LinearGradient(
          colors: [AppTheme.primaryIndigo, AppTheme.primaryIndigo],
        ),
        boxShadow: [
          BoxShadow(
            // Fixed: Removed const from here
            color: AppTheme.primaryIndigo.withOpacity(0.4),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: _profileImagePath != null
          ? ClipRRect(
              borderRadius: BorderRadius.circular(
                size / 2,
              ), // Fixed: Removed const from here
              child: Image.asset(
                // Fixed: Removed const from here
                _profileImagePath!,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return _buildDefaultAvatar(size);
                },
              ),
            )
          : _buildDefaultAvatar(size),
    );
  }

  Widget _buildDefaultAvatar(double size) {
    return Icon(Icons.person_rounded, size: size * 0.6, color: Colors.white);
  }

  Widget _buildDailySummaryCard() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B), // Secondary background for cards
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F1629).withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.primaryIndigo.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(
                    12,
                  ), // Fixed: Removed const from here
                ),
                child: const Icon(
                  Icons.today_rounded,
                  color: AppTheme.primaryIndigo,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Today\'s Summary', // Fixed: Removed const from here
                style: TextStyle(
                  color: AppTheme.whiteText, // #FFFFFF
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _buildSummaryItem(
                  'Calories Burned',
                  '245',
                  'kcal',
                  Icons.local_fire_department_rounded,
                  Colors.orange,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildSummaryItem(
                  'Workouts Done',
                  '2',
                  'sessions',
                  Icons.fitness_center_rounded,
                  Colors.green, // #10B981
                ), // Fixed: Removed const from here
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildSummaryItem(
                  'Active Time',
                  '45',
                  'minutes',
                  Icons.timer_rounded,
                  AppTheme.primaryIndigo,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(
    String title,
    String value,
    String unit,
    IconData icon,
    Color color,
  ) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            color: AppTheme.whiteText, // #FFFFFF
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          unit,
          style: const TextStyle(
            color: AppTheme.greyText, // #A5B4FC
            fontSize: 10,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          title,
          style: const TextStyle(
            color: AppTheme.greyText, // #A5B4FC
            fontSize: 11,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildStatsCards() {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            icon: Icons.flag_rounded,
            title: "Current Goal",
            value: _goal,
            gradient: const LinearGradient(
              colors: [AppTheme.primaryIndigo, AppTheme.primaryIndigo],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildStatCard(
            icon: Icons.monitor_weight_rounded,
            title: "BMI Status",
            value: _bmi > 0
                ? "${_bmi.toStringAsFixed(1)}\n${_bmiStatus(_bmi)}"
                : _bmiStatus(_bmi),
            gradient: LinearGradient(
              // Fixed: Removed const from here
              colors: [_getBmiColor(_bmi), _getBmiColor(_bmi).withOpacity(0.7)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard({
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
            color: Colors.black.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 6),
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
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: IntrinsicHeight(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 100,
              child: _buildActionButton(
                onPressed: widget.onStartSearch,
                icon: Icons.search_rounded,
                label: "Find",
                gradient: const LinearGradient(
                  colors: [AppTheme.primaryIndigo, AppTheme.primaryIndigo],
                ),
              ),
            ),
            const SizedBox(width: 12),
            SizedBox(
              width: 140,
              child: _buildActionButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Starting workout...'),
                      backgroundColor: Color(0xFF886AFC),
                    ),
                  );
                },
                icon: Icons.play_arrow_rounded,
                label: "Start Workout",
                gradient: const LinearGradient(
                  colors: [Color(0xFF886AFC), Color(0xFF18191E)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
            const SizedBox(width: 12),
            SizedBox(
              width: 100,
              child: _buildActionButton(
                onPressed: widget.onStartPlan,
                icon: Icons.calendar_today_rounded,
                label: "Plan",
                gradient: const LinearGradient(
                  colors: [AppTheme.primaryIndigo, AppTheme.primaryIndigo],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required VoidCallback onPressed,
    required IconData icon,
    required String label,
    required Gradient gradient,
  }) {
    return Container(
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, color: Colors.white),
        label: Text(
          // Fixed: Removed const from here
          label, // Fixed: Removed const from here
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }

  Widget _buildSuggestedWorkouts() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.2), // #10B981
                borderRadius: BorderRadius.circular(
                  12,
                ), // Fixed: Removed const from here
              ),
              child: Icon(
                Icons.recommend_rounded, // Fixed: Removed const from here
                color: Colors.green, // #10B981
                size: 20,
              ),
            ),
            const SizedBox(width: 12), // Fixed: Removed const from here
            const Text(
              // Fixed: Removed const from here
              'Suggested for You',
              style: TextStyle(
                color: AppTheme.whiteText, // #FFFFFF
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 160,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _suggestedWorkouts.length,
            itemBuilder: (context, index) {
              final workout = _suggestedWorkouts[index];
              return Container(
                width: 120,
                margin: EdgeInsets.only(
                  right: index == _suggestedWorkouts.length - 1 ? 0 : 16,
                ),
                child: _buildSuggestedWorkoutCard(workout),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSuggestedWorkoutCard(Workout workout) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B), // Secondary background for cards
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F1629).withOpacity(0.2),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
                gradient: const LinearGradient(
                  // Fixed: Removed const from here
                  colors: [AppTheme.primaryIndigo, AppTheme.primaryIndigo],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Stack(
                children: [
                  const Center(
                    child: Icon(
                      Icons.play_circle_fill,
                      size: 32,
                      color: Colors.white,
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '${workout.durationMinutes}m',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start, // Fixed: Removed const from here
                children: [
                  // Fixed: Removed const from here
                  Text(
                    workout.title,
                    style: const TextStyle(
                      color: AppTheme.whiteText, // #FFFFFF
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const Spacer(),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryIndigo.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'Quick Start',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppTheme.primaryIndigo,
                        fontSize: 10, // Fixed: Removed const from here
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
