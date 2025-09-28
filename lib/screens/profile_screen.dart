import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../config/app_theme.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Text Controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _goalController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();

  // User Data
  String _activityLevel = 'Beginner';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _goalController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _nameController.text = prefs.getString('name') ?? 'Fitness Warrior';
      _emailController.text = prefs.getString('email') ?? '';
      _goalController.text = prefs.getString('goal') ?? 'Transform Your Body';
      _heightController.text = (prefs.getDouble('height') ?? 0) > 0
          ? prefs.getDouble('height')!.toString()
          : '';
      _weightController.text = (prefs.getDouble('weight') ?? 0) > 0
          ? prefs.getDouble('weight')!.toString()
          : '';
      _ageController.text = (prefs.getInt('age') ?? 0) > 0
          ? prefs.getInt('age')!.toString()
          : '';
      _activityLevel = prefs.getString('activity_level') ?? 'Beginner';
    });
  }

  Future<void> _saveUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('name', _nameController.text);
    await prefs.setString('email', _emailController.text);
    await prefs.setString('goal', _goalController.text);

    final height = double.tryParse(_heightController.text);
    final weight = double.tryParse(_weightController.text);
    final age = int.tryParse(_ageController.text);

    if (height != null) await prefs.setDouble('height', height);
    if (weight != null) await prefs.setDouble('weight', weight);
    if (age != null) await prefs.setInt('age', age);
    await prefs.setString('activity_level', _activityLevel);
  }

  double get _bmi {
    final h = double.tryParse(_heightController.text);
    final w = double.tryParse(_weightController.text);
    if (h != null && h > 0 && w != null && w > 0) {
      return w / ((h / 100) * (h / 100));
    }
    return 0;
  }

  String _getBmiStatus(double bmi) {
    if (bmi == 0) return "Not calculated";
    if (bmi < 18.5) return "Underweight";
    if (bmi < 24.9) return "Healthy Weight";
    if (bmi < 29.9) return "Overweight";
    return "Obese";
  }

  Color _getBmiColor(double bmi) {
    if (bmi == 0) return AppTheme.greyText;
    if (bmi < 18.5) return AppTheme.primaryIndigo;
    if (bmi < 24.9) return Colors.green;
    if (bmi < 29.9) return Colors.orange;
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(title: const Text('My Profile')),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildProfileInfo(),
                const SizedBox(height: 16),
                _buildBodyStats(),
                const SizedBox(height: 16),
                _buildGoals(),
                const SizedBox(height: 16),
                _buildActivityLevels(),
                SizedBox(height: MediaQuery.of(context).padding.bottom),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileInfo() {
    return _buildCard(
      child: Column(
        children: [
          _buildTextField(
            controller: _nameController,
            label: 'Full Name',
            icon: Icons.person_outline,
          ),
          const SizedBox(height: 16),
          _buildTextField(
            controller: _emailController,
            label: 'Email',
            icon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
          ),
        ],
      ),
    );
  }

  Widget _buildBodyStats() {
    return _buildCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Body Stats',
            style: TextStyle(
              color: AppTheme.whiteText,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: _buildTextField(
                  controller: _heightController,
                  label: 'Height (cm)',
                  icon: Icons.height,
                  keyboardType: TextInputType.number,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildTextField(
                  controller: _weightController,
                  label: 'Weight (kg)',
                  icon: Icons.monitor_weight_outlined,
                  keyboardType: TextInputType.number,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildTextField(
            controller: _ageController,
            label: 'Age',
            icon: Icons.calendar_today,
            keyboardType: TextInputType.number,
          ),
          if (_bmi > 0) ...[
            const SizedBox(height: 24),
            Row(
              children: [
                Icon(Icons.insights, color: _getBmiColor(_bmi)),
                const SizedBox(width: 8),
                Text(
                  'BMI: ${_bmi.toStringAsFixed(1)}',
                  style: TextStyle(
                    color: _getBmiColor(_bmi),
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '(${_getBmiStatus(_bmi)})',
                  style: const TextStyle(
                    color: AppTheme.greyText,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildGoals() {
    return _buildCard(
      child: _buildTextField(
        controller: _goalController,
        label: 'Fitness Goal',
        icon: Icons.flag_outlined,
      ),
    );
  }

  Widget _buildActivityLevels() {
    return _buildCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Activity Level',
            style: TextStyle(
              color: AppTheme.whiteText,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          _buildActivityOption(
            'Beginner',
            'New to fitness',
            Icons.directions_walk,
          ),
          const SizedBox(height: 12),
          _buildActivityOption(
            'Intermediate',
            'Workout 2-3 times a week',
            Icons.directions_run,
          ),
          const SizedBox(height: 12),
          _buildActivityOption(
            'Advanced',
            'Workout 4+ times a week',
            Icons.fitness_center,
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      style: const TextStyle(color: AppTheme.whiteText, fontSize: 16),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: AppTheme.primaryIndigo, size: 24),
      ),
      onChanged: (_) => _saveUserData(),
    );
  }

  Widget _buildActivityOption(String title, String subtitle, IconData icon) {
    final isSelected = _activityLevel == title;
    return InkWell(
      onTap: () {
        setState(() => _activityLevel = title);
        _saveUserData();
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? AppTheme.primaryIndigo : AppTheme.borderGrey,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
          color: isSelected ? AppTheme.primaryIndigo.withOpacity(0.1) : null,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? AppTheme.primaryIndigo : AppTheme.greyText,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  color: isSelected
                      ? AppTheme.primaryIndigo
                      : AppTheme.whiteText,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            if (isSelected)
              const Icon(
                Icons.check_circle,
                color: AppTheme.primaryIndigo,
                size: 24,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard({required Widget child}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Card(
        // color: Theme.of(context).cardTheme.color,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(padding: const EdgeInsets.all(24), child: child),
      ),
    );
  }
}
