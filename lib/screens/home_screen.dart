import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../config/app_theme.dart';

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

class _HomeScreenState extends State<HomeScreen> {
  String _name = "";
  String _goal = "";
  double _bmi = 0;
  bool _isDarkMode = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _name = prefs.getString("name") ?? "User";
      _goal = prefs.getString("goal") ?? "N/A";
      _bmi = prefs.getDouble("bmi") ?? 0;
      _isDarkMode = prefs.getBool("darkMode") ?? false;
    });
  }

  Future<void> _toggleTheme() async {
    setState(() => _isDarkMode = !_isDarkMode);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool("darkMode", _isDarkMode);
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
              secondary: Icon(_isDarkMode ? Icons.dark_mode : Icons.light_mode),
              title: Text(_isDarkMode ? "Dark Mode" : "Light Mode"),
              value: _isDarkMode,
              onChanged: (_) => _toggleTheme(),
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
    final theme = _isDarkMode ? AppTheme.darkTheme : AppTheme.lightTheme;

    return Theme(
      data: theme,
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: ListView(
              children: [
                // 👤 Greeting
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
                          color: theme.brightness == Brightness.dark
                              ? AppTheme.darkText
                              : AppTheme.lightText,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // 🎯 Goal + BMI cards
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
                        value:
                            "${_bmi.toStringAsFixed(1)}\n${_bmiStatus(_bmi)}",
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

                // 🔍 Workout + Plan buttons
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

                // 🔐 Firebase Login UI (commented out)
                /*
                Center(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // TODO: enable Firebase Google Sign-In
                    },
                    icon: Image.network(
                      'https://developers.google.com/identity/images/g-logo.png',
                      height: 20,
                    ),
                    label: const Text("Continue with Google"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                ),
                */
              ],
            ),
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
