import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '../models/workout.dart';
import '../config/app_theme.dart';

class WorkoutCard extends StatefulWidget {
  final Workout workout;
  final VoidCallback? onAdd;
  final bool added;

  const WorkoutCard({
    Key? key,
    required this.workout,
    this.onAdd,
    this.added = false,
  }) : super(key: key);

  @override
  State<WorkoutCard> createState() => _WorkoutCardState();
}

class _WorkoutCardState extends State<WorkoutCard> {
  VideoPlayerController? _controller;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    if (widget.workout.videoUrl.isNotEmpty) {
      _controller = VideoPlayerController.network(widget.workout.videoUrl)
        ..setLooping(true)
        ..setVolume(0.0)
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
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.kCardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 16 / 9,
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
              ),
              child: _initialized && _controller != null
                  ? VideoPlayer(_controller!)
                  : Container(
                      color: Colors.black12,
                      child: const Center(
                        child: Icon(
                          Icons.play_circle_fill,
                          size: 48,
                          color: Colors.white24,
                        ),
                      ),
                    ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.workout.title,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '${widget.workout.durationMinutes} min',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ],
                  ),
                ),
                widget.added
                    ? Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text('Added'),
                      )
                    : ElevatedButton(
                        onPressed: widget.onAdd,
                        child: const Text('Add'),
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
