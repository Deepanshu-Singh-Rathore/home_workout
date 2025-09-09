import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../config/app_theme.dart';

class ProgressChart extends StatelessWidget {
  const ProgressChart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.kCardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      height: 200,
      child: LineChart(
        LineChartData(
          gridData: FlGridData(show: false),
          titlesData: FlTitlesData(show: false),
          borderData: FlBorderData(show: false),
          lineBarsData: [
            LineChartBarData(
              spots: const [
                FlSpot(0, 2),
                FlSpot(1, 3.5),
                FlSpot(2, 4),
                FlSpot(3, 3),
                FlSpot(4, 5),
                FlSpot(5, 6.5),
                FlSpot(6, 7),
              ],
              isCurved: true,
              color: AppTheme.kAccentColor,
              barWidth: 3,
              belowBarData: BarAreaData(
                show: true,
                color: AppTheme.kAccentColor.withOpacity(0.2),
              ),
              dotData: FlDotData(show: false),
            ),
          ],
        ),
      ),
    );
  }
}
