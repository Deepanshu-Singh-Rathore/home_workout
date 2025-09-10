import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _formKey = GlobalKey<FormState>();

  String _name = "";
  int _age = 0;

  double _heightCm = 0;
  double _weightKg = 0;

  final TextEditingController _heightFeetController = TextEditingController();
  final TextEditingController _heightInchesController = TextEditingController();
  final TextEditingController _heightCmController = TextEditingController();

  final TextEditingController _weightKgController = TextEditingController();
  final TextEditingController _weightPoundsController = TextEditingController();

  String _goal = "Lose Fat";

  bool isHeightMetric = true;
  bool isWeightMetric = true;

  final List<String> _goals = [
    "Lose Fat",
    "Gain Muscle",
    "Recomposition",
    "Maintain",
  ];

  Future<void> _saveData() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      if (!isHeightMetric) {
        final feet = double.tryParse(_heightFeetController.text) ?? 0;
        final inches = double.tryParse(_heightInchesController.text) ?? 0;
        _heightCm = (feet * 12 + inches) * 2.54;
      } else {
        _heightCm = double.tryParse(_heightCmController.text) ?? 0;
      }

      if (!isWeightMetric) {
        final pounds = double.tryParse(_weightPoundsController.text) ?? 0;
        _weightKg = pounds * 0.45359237;
      } else {
        _weightKg = double.tryParse(_weightKgController.text) ?? 0;
      }

      double heightInMeters = _heightCm / 100;
      double bmi = _weightKg / (heightInMeters * heightInMeters);

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString("name", _name);
      await prefs.setInt("age", _age);
      await prefs.setDouble("height", _heightCm);
      await prefs.setDouble("weight", _weightKg);
      await prefs.setString("goal", _goal);
      await prefs.setDouble("bmi", bmi);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => HomeScreen(onStartSearch: () {}, onStartPlan: () {}),
        ),
      );
    }
  }

  @override
  void dispose() {
    _heightFeetController.dispose();
    _heightInchesController.dispose();
    _heightCmController.dispose();
    _weightKgController.dispose();
    _weightPoundsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0F0F12), Color(0xFF16161A)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const SizedBox(height: 30),
                Text(
                  "Welcome to Home Workout",
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Text(
                  "Tell us about yourself to personalize your plan",
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: Colors.white70),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 8,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            decoration: const InputDecoration(
                              labelText: "Name",
                              prefixIcon: Icon(Icons.person),
                            ),
                            validator: (value) => value == null || value.isEmpty
                                ? "Enter your name"
                                : null,
                            onSaved: (value) => _name = value!,
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            decoration: const InputDecoration(
                              labelText: "Age",
                              prefixIcon: Icon(Icons.cake),
                            ),
                            keyboardType: TextInputType.number,
                            validator: (value) => value == null || value.isEmpty
                                ? "Enter age"
                                : null,
                            onSaved: (value) =>
                                _age = int.tryParse(value!) ?? 0,
                          ),
                          const SizedBox(height: 12),

                          // Height input with toggle
                          Row(
                            children: [
                              Expanded(
                                child: isHeightMetric
                                    ? TextFormField(
                                        controller: _heightCmController,
                                        decoration: const InputDecoration(
                                          labelText: "Height (cm)",
                                          prefixIcon: Icon(Icons.height),
                                        ),
                                        keyboardType: TextInputType.number,
                                        validator: (value) =>
                                            value == null || value.isEmpty
                                            ? 'Enter height'
                                            : null,
                                      )
                                    : Row(
                                        children: [
                                          Expanded(
                                            child: TextFormField(
                                              controller: _heightFeetController,
                                              decoration: const InputDecoration(
                                                labelText: "Feet",
                                              ),
                                              keyboardType:
                                                  TextInputType.number,
                                              validator: (value) =>
                                                  value == null || value.isEmpty
                                                  ? 'Enter feet'
                                                  : null,
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                          Expanded(
                                            child: TextFormField(
                                              controller:
                                                  _heightInchesController,
                                              decoration: const InputDecoration(
                                                labelText: "Inches",
                                              ),
                                              keyboardType:
                                                  TextInputType.number,
                                              validator: (value) =>
                                                  value == null || value.isEmpty
                                                  ? 'Enter inches'
                                                  : null,
                                            ),
                                          ),
                                        ],
                                      ),
                              ),
                              const SizedBox(width: 12),
                              ToggleButtons(
                                isSelected: [isHeightMetric, !isHeightMetric],
                                onPressed: (index) {
                                  setState(() {
                                    isHeightMetric = index == 0;
                                  });
                                },
                                borderRadius: BorderRadius.circular(8),
                                children: const [
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 8,
                                    ),
                                    child: Text('cm'),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 8,
                                    ),
                                    child: Text('ft/in'),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),

                          // Weight input with toggle
                          Row(
                            children: [
                              Expanded(
                                child: isWeightMetric
                                    ? TextFormField(
                                        controller: _weightKgController,
                                        decoration: const InputDecoration(
                                          labelText: "Weight (kg)",
                                          prefixIcon: Icon(
                                            Icons.monitor_weight,
                                          ),
                                        ),
                                        keyboardType: TextInputType.number,
                                        validator: (value) =>
                                            value == null || value.isEmpty
                                            ? 'Enter weight'
                                            : null,
                                      )
                                    : TextFormField(
                                        controller: _weightPoundsController,
                                        decoration: const InputDecoration(
                                          labelText: "Weight (lbs)",
                                          prefixIcon: Icon(
                                            Icons.monitor_weight,
                                          ),
                                        ),
                                        keyboardType: TextInputType.number,
                                        validator: (value) =>
                                            value == null || value.isEmpty
                                            ? 'Enter weight'
                                            : null,
                                      ),
                              ),
                              const SizedBox(width: 12),
                              ToggleButtons(
                                isSelected: [isWeightMetric, !isWeightMetric],
                                onPressed: (index) {
                                  setState(() {
                                    isWeightMetric = index == 0;
                                  });
                                },
                                borderRadius: BorderRadius.circular(8),
                                children: const [
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 8,
                                    ),
                                    child: Text('kg'),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 8,
                                    ),
                                    child: Text('lbs'),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),

                          DropdownButtonFormField<String>(
                            value: _goal,
                            items: _goals.map((goal) {
                              return DropdownMenuItem(
                                value: goal,
                                child: Text(goal),
                              );
                            }).toList(),
                            onChanged: (value) =>
                                setState(() => _goal = value!),
                            decoration: const InputDecoration(
                              labelText: "Fitness Goal",
                              prefixIcon: Icon(Icons.flag),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: _saveData,
                    style:
                        ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: EdgeInsets.zero,
                        ).copyWith(
                          backgroundColor:
                              MaterialStateProperty.resolveWith<Color?>(
                                (states) => null,
                              ),
                        ),
                    child: Ink(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF00FF88), Color(0xFF00CC6A)],
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Container(
                        alignment: Alignment.center,
                        child: const Text(
                          "Continue",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
