import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../config/app_theme.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _headerAnimation;
  late final Animation<double> _cardAnimation;

  // Text Controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _goalController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();

  // User Data
  String _name = "Fitness Warrior";
  String _email = "";
  String _goal = "Transform Your Body";
  double _height = 0;
  double _weight = 0;
  int _age = 0;
  String _activityLevel = 'Beginner';
  String? _profileImagePath;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _loadUserData();
  }

  void _setupAnimations() {
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _headerAnimation = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
    );

    _cardAnimation = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.3, 1.0, curve: Curves.elasticOut),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
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
      _name = prefs.getString('name') ?? 'Fitness Warrior';
      _email = prefs.getString('email') ?? '';
      _goal = prefs.getString('goal') ?? 'Transform Your Body';
      _height = prefs.getDouble('height') ?? 0;
      _weight = prefs.getDouble('weight') ?? 0;
      _age = prefs.getInt('age') ?? 0;
      _activityLevel = prefs.getString('activity_level') ?? 'Beginner';
      _profileImagePath = prefs.getString('profile_image');

      _nameController.text = _name;
      _emailController.text = _email;
      _goalController.text = _goal;
      _heightController.text = _height > 0 ? _height.toString() : '';
      _weightController.text = _weight > 0 ? _weight.toString() : '';
      _ageController.text = _age > 0 ? _age.toString() : '';
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

    setState(() {
      _name = _nameController.text;
      _email = _emailController.text;
      _goal = _goalController.text;
      _height = height ?? 0;
      _weight = weight ?? 0;
      _age = age ?? 0;
    });

    _showSuccessSnackBar('Profile updated successfully!');
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle_rounded, color: Colors.white),
            const SizedBox(width: 12),
            Text(message),
          ],
        ),
        backgroundColor: AppTheme.successGreen,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  Future<void> _selectProfileImage() async {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: AppTheme.cardBackground,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppTheme.textSecondary.withOpacity(0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Choose Profile Picture',
              style: TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            ListTile(
              leading: const Icon(
                Icons.photo_library,
                color: AppTheme.primaryPurple,
              ),
              title: const Text(
                'Gallery',
                style: TextStyle(color: AppTheme.textPrimary),
              ),
              onTap: _pickImageFromGallery,
            ),
            if (_profileImagePath != null)
              ListTile(
                leading: const Icon(Icons.delete, color: AppTheme.errorRed),
                title: const Text(
                  'Remove Picture',
                  style: TextStyle(color: AppTheme.errorRed),
                ),
                onTap: _removeProfileImage,
              ),
          ],
        ),
      ),
    );
  }

  void _pickImageFromGallery() {
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Gallery feature coming soon!'),
        backgroundColor: AppTheme.primaryPurple,
      ),
    );
  }

  void _removeProfileImage() async {
    Navigator.pop(context);
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('profile_image');
    setState(() {
      _profileImagePath = null;
    });
    _showSuccessSnackBar('Profile picture removed');
  }

  void _handleActivityLevelChange(String level) {
    setState(() {
      _activityLevel = level;
    });
    _saveUserData();
  }

  double get _bmi {
    if (_height > 0 && _weight > 0) {
      return _weight / ((_height / 100) * (_height / 100));
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
    if (bmi == 0) return AppTheme.textSecondary;
    if (bmi < 18.5) return AppTheme.primaryPurple;
    if (bmi < 24.9) return AppTheme.successGreen;
    if (bmi < 29.9) return Colors.orange;
    return AppTheme.errorRed;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: AppTheme.darkBackground,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Text('My Profile'),
        ),
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Card(
        color: AppTheme.cardBackground,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              _buildProfilePicture(),
              const SizedBox(height: 24),
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
        ),
      ),
    );
  }

  Widget _buildProfilePicture() {
    return GestureDetector(
      onTap: _selectProfileImage,
      child: Stack(
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppTheme.primaryPurple.withOpacity(0.1),
              image: _profileImagePath != null
                  ? DecorationImage(
                      image: AssetImage(_profileImagePath!),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: _profileImagePath == null
                ? Icon(
                    Icons.person_outline,
                    size: 60,
                    color: AppTheme.primaryPurple,
                  )
                : null,
          ),
          Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppTheme.primaryPurple,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.shadowColor.withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Icon(
                Icons.camera_alt,
                size: 20,
                color: AppTheme.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBodyStats() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Card(
        color: AppTheme.cardBackground,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Body Stats',
                style: TextStyle(
                  color: AppTheme.textPrimary,
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
                        color: AppTheme.textSecondary,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGoals() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Card(
        color: AppTheme.cardBackground,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Your Goals',
                style: TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              _buildTextField(
                controller: _goalController,
                label: 'Fitness Goal',
                icon: Icons.flag_outlined,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActivityLevels() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Card(
        color: AppTheme.cardBackground,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Activity Level',
                style: TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              _buildActivityOption(
                'Beginner',
                'New to fitness',
                Icons.directions_walk,
                _activityLevel == 'Beginner',
              ),
              const SizedBox(height: 12),
              _buildActivityOption(
                'Intermediate',
                'Workout 2-3 times a week',
                Icons.directions_run,
                _activityLevel == 'Intermediate',
              ),
              const SizedBox(height: 12),
              _buildActivityOption(
                'Advanced',
                'Workout 4+ times a week',
                Icons.fitness_center,
                _activityLevel == 'Advanced',
              ),
            ],
          ),
        ),
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
      style: const TextStyle(color: AppTheme.textPrimary, fontSize: 16),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: AppTheme.primaryPurple, size: 24),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppTheme.borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppTheme.borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppTheme.primaryPurple, width: 2),
        ),
        filled: true,
        fillColor: AppTheme.inputBackground,
      ),
      onChanged: (_) => _saveUserData(),
    );
  }

  Widget _buildActivityOption(
    String title,
    String subtitle,
    IconData icon,
    bool isSelected,
  ) {
    return InkWell(
      onTap: () => _handleActivityLevelChange(title),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? AppTheme.primaryPurple : AppTheme.borderColor,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
          color: isSelected ? AppTheme.primaryPurple.withOpacity(0.1) : null,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected
                  ? AppTheme.primaryPurple
                  : AppTheme.textSecondary,
              size: 24,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: isSelected
                          ? AppTheme.primaryPurple
                          : AppTheme.textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: AppTheme.textSecondary,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              const Icon(
                Icons.check_circle,
                color: AppTheme.primaryPurple,
                size: 24,
              ),
          ],
        ),
      ),
    );
  }
}
