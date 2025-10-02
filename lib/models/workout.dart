//lib/models/workout.dart
class Workout {
  final String id;
  final String title;
  final int durationMinutes;
  final String category;
  final String thumbnailUrl;
  final String videoUrl;
  final int difficulty;
  final List<String> equipmentNeeded;
  final String? description;

  Workout({
    required this.id,
    required this.title,
    required this.durationMinutes,
    required this.category,
    required this.thumbnailUrl,
    required this.videoUrl,
    required this.difficulty,
    required this.equipmentNeeded,
    this.description,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'durationMinutes': durationMinutes,
      'category': category,
      'thumbnailUrl': thumbnailUrl,
      'videoUrl': videoUrl,
      'difficulty': difficulty,
      'equipmentNeeded': equipmentNeeded,
      'description': description,
    };
  }

  factory Workout.fromJson(Map<String, dynamic> json) {
    return Workout(
      id: json['id'],
      title: json['title'],
      durationMinutes: json['durationMinutes'],
      category: json['category'],
      thumbnailUrl: json['thumbnailUrl'],
      videoUrl: json['videoUrl'],
      difficulty: json['difficulty'],
      equipmentNeeded: List<String>.from(json['equipmentNeeded']),
      description: json['description'],
    );
  }
}
