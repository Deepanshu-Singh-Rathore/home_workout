import 'workout.dart';

class Playlist {
  final String id;
  final String title;
  final List<Workout> workouts;

  Playlist({required this.id, required this.title, required this.workouts});
}
