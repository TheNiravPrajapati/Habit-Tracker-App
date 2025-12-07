import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../providers/habit_provider.dart';

class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<HabitProvider>(context);
    final habits = provider.habits;

    int total = 0;
    int streak = 0;
    List<int> weekly = List.filled(7, 0);

    for (var h in habits) {
      total += h.completedDates.length;
      if (h.streak > streak) streak = h.streak;

      for (var iso in h.completedDates) {
        final dt = DateTime.parse(iso);
        weekly[dt.weekday - 1]++;
      }
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Statistics")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _statsRow(total, streak),
            const SizedBox(height: 20),
            _weeklyBarChart(weekly),
            const SizedBox(height: 20),
            _monthlyPieChart(),
          ],
        ),
      ),
    );
  }

  Widget _statsRow(int total, int streak) {
    return Row(
      children: [
        Expanded(child: _statCard("Total", "$total")),
        const SizedBox(width: 16),
        Expanded(child: _statCard("Best Streak", "$streak days")),
      ],
    );
  }

  Widget _statCard(String title, String value) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: [Colors.teal.shade300, Colors.teal.shade600],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(color: Colors.white70, fontSize: 16)),
          const SizedBox(height: 8),
          Text(value,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _weeklyBarChart(List<int> values) {
    return SizedBox(
      height: 200,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          borderData: FlBorderData(show: false),
          barGroups: List.generate(values.length, (i) {
            return BarChartGroupData(x: i, barRods: [
              BarChartRodData(
                toY: values[i].toDouble(),
                color: Colors.teal,
                width: 18,
                borderRadius: BorderRadius.circular(8),
              )
            ]);
          }),
        ),
      ),
    );
  }

  Widget _monthlyPieChart() {
    return SizedBox(
      height: 220,
      child: PieChart(
        PieChartData(
          sections: [
            PieChartSectionData(
              color: Colors.teal,
              value: 40,
              title: "40%",
              radius: 60,
              titleStyle:
              const TextStyle(color: Colors.white, fontSize: 14),
            ),
            PieChartSectionData(
              color: Colors.orange,
              value: 30,
              title: "30%",
              radius: 60,
              titleStyle:
              const TextStyle(color: Colors.white, fontSize: 14),
            ),
            PieChartSectionData(
              color: Colors.blue,
              value: 30,
              title: "30%",
              radius: 60,
              titleStyle:
              const TextStyle(color: Colors.white, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
