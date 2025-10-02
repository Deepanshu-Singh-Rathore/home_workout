// screens/progress_screen.dart
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../config/app_theme.dart';

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key});

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  // Weight logs
  List<double> _weights = [];
  final TextEditingController _weightController = TextEditingController();

  // Progress data
  final List<Map<String, dynamic>> _progressCards = [
    {
      'title': 'Workouts Completed',
      'value': 42,
      'icon': Icons.check_circle,
      'color': AppTheme.successGreen,
    },
    {
      'title': 'Total Minutes',
      'value': 1230,
      'icon': Icons.timer,
      'color': Colors.orange,
    },
    {
      'title': 'Calories Burned',
      'value': 8900,
      'icon': Icons.local_fire_department,
      'color': AppTheme.errorRed,
    },
    {
      'title': 'Strength Sessions',
      'value': 18,
      'icon': Icons.fitness_center,
      'color': AppTheme.primaryPurple,
    },
  ];

  @override
  void initState() {
    super.initState();
    _loadWeights();
  }

  @override
  void dispose() {
    _weightController.dispose();
    super.dispose();
  }

  Future<void> _loadWeights() async {
    final prefs = await SharedPreferences.getInstance();
    final weightStrings = prefs.getStringList('weight_logs') ?? [];
    setState(() {
      _weights = weightStrings.map((w) => double.tryParse(w) ?? 0).toList();
    });
  }

  Future<void> _saveWeights() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      'weight_logs',
      _weights.map((w) => w.toString()).toList(),
    );
  }

  void _addWeight() {
    final value = double.tryParse(_weightController.text);
    if (value != null && value > 0) {
      setState(() {
        _weights.add(value);
        _weightController.clear();
      });
      _saveWeights();
    }
  }

  void _deleteWeight(int index) {
    setState(() {
      _weights.removeAt(index);
    });
    _saveWeights();
  }

  // Update the _buildSummaryItem method to work with responsive layout:
  Widget _buildSummaryItem(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(color: Colors.white70, fontSize: 12),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.darkBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Progress'),
      ),
      body: SafeArea(
        bottom: true,
        child: SingleChildScrollView(
          padding: EdgeInsets.only(
            left: 24,
            right: 24,
            top: 24,
            bottom: MediaQuery.of(context).padding.bottom + 24,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Progress summary cards
              Container(
                margin: const EdgeInsets.all(24),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Progress Summary',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Use Column with Rows instead of horizontal ListView
                    Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: _buildSummaryItem(
                                'Workouts',
                                _progressCards[0]['value'].toString(),
                                _progressCards[0]['icon'],
                                _progressCards[0]['color'],
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildSummaryItem(
                                'Minutes',
                                _progressCards[1]['value'].toString(),
                                _progressCards[1]['icon'],
                                _progressCards[1]['color'],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: _buildSummaryItem(
                                'Calories',
                                _progressCards[2]['value'].toString(),
                                _progressCards[2]['icon'],
                                _progressCards[2]['color'],
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildSummaryItem(
                                'Strength',
                                _progressCards[3]['value'].toString(),
                                _progressCards[3]['icon'],
                                _progressCards[3]['color'],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Weight logs section
              const Text(
                'Weight Logs',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),

              // Weight input
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _weightController,
                      keyboardType: TextInputType.number,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'Enter weight (kg)',
                        hintStyle: const TextStyle(color: Colors.white54),
                        filled: true,
                        fillColor: Colors.grey[800],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: _addWeight,
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.resolveWith<Color>(
                        (states) => states.contains(MaterialState.pressed)
                            ? Colors.purple
                            : Colors.grey[800]!,
                      ),
                      foregroundColor: MaterialStateProperty.all<Color>(
                        Colors.white,
                      ),
                      padding: MaterialStateProperty.all<EdgeInsets>(
                        const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 16,
                        ),
                      ),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    child: const Text('Add'),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Weight logs list
              if (_weights.isNotEmpty) ...[
                Container(
                  constraints: const BoxConstraints(maxHeight: 200),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: _weights.length,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.grey[900],
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.08),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: ListTile(
                          title: Text(
                            '${_weights[index]} kg',
                            style: const TextStyle(color: Colors.white),
                          ),
                          trailing: IconButton(
                            icon: const Icon(
                              Icons.delete,
                              color: AppTheme.errorRed,
                            ),
                            onPressed: () => _deleteWeight(index),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 24),

                // Weight trend chart
                Container(
                  height: 180,
                  decoration: BoxDecoration(
                    color: Colors.grey[900],
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(16),
                  child: LineChart(
                    LineChartData(
                      lineBarsData: [
                        LineChartBarData(
                          spots: List.generate(
                            _weights.length,
                            (i) => FlSpot(i.toDouble(), _weights[i]),
                          ),
                          isCurved: true,
                          color: AppTheme.primaryPurple,
                          barWidth: 3,
                          dotData: const FlDotData(show: false),
                        ),
                      ],
                      titlesData: const FlTitlesData(show: false),
                      gridData: const FlGridData(show: false),
                      borderData: FlBorderData(show: false),
                      backgroundColor: Colors.transparent,
                    ),
                  ),
                ),
              ] else ...[
                Container(
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.grey[900],
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Text(
                      'Add weight entries to see trends',
                      style: TextStyle(color: Colors.white70, fontSize: 16),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
