import 'package:flutter/material.dart';
import '../config/app_theme.dart';
import '../widgets/stat_card.dart';
import '../widgets/quick_action.dart';
import '../widgets/progress_chart.dart'; // 👈 new import

class HomeScreen extends StatelessWidget {
  final VoidCallback? onStart;
  const HomeScreen({Key? key, this.onStart}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Greeting + avatar
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Good morning, Deepanshu',
                      style: theme.textTheme.titleLarge,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Ready for a workout?',
                      style: theme.textTheme.titleMedium,
                    ),
                  ],
                ),
                CircleAvatar(
                  radius: 26,
                  backgroundColor: AppTheme.kCardColor,
                  child: const Icon(Icons.person, color: AppTheme.kAccentColor),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Stats
            Row(
              children: const [
                Expanded(
                  child: StatCard(title: 'BMI', value: '22.4'),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: StatCard(title: 'Weekly', value: '3 workouts'),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: StatCard(title: 'Calories', value: '420 kcal'),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // CTA Button
            ElevatedButton.icon(
              onPressed: onStart,
              icon: const Icon(Icons.play_circle_fill),
              label: const Padding(
                padding: EdgeInsets.symmetric(vertical: 12.0),
                child: Text(
                  "Start Today's Workout",
                  style: TextStyle(fontSize: 16),
                ),
              ),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(48),
                elevation: 6,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 18),

            // Quick Actions
            Row(
              children: const [
                Expanded(
                  child: QuickAction(
                    icon: Icons.search,
                    label: 'Browse Workouts',
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: QuickAction(icon: Icons.star, label: 'Suggested'),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Progress Chart 👇
            Text('Progress Overview', style: theme.textTheme.titleLarge),
            const SizedBox(height: 12),
            const ProgressChart(),
          ],
        ),
      ),
    );
  }
}
