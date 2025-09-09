import 'package:flutter/material.dart';
import '../models/workout.dart';

class PlanScreen extends StatelessWidget {
  final List<Workout> plan;
  final void Function(String) onRemove;

  const PlanScreen({Key? key, required this.plan, required this.onRemove})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('My Plan', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            Expanded(
              child: plan.isEmpty
                  ? Center(
                      child: Text(
                        'No workouts added yet',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    )
                  : ListView.separated(
                      itemCount: plan.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 8),
                      itemBuilder: (context, i) {
                        final w = plan[i];
                        return ListTile(
                          tileColor: Theme.of(context).cardColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          leading: const Icon(Icons.fitness_center, size: 28),
                          title: Text(
                            w.title,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          subtitle: Text(
                            '${w.durationMinutes} min',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete_outline),
                            onPressed: () => onRemove(w.id),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
