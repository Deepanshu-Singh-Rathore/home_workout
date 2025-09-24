// screens/progress_screen.dart
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math' as math;

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key});

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen>
    with TickerProviderStateMixin {
  final TextEditingController _weightController = TextEditingController();

  List<double> _weights = [];
  List<int> _strengthTrend = [];
  List<DateTime> _workoutDates = [];
  Map<String, int> _workoutTypes = {};
  List<double> _weeklyProgress = [];
  Map<String, double> _bodyMetrics = {};

  late AnimationController _headerController;
  late AnimationController _chartController;
  late Animation<double> _headerAnimation;
  late Animation<double> _chartAnimation;

  int _selectedTab = 0;
  final List<String> _tabs = ['Overview', 'Weight', 'Strength', 'Activity', 'Body'];

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _loadData();
    _generateMockData();
  }

  void _setupAnimations() {
    _headerController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _chartController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _headerAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _headerController, curve: Curves.easeOut),
    );

    _chartAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _chartController, curve: Curves.elasticOut),
    );

    _headerController.forward();
    Future.delayed(const Duration(milliseconds: 400), () {
      _chartController.forward();
    });
  }

  @override
  void dispose() {
    _headerController.dispose();
    _chartController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    final weightList = prefs.getStringList("weights") ?? [];
    final strengthList = prefs.getStringList("strengthTrend") ?? [];
    final workoutDatesList = prefs.getStringList("workoutDates") ?? [];

    setState(() {
      _weights = weightList.map((e) => double.tryParse(e) ?? 0).toList();
      _strengthTrend = strengthList.map((e) => int.tryParse(e) ?? 0).toList();
      _workoutDates = workoutDatesList
          .map((e) => DateTime.tryParse(e) ?? DateTime.now())
          .toList();
    });
  }

  void _generateMockData() {
    // Generate mock data for demonstration
    setState(() {
      // Mock weights for the last 12 weeks
      if (_weights.isEmpty) {
        for (int i = 0; i < 12; i++) {
          _weights.add(70.0 + math.Random().nextDouble() * 4 - 2);
        }
      }

      // Mock workout types distribution
      _workoutTypes = {
        'Strength': 45,
        'Cardio': 30,
        'Yoga': 15,
        'HIIT': 25,
        'Stretching': 10,
      };

      // Mock weekly progress (hours per week for last 8 weeks)
      _weeklyProgress = [2.5, 3.0, 2.8, 4.2, 3.7, 4.0, 3.5, 4.5];

      // Mock body metrics
      _bodyMetrics = {
        'Body Fat': 15.2,
        'Muscle Mass': 45.8,
        'Water': 65.3,
        'BMR': 1850,
      };

      // Generate some mock workout dates
      if (_workoutDates.isEmpty) {
        final now = DateTime.now();
        for (int i = 30; i >= 0; i--) {
          if (math.Random().nextBool()) {
            _workoutDates.add(now.subtract(Duration(days: i)));
          }
        }
      }
    });
  }

  Future<void> _saveWeight() async {
    final weight = double.tryParse(_weightController.text);
    if (weight == null || weight <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid weight'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _weights.add(weight);
      _weightController.clear();
    });

    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      "weights",
      _weights.map((e) => e.toString()).toList(),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white),
            SizedBox(width: 8),
            Text('Weight recorded successfully!'),
          ],
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  int get _weeklyWorkouts {
    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday - 1));
    return _workoutDates.where((date) => date.isAfter(weekStart)).length;
  }

  int get _monthlyWorkouts {
    final now = DateTime.now();
    final monthStart = DateTime(now.year, now.month, 1);
    return _workoutDates.where((date) => date.isAfter(monthStart)).length;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Enhanced header
            SliverToBoxAdapter(
              child: FadeTransition(
                opacity: _headerAnimation,
                child: _buildHeader(theme),
              ),
            ),

            // Tab selector
            SliverToBoxAdapter(
              child: FadeTransition(
                opacity: _headerAnimation,
                child: _buildTabSelector(theme),
              ),
            ),

            // Content based on selected tab
            SliverToBoxAdapter(
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0.0, 0.3),
                  end: Offset.zero,
                ).animate(_chartAnimation),
                child: _buildTabContent(theme),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            theme.colorScheme.primary.withOpacity(0.1),
            theme.colorScheme.secondary.withOpacity(0.05),
            Colors.transparent,
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      theme.colorScheme.primary,
                      theme.colorScheme.secondary,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: theme.colorScheme.primary.withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.trending_up_rounded,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Progress Dashboard',
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Track your fitness journey',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Quick stats
          Row(
            children: [
              Expanded(
                child: _buildQuickStat(
                  'This Week',
                  '$_weeklyWorkouts workouts',
                  Icons.calendar_view_week_rounded,
                  Colors.blue,
                  theme,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildQuickStat(
                  'This Month',
                  '$_monthlyWorkouts workouts',
                  Icons.calendar_month_rounded,
                  Colors.green,
                  theme,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStat(
    String label,
    String value,
    IconData icon,
    Color color,
    ThemeData theme,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 16),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                Text(
                  label,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.textTheme.bodySmall?.color?.withOpacity(0.7),
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabSelector(ThemeData theme) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: _tabs.asMap().entries.map((entry) {
            final index = entry.key;
            final tab = entry.value;
            final isSelected = _selectedTab == index;

            return GestureDetector(
              onTap: () => setState(() => _selectedTab = index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                margin: const EdgeInsets.only(right: 4),
                decoration: BoxDecoration(
                  color: isSelected
                      ? theme.colorScheme.primary
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  tab,
                  style: TextStyle(
                    color: isSelected
                        ? Colors.white
                        : theme.textTheme.bodyMedium?.color,
                    fontWeight: isSelected
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildTabContent(ThemeData theme) {
    switch (_selectedTab) {
      case 0:
        return _buildOverviewSection(theme);
      case 1:
        return _buildWeightSection(theme);
      case 2:
        return _buildStrengthSection(theme);
      case 3:
        return _buildActivitySection(theme);
      case 4:
        return _buildBodySection(theme);
      default:
        return Container();
    }
  }

  Widget _buildOverviewSection(ThemeData theme) {
    return Column(
      children: [
        // Weekly Progress Chart
        _buildSectionCard(
          title: "Weekly Activity Overview",
          icon: Icons.timeline_rounded,
          theme: theme,
          children: [
            SizedBox(
              height: 200,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: 6,
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                        getTitlesWidget: (value, meta) => Text(
                          '${value.toInt()}h',
                          style: theme.textTheme.bodySmall,
                        ),
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          const weeks = ['W1', 'W2', 'W3', 'W4', 'W5', 'W6', 'W7', 'W8'];
                          return Text(
                            value < weeks.length ? weeks[value.toInt()] : '',
                            style: theme.textTheme.bodySmall,
                          );
                        },
                      ),
                    ),
                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  borderData: FlBorderData(show: false),
                  barGroups: _weeklyProgress.asMap().entries.map((entry) {
                    return BarChartGroupData(
                      x: entry.key,
                      barRods: [
                        BarChartRodData(
                          toY: entry.value,
                          color: theme.colorScheme.primary,
                          width: 20,
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),

        // Workout Types Distribution
        _buildSectionCard(
          title: "Workout Distribution",
          icon: Icons.pie_chart_rounded,
          theme: theme,
          children: [
            SizedBox(
              height: 200,
              child: PieChart(
                PieChartData(
                  sectionsSpace: 2,
                  centerSpaceRadius: 40,
                  sections: _workoutTypes.entries.map((entry) {
                    final colors = [
                      Colors.red,
                      Colors.blue,
                      Colors.green,
                      Colors.orange,
                      Colors.purple,
                    ];
                    final index = _workoutTypes.keys.toList().indexOf(entry.key);
                    final color = colors[index % colors.length];
                    
                    return PieChartSectionData(
                      value: entry.value.toDouble(),
                      title: '${entry.value}%',
                      color: color,
                      radius: 50,
                      titleStyle: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 16,
              runSpacing: 8,
              children: _workoutTypes.entries.map((entry) {
                final colors = [Colors.red, Colors.blue, Colors.green, Colors.orange, Colors.purple];
                final index = _workoutTypes.keys.toList().indexOf(entry.key);
                final color = colors[index % colors.length];
                
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      entry.key,
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                );
              }).toList(),
            ),
          ],
        ),

        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildWeightSection(ThemeData theme) {
    return _buildSectionCard(
      title: "Weight Tracking",
      icon: Icons.monitor_weight_rounded,
      theme: theme,
      children: [
        // Weight input
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _weightController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "Current Weight (kg)",
                  prefixIcon: Icon(
                    Icons.monitor_weight_rounded,
                    color: theme.colorScheme.primary,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            ElevatedButton(
              onPressed: _saveWeight,
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.all(16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Icon(Icons.add),
            ),
          ],
        ),

        const SizedBox(height: 20),

        // Weight chart
        SizedBox(
          height: 250,
          child: _weights.isEmpty
              ? _buildEmptyChart('No weight data yet', 'Add your first weight measurement')
              : LineChart(
                  LineChartData(
                    gridData: FlGridData(
                      show: true,
                      drawVerticalLine: false,
                      getDrawingHorizontalLine: (value) => FlLine(
                        color: theme.dividerColor,
                        strokeWidth: 1,
                      ),
                    ),
                    titlesData: FlTitlesData(
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 40,
                          getTitlesWidget: (value, meta) => Text(
                            '${value.toInt()}',
                            style: theme.textTheme.bodySmall,
                          ),
                        ),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 30,
                          getTitlesWidget: (value, meta) => Text(
                            '${value.toInt() + 1}',
                            style: theme.textTheme.bodySmall,
                          ),
                        ),
                      ),
                      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    ),
                    borderData: FlBorderData(show: false),
                    lineBarsData: [
                      LineChartBarData(
                        isCurved: true,
                        curveSmoothness: 0.3,
                        spots: [
                          for (int i = 0; i < _weights.length; i++)
                            FlSpot(i.toDouble(), _weights[i]),
                        ],
                        color: theme.colorScheme.primary,
                        barWidth: 4,
                        dotData: FlDotData(
                          show: true,
                          getDotPainter: (spot, percent, barData, index) =>
                              FlDotCirclePainter(
                            radius: 6,
                            color: Colors.white,
                            strokeWidth: 3,
                            strokeColor: theme.colorScheme.primary,
                          ),
                        ),
                        belowBarData: BarAreaData(
                          show: true,
                          color: theme.colorScheme.primary.withOpacity(0.1),
                        ),
                      ),
                    ],
                  ),
                ),
        ),

        if (_weights.isNotEmpty) ...[
          const SizedBox(height: 16),
          _buildWeightStats(theme),
        ],
      ],
    );
  }

  Widget _buildStrengthSection(ThemeData theme) {
    return Column(
      children: [
        _buildSectionCard(
          title: "Strength Progress",
          icon: Icons.fitness_center_rounded,
          theme: theme,
          children: [
            const Text(
              'How did your last workout feel?',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildDifficultyButton('Easier', Icons.trending_down_rounded, Colors.green, -1, theme),
                _buildDifficultyButton('Same', Icons.remove_rounded, Colors.blue, 0, theme),
                _buildDifficultyButton('Harder', Icons.trending_up_rounded, Colors.red, 1, theme),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 200,
              child: _strengthTrend.isEmpty
                  ? _buildEmptyChart('No strength data yet', 'Record how your workouts feel')
                  : LineChart(
                      LineChartData(
                        gridData: FlGridData(
                          show: true,
                          drawVerticalLine: false,
                          getDrawingHorizontalLine: (value) => FlLine(
                            color: theme.dividerColor,
                            strokeWidth: 1,
                          ),
                        ),
                        titlesData: FlTitlesData(
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 40,
                              getTitlesWidget: (value, meta) {
                                switch (value.toInt()) {
                                  case -1: return Text('Easier', style: theme.textTheme.bodySmall);
                                  case 0: return Text('Same', style: theme.textTheme.bodySmall);
                                  case 1: return Text('Harder', style: theme.textTheme.bodySmall);
                                  default: return const Text('');
                                }
                              },
                            ),
                          ),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 30,
                              getTitlesWidget: (value, meta) => Text(
                                '${value.toInt() + 1}',
                                style: theme.textTheme.bodySmall,
                              ),
                            ),
                          ),
                          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        ),
                        borderData: FlBorderData(show: false),
                        minY: -1.5,
                        maxY: 1.5,
                        lineBarsData: [
                          LineChartBarData(
                            isCurved: true,
                            spots: [
                              for (int i = 0; i < _strengthTrend.length; i++)
                                FlSpot(i.toDouble(), _strengthTrend[i].toDouble()),
                            ],
                            color: theme.colorScheme.secondary,
                            barWidth: 4,
                            dotData: FlDotData(
                              show: true,
                              getDotPainter: (spot, percent, barData, index) =>
                                  FlDotCirclePainter(
                                radius: 6,
                                color: Colors.white,
                                strokeWidth: 3,
                                strokeColor: theme.colorScheme.secondary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
            ),
          ],
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildActivitySection(ThemeData theme) {
    return Column(
      children: [
        _buildSectionCard(
          title: "Activity Heatmap",
          icon: Icons.calendar_view_month_rounded,
          theme: theme,
          children: [
            SizedBox(
              height: 120,
              child: _buildActivityHeatmap(theme),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _buildSectionCard(
          title: "Activity Stats",
          icon: Icons.local_fire_department_rounded,
          theme: theme,
          children: [
            Row(
              children: [
                Expanded(child: _buildStatCard('Total Workouts', '${_workoutDates.length}', Icons.fitness_center_rounded, Colors.orange, theme)),
                const SizedBox(width: 12),
                Expanded(child: _buildStatCard('This Week', '$_weeklyWorkouts', Icons.calendar_view_week_rounded, Colors.blue, theme)),
                const SizedBox(width: 12),
                Expanded(child: _buildStatCard('This Month', '$_monthlyWorkouts', Icons.calendar_month_rounded, Colors.green, theme)),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _recordWorkout,
              icon: const Icon(Icons.add_circle_outline),
              label: const Text('Log Workout'),
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: Colors.white,
                minimumSize: const Size.fromHeight(50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildBodySection(ThemeData theme) {
    return Column(
      children: [
        _buildSectionCard(
          title: "Body Composition",
          icon: Icons.person_pin_rounded,
          theme: theme,
          children: [
            SizedBox(
              height: 250,
              child: RadarChart(
                RadarChartData(
                  dataSets: [
                    RadarDataSet(
                      fillColor: theme.colorScheme.primary.withOpacity(0.2),
                      borderColor: theme.colorScheme.primary,
                      dataEntries: [
                        const RadarEntry(value: 3),
                        const RadarEntry(value: 4),
                        const RadarEntry(value: 3.5),
                        const RadarEntry(value: 4.2),
                        const RadarEntry(value: 3.8),
                      ],
                    ),
                  ],
                  radarShape: RadarShape.polygon,
                  tickCount: 5,
                  titleTextStyle: theme.textTheme.bodySmall ?? const TextStyle(),
                  getTitle: (index, angle) {
                    const titles = ['Strength', 'Cardio', 'Flexibility', 'Endurance', 'Balance'];
                    return RadarChartTitle(text: titles[index], angle: angle);
                  },
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _buildSectionCard(
          title: "Body Metrics",
          icon: Icons.analytics_rounded,
          theme: theme,
          children: [
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              childAspectRatio: 1.2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              children: _bodyMetrics.entries.map((entry) {
                final colors = [Colors.blue, Colors.green, Colors.orange, Colors.purple];
                final index = _bodyMetrics.keys.toList().indexOf(entry.key);
                final color = colors[index % colors.length];
                
                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: color.withOpacity(0.3)),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        entry.key.contains('BMR') ? '${entry.value.toInt()}' : '${entry.value}%',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: color,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        entry.key,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: color.withOpacity(0.8),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildActivityHeatmap(ThemeData theme) {
    const daysInMonth = 30;
    final today = DateTime.now();
    
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        childAspectRatio: 1,
        crossAxisSpacing: 2,
        mainAxisSpacing: 2,
      ),
      itemCount: daysInMonth,
      itemBuilder: (context, index) {
        final date = today.subtract(Duration(days: daysInMonth - index - 1));
        final hasWorkout = _workoutDates.any((d) =>
            d.year == date.year && d.month == date.month && d.day == date.day);
        
        return Container(
          decoration: BoxDecoration(
            color: hasWorkout
                ? theme.colorScheme.primary
                : theme.dividerColor.withOpacity(0.3),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Center(
            child: Text(
              '${date.day}',
              style: TextStyle(
                fontSize: 10,
                color: hasWorkout ? Colors.white : theme.textTheme.bodySmall?.color,
                fontWeight: hasWorkout ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _recordWorkout() async {
    final today = DateTime.now();
    setState(() {
      _workoutDates.add(today);
    });

    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      "workoutDates",
      _workoutDates.map((e) => e.toIso8601String()).toList(),
    );
  }

  Widget _buildWeightStats(ThemeData theme) {
    final current = _weights.last;
    final initial = _weights.first;
    final change = current - initial;
    final changeColor = change > 0 ? Colors.red : change < 0 ? Colors.green : Colors.grey;

    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            'Current',
            '${current.toStringAsFixed(1)} kg',
            Icons.monitor_weight_rounded,
            theme.colorScheme.primary,
            theme,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            'Change',
            '${change >= 0 ? '+' : ''}${change.toStringAsFixed(1)} kg',
            change > 0 ? Icons.trending_up : change < 0 ? Icons.trending_down : Icons.trending_flat,
            changeColor,
            theme,
          ),
        ),
      ],
    );
  }

  Widget _buildDifficultyButton(String label, IconData icon, Color color, int value, ThemeData theme) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: ElevatedButton.icon(
          onPressed: () => _recordDifficulty(value),
          icon: Icon(icon, size: 20),
          label: Text(label),
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ),
    );
  }

  Future<void> _recordDifficulty(int value) async {
    setState(() {
      _strengthTrend.add(value);
    });

    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      "strengthTrend",
      _strengthTrend.map((e) => e.toString()).toList(),
    );

    final difficultyText = value == -1 ? 'easier' : value == 0 ? 'same difficulty' : 'harder';
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Workout felt $difficultyText - recorded!'),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  Widget _buildEmptyChart(String title, String subtitle) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.show_chart_rounded, size: 48, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            title,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.grey[600]),
          ),
          const SizedBox(height: 4),
          Text(subtitle, style: TextStyle(fontSize: 14, color: Colors.grey[500])),
        ],
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required ThemeData theme,
    required List<Widget> children,
  }) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: theme.colorScheme.primary, size: 20),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ...children,
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            title,
            style: theme.textTheme.bodySmall?.copyWith(
              color: color.withOpacity(0.7),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}