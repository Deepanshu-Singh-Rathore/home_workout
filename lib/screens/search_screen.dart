import 'package:flutter/material.dart';
import '../models/workout.dart';
import '../widgets/workout_card.dart';

class SearchScreen extends StatefulWidget {
  final List<Workout> workouts;
  final List<Workout> plan;
  final void Function(Workout) onAdd;

  const SearchScreen({
    Key? key,
    required this.workouts,
    required this.onAdd,
    required this.plan,
  }) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final filtered = widget.workouts
        .where((w) => w.title.toLowerCase().contains(_query.toLowerCase()))
        .toList();

    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search exercises or workouts',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Theme.of(context).cardColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (v) => setState(() => _query = v),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              itemCount: filtered.length,
              itemBuilder: (context, i) {
                final w = filtered[i];
                final added = widget.plan.any((p) => p.id == w.id);
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: WorkoutCard(
                    workout: w,
                    onAdd: added ? null : () => widget.onAdd(w),
                    added: added,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
