import 'package:flutter/material.dart';
import '../models/workout.dart';
import '../models/playlist.dart';
import '../widgets/workout_card.dart';

class SearchScreen extends StatefulWidget {
  final List<Workout> workouts;
  final List<Workout> plan;
  final void Function(Workout) onAdd;
  final void Function(Playlist) onAddPlaylist;

  const SearchScreen({
    super.key,
    required this.workouts,
    required this.onAdd,
    required this.plan,
    required this.onAddPlaylist,
  });

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String _query = '';

  late List<Playlist> playlists;

  @override
  void initState() {
    super.initState();

    playlists = [
      Playlist(
        id: 'p1',
        title: '5 Day Full Body Plan',
        workouts: widget.workouts.take(5).toList(),
      ),
      Playlist(
        id: 'p2',
        title: '6 Day Split Plan',
        workouts: widget.workouts.take(6).toList(),
      ),
      Playlist(
        id: 'p3',
        title: 'Popular Home Workouts',
        workouts: widget.workouts,
      ),
    ];
  }

  bool _isWorkoutInPlan(Workout w) {
    return widget.plan.any((p) => p.id == w.id);
  }

  bool _isPlaylistInPlan(Playlist p) {
    return p.workouts.every((w) => _isWorkoutInPlan(w));
  }

  @override
  Widget build(BuildContext context) {
    final filteredWorkouts = widget.workouts
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
              onChanged: (value) => setState(() => _query = value),
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              children: [
                const Text(
                  'Workout Playlists',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                ...playlists.map(
                  (playlist) => Card(
                    color: Theme.of(context).cardColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      title: Text(playlist.title),
                      subtitle: Text('${playlist.workouts.length} workouts'),
                      trailing: ElevatedButton(
                        onPressed: _isPlaylistInPlan(playlist)
                            ? null
                            : () => widget.onAddPlaylist(playlist),
                        child: Text(
                          _isPlaylistInPlan(playlist) ? 'Added' : 'Add All',
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Individual Workouts',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                if (filteredWorkouts.isEmpty)
                  const Padding(
                    padding: EdgeInsets.all(20),
                    child: Text('No workouts found.'),
                  )
                else
                  ...filteredWorkouts.map(
                    (w) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: WorkoutCard(
                        workout: w,
                        onAdd: _isWorkoutInPlan(w)
                            ? null
                            : () => widget.onAdd(w),
                        added: _isWorkoutInPlan(w),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Create your own plan feature coming soon'),
                  ),
                );
              },
              icon: const Icon(Icons.add),
              label: const Text('Create Your Own Plan'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
