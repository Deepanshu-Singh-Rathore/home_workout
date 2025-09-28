// screens/workout_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '../models/workout.dart';

class WorkoutDetailScreen extends StatefulWidget {
  final Workout workout;
  final VoidCallback? onAdd;
  final bool added;

  const WorkoutDetailScreen({
    super.key,
    required this.workout,
    this.onAdd,
    this.added = false,
  });

  @override
  State<WorkoutDetailScreen> createState() => _WorkoutDetailScreenState();
}

class _WorkoutDetailScreenState extends State<WorkoutDetailScreen>
    with TickerProviderStateMixin {
  VideoPlayerController? _controller;
  bool _initialized = false;
  bool _isPlaying = false;
  double _difficulty = 2.0; // 1-5 scale (Easy to Hard)

  late AnimationController _heroController;
  late AnimationController _contentController;
  late Animation<double> _heroAnimation;
  late Animation<double> _contentAnimation;
  late Animation<Offset> _slideAnimation;

  final Map<int, String> _difficultyLabels = {
    1: 'Very Easy',
    2: 'Easy',
    3: 'Moderate',
    4: 'Hard',
    5: 'Very Hard',
  };

  final Map<int, Color> _difficultyColors = {
    1: Colors.green,
    2: Colors.lightGreen,
    3: Colors.orange,
    4: Colors.deepOrange,
    5: Colors.red,
  };

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _setupVideo();
  }

  void _setupAnimations() {
    _heroController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _contentController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _heroAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _heroController, curve: Curves.easeOut));

    _contentAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _contentController, curve: Curves.easeOut),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0.0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(parent: _contentController, curve: Curves.elasticOut),
        );

    _heroController.forward();
    Future.delayed(const Duration(milliseconds: 400), () {
      _contentController.forward();
    });
  }

  void _setupVideo() {
    // For demo purposes, using a placeholder. In real app, use widget.workout.videoUrl
    const demoVideoUrl =
        'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4';

    _controller = VideoPlayerController.networkUrl(Uri.parse(demoVideoUrl))
      ..setLooping(true)
      ..initialize()
          .then((_) {
            if (mounted) {
              setState(() => _initialized = true);
            }
          })
          .catchError((error) {
            debugPrint('Video initialization error: $error');
            // Fallback for demo - just show placeholder
            if (mounted) {
              setState(() => _initialized = false);
            }
          });
  }

  @override
  void dispose() {
    _heroController.dispose();
    _contentController.dispose();
    _controller?.dispose();
    super.dispose();
  }

  void _togglePlayPause() {
    if (_controller != null && _initialized) {
      setState(() {
        if (_isPlaying) {
          _controller!.pause();
        } else {
          _controller!.play();
        }
        _isPlaying = !_isPlaying;
      });
    }
  }

  String _getDifficultyLabel() {
    return _difficultyLabels[_difficulty.round()] ?? 'Moderate';
  }

  Color _getDifficultyColor() {
    return _difficultyColors[_difficulty.round()] ?? Colors.orange;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: CustomScrollView(
        slivers: [
          // Enhanced app bar with video
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            backgroundColor: theme.colorScheme.primary,
            flexibleSpace: FlexibleSpaceBar(
              background: FadeTransition(
                opacity: _heroAnimation,
                child: _buildVideoSection(theme),
              ),
            ),
            leading: Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.3),
                borderRadius: BorderRadius.circular(12),
              ),
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            actions: [
              Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: IconButton(
                  icon: const Icon(Icons.share, color: Colors.white),
                  onPressed: () => _showShareDialog(theme),
                ),
              ),
            ],
          ),

          // Content sections
          SliverToBoxAdapter(
            child: SlideTransition(
              position: _slideAnimation,
              child: FadeTransition(
                opacity: _contentAnimation,
                child: _buildContent(theme),
              ),
            ),
          ),
        ],
      ),

      // Enhanced floating action button
      floatingActionButton: FadeTransition(
        opacity: _contentAnimation,
        child: _buildActionButton(theme),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildVideoSection(ThemeData theme) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.black.withOpacity(0.3),
            Colors.black.withOpacity(0.7),
          ],
        ),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Video player or placeholder
          if (_initialized &&
              _controller != null &&
              _controller!.value.isInitialized)
            VideoPlayer(_controller!)
          else
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    theme.colorScheme.primary.withOpacity(0.8),
                    theme.colorScheme.secondary.withOpacity(0.6),
                  ],
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.play_circle_fill,
                      size: 80,
                      color: Colors.white.withOpacity(0.9),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Workout Preview',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),

          // Video controls overlay
          if (_initialized && _controller != null)
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Colors.black.withOpacity(0.3)],
                  ),
                ),
                child: Center(
                  child: GestureDetector(
                    onTap: _togglePlayPause,
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Icon(
                        _isPlaying ? Icons.pause : Icons.play_arrow,
                        size: 40,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),

          // Workout info overlay
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.workout.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        offset: Offset(0, 2),
                        blurRadius: 4,
                        color: Colors.black54,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.timer,
                            color: Colors.white,
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${widget.workout.durationMinutes} min',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: _getDifficultyColor().withOpacity(0.8),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.fitness_center,
                            color: Colors.white,
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            _getDifficultyLabel(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Difficulty Slider Section
          _buildSection(
            title: 'Difficulty Level',
            icon: Icons.tune_rounded,
            theme: theme,
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'How challenging is this workout for you?',
                            style: theme.textTheme.bodyLarge?.copyWith(
                              height: 1.4,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: _getDifficultyColor().withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: _getDifficultyColor().withOpacity(0.3),
                              ),
                            ),
                            child: Text(
                              _getDifficultyLabel(),
                              style: TextStyle(
                                color: _getDifficultyColor(),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    activeTrackColor: _getDifficultyColor(),
                    inactiveTrackColor: _getDifficultyColor().withOpacity(0.3),
                    thumbColor: _getDifficultyColor(),
                    overlayColor: _getDifficultyColor().withOpacity(0.2),
                    valueIndicatorColor: _getDifficultyColor(),
                    trackHeight: 6,
                  ),
                  child: Slider(
                    value: _difficulty,
                    min: 1,
                    max: 5,
                    divisions: 4,
                    label: _getDifficultyLabel(),
                    onChanged: (value) {
                      setState(() => _difficulty = value);
                    },
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Very Easy', style: theme.textTheme.bodySmall),
                    Text('Very Hard', style: theme.textTheme.bodySmall),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Description section
          _buildSection(
            title: 'About This Workout',
            icon: Icons.info_outline,
            theme: theme,
            child: Text(
              'This comprehensive ${widget.workout.title.toLowerCase()} targets multiple muscle groups and is designed to improve your overall fitness level. Perfect for both beginners and intermediate fitness enthusiasts looking to challenge themselves.\n\nThis workout includes warm-up exercises, main training sequences, and cool-down stretches to ensure a complete fitness experience. The exercises are carefully selected to maximize effectiveness while maintaining proper form.',
              style: theme.textTheme.bodyLarge?.copyWith(
                height: 1.6,
                color: theme.textTheme.bodyLarge?.color?.withOpacity(0.8),
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Benefits section
          _buildSection(
            title: 'Key Benefits',
            icon: Icons.star_outline,
            theme: theme,
            child: Column(
              children: [
                _buildBenefitItem(
                  'Builds strength and endurance',
                  Icons.fitness_center,
                  Colors.red,
                ),
                _buildBenefitItem(
                  'Improves cardiovascular health',
                  Icons.favorite,
                  Colors.pink,
                ),
                _buildBenefitItem(
                  'Enhances flexibility and mobility',
                  Icons.accessibility_new,
                  Colors.green,
                ),
                _buildBenefitItem(
                  'Boosts mental wellbeing',
                  Icons.psychology,
                  Colors.blue,
                ),
                _buildBenefitItem(
                  'Burns calories effectively',
                  Icons.local_fire_department,
                  Colors.orange,
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Equipment section
          _buildSection(
            title: 'Equipment Needed',
            icon: Icons.fitness_center_outlined,
            theme: theme,
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildEquipmentChip('No Equipment', Colors.green),
                _buildEquipmentChip('Exercise Mat (Optional)', Colors.blue),
                _buildEquipmentChip('Water Bottle', Colors.cyan),
                _buildEquipmentChip('Comfortable Clothes', Colors.purple),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Workout stats
          _buildSection(
            title: 'Workout Stats',
            icon: Icons.analytics_outlined,
            theme: theme,
            child: Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    'Duration',
                    '${widget.workout.durationMinutes}',
                    'minutes',
                    Icons.timer,
                    Colors.orange,
                    theme,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    'Difficulty',
                    _getDifficultyLabel(),
                    'level',
                    Icons.trending_up,
                    _getDifficultyColor(),
                    theme,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    'Calories',
                    '~${(widget.workout.durationMinutes * 8 * (_difficulty / 3)).round()}',
                    'burned',
                    Icons.local_fire_department,
                    Colors.red,
                    theme,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Instructions section
          _buildSection(
            title: 'Getting Started',
            icon: Icons.play_lesson_outlined,
            theme: theme,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInstructionStep(
                  1,
                  'Prepare Your Space',
                  'Clear a comfortable area with enough room to move around safely. Ensure good ventilation.',
                ),
                _buildInstructionStep(
                  2,
                  'Start with Warm-up',
                  'Begin with light movements to prepare your body for exercise and prevent injury.',
                ),
                _buildInstructionStep(
                  3,
                  'Follow the Video',
                  'Match the instructor\'s pace and focus on proper form rather than speed.',
                ),
                _buildInstructionStep(
                  4,
                  'Stay Hydrated',
                  'Take water breaks as needed and listen to your body throughout the workout.',
                ),
                _buildInstructionStep(
                  5,
                  'Cool Down',
                  'End with stretching to help your muscles recover and reduce soreness.',
                ),
              ],
            ),
          ),

          // Bottom padding for floating button
          SafeArea(child: SizedBox(height: 16)),
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required IconData icon,
    required ThemeData theme,
    required Widget child,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: theme.colorScheme.primary, size: 20),
            ),
            const SizedBox(width: 12),
            Text(
              title,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        child,
      ],
    );
  }

  Widget _buildBenefitItem(String text, IconData icon, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 16),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEquipmentChip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
      ),
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    String unit,
    IconData icon,
    Color color,
    ThemeData theme,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            unit,
            style: theme.textTheme.bodySmall?.copyWith(
              color: color.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: theme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildInstructionStep(int step, String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: Text(
                '$step',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 14,
                    color: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.color?.withOpacity(0.7),
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(ThemeData theme) {
    if (widget.added) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.green,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.green.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.check_circle, color: Colors.white),
            SizedBox(width: 8),
            Text(
              'Added to Plan',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [theme.colorScheme.primary, theme.colorScheme.secondary],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.primary.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: FloatingActionButton.extended(
        onPressed: widget.onAdd,
        backgroundColor: Colors.transparent,
        elevation: 0,
        icon: const Icon(Icons.add_circle_outline, color: Colors.white),
        label: const Text(
          'Add to Plan',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  void _showShareDialog(ThemeData theme) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.share, color: theme.colorScheme.primary),
            const SizedBox(width: 8),
            const Text('Share Workout'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Share "${widget.workout.title}" with friends and motivate each other!',
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildShareOption(Icons.message, 'Message', Colors.green),
                _buildShareOption(Icons.email, 'Email', Colors.blue),
                _buildShareOption(Icons.copy, 'Copy Link', Colors.grey),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  Widget _buildShareOption(IconData icon, String label, Color color) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color),
        ),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(fontSize: 12, color: color)),
      ],
    );
  }
}
