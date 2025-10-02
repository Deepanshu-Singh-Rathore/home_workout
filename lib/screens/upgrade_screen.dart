import 'package:flutter/material.dart';
import '../config/app_theme.dart';

class UpgradeScreen extends StatelessWidget {
  const UpgradeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final plans = [
      {
        'title': 'Monthly',
        'price': '\$18',
        'icon': Icons.calendar_view_month,
        'recommended': false,
      },
      {
        'title': 'Yearly',
        'price': '\$99',
        'icon': Icons.calendar_today,
        'recommended': true,
      },
      {
        'title': 'Lifetime',
        'price': '\$149',
        'icon': Icons.star,
        'recommended': false,
      },
    ];

    return Scaffold(
      backgroundColor: AppTheme.darkBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Upgrade'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Choose Your Plan',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            ...plans.map((plan) => _buildPlanCard(context, plan)).toList(),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // TEMP: Go back to app
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith<Color>(
                  (states) => states.contains(MaterialState.pressed)
                      ? Colors.purple
                      : Colors.grey[800]!,
                ),
                foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                padding: MaterialStateProperty.all<EdgeInsets>(
                  const EdgeInsets.symmetric(vertical: 16),
                ),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
              child: const Text('Continue to App'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlanCard(BuildContext context, Map<String, dynamic> plan) {
    final isRecommended = plan['recommended'] as bool;
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        border: isRecommended
            ? Border.all(color: AppTheme.primaryPurple, width: 2)
            : null,
      ),
      child: ListTile(
        leading: Icon(
          plan['icon'],
          color: isRecommended ? AppTheme.primaryPurple : Colors.white,
          size: 32,
        ),
        title: Text(
          plan['title'],
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        subtitle: Text(
          plan['price'],
          style: TextStyle(
            color: isRecommended ? AppTheme.primaryPurple : Colors.white70,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: isRecommended
            ? Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.primaryPurple,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'Recommended',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            : null,
      ),
    );
  }
}
