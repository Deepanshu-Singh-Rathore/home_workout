import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '../models/workout.dart';
import '../config/app_theme.dart';

class WorkoutDetailScreen extends StatefulWidget {
  final Workout workout;
  final VoidCallback? onAdd;
  final bool added;

  const WorkoutDetailScreen({
    Key? key,
    required this.workout,
    this.onAdd,
    this.added = false,
  }) : super(key: key);

  @override
  State<WorkoutDetailScreen> createState() => _WorkoutDetailScreenState();
}

class _WorkoutDetailScreenState extends State<WorkoutDetailScreen> {
  VideoPlayerController? _controller;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    if (widget.workout.videoUrl.isNotEmpty) {
      _controller = VideoPlayerController.network(widget.workout.videoUrl)
        ..setLooping(true)
        ..initialize().then((_) {
          setState(() => _initialized = true);
          _controller?.play();
        });
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.kBackgroundColor,
      appBar: AppBar(
        title: Text(widget.workout.title),
        backgroundColor: AppTheme.kCardColor,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: widget.workout.id,
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: _initialized && _controller != null
                      ? VideoPlayer(_controller!)
                      : Container(
                          color: Colors.black26,
                          child: const Center(
                            child: Icon(
                              Icons.play_circle_fill,
                              size: 64,
                              color: Colors.white38,
                            ),
                          ),
                        ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              widget.workout.title,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              '${widget.workout.durationMinutes} minutes',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 20),
            Text(
              "This is a sample description for the workout. You can replace it later with real instructions, benefits, and steps for the exercise.",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            widget.added
                ? Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text('Already in Plan'),
                  )
                : ElevatedButton.icon(
                    onPressed: widget.onAdd,
                    icon: const Icon(Icons.add),
                    label: const Text('Add to Plan'),
                  ),
          ],
        ),
      ),
    );
  }
}
