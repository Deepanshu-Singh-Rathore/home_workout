//lib/screens/search_screen.dart
import 'package:flutter/material.dart';
import '../models/workout.dart';
import '../config/app_theme.dart';
import '../models/playlist.dart';
import '../widgets/workout_card.dart';

class SearchScreen extends StatefulWidget {
  final List<Workout> workouts;
  final List<Workout> plan;
  final Function(Workout) onAdd;
  final Function(Playlist) onAddPlaylist;

  const SearchScreen({
    super.key,
    required this.workouts,
    required this.plan,
    required this.onAdd,
    required this.onAddPlaylist,
  });

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String _searchQuery = '';
  String _selectedCategory = 'All';

  final List<String> _categories = [
    'All',
    'Yoga',
    'Strength',
    'HIIT',
    'Cardio',
    'Pilates',
    'Stretching',
  ];

  final List<Workout> _recommendedWorkouts = [
    Workout(
      id: 'rec1',
      title: 'Morning Energy Flow',
      durationMinutes: 20,
      category: 'Yoga',
      thumbnailUrl: 'assets/thumbnails/yoga_morning.png',
      videoUrl: 'https://example.com/yoga_morning.mp4',
      difficulty: 2,
      equipmentNeeded: ['Yoga Mat'],
      description:
          'Start your day with this energizing yoga flow that combines gentle stretches with dynamic movements.',
    ),
    Workout(
      id: 'rec2',
      title: 'Quick HIIT Burn',
      durationMinutes: 15,
      category: 'HIIT',
      thumbnailUrl: 'assets/thumbnails/hiit_quick.png',
      videoUrl: 'https://example.com/hiit_quick.mp4',
      difficulty: 4,
      equipmentNeeded: ['None'],
      description:
          'High-intensity interval training to boost your metabolism and burn calories fast.',
    ),
    Workout(
      id: 'rec3',
      title: 'Upper Body Strength',
      durationMinutes: 25,
      category: 'Strength',
      thumbnailUrl: 'assets/thumbnails/strength_upper.png',
      videoUrl: 'https://example.com/strength_upper.mp4',
      difficulty: 3,
      equipmentNeeded: ['Dumbbells', 'Resistance Bands'],
      description:
          'Build upper body strength with this comprehensive workout targeting chest, back, shoulders, and arms.',
    ),
  ];

  List<Workout> get _filteredWorkouts {
    List<Workout> filtered = widget.workouts;

    if (_selectedCategory != 'All') {
      filtered = filtered
          .where((w) => w.category == _selectedCategory)
          .toList();
    }

    if (_searchQuery.isNotEmpty) {
      filtered = filtered
          .where(
            (w) => w.title.toLowerCase().contains(_searchQuery.toLowerCase()),
          )
          .toList();
    }

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.darkBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Search Workouts'),
      ),
      body: SafeArea(
        bottom: true,
        child: Column(
          children: [
            // Search bar
            Padding(
              padding: const EdgeInsets.all(24),
              child: TextField(
                onChanged: (value) => setState(() => _searchQuery = value),
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Search workouts...',
                  hintStyle: const TextStyle(color: Colors.white54),
                  prefixIcon: const Icon(Icons.search, color: Colors.white54),
                  filled: true,
                  fillColor: Colors.grey[800],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                ),
              ),
            ),

            // Category filters
            SizedBox(
              height: 50,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 24),
                itemCount: _categories.length,
                itemBuilder: (context, index) {
                  final category = _categories[index];
                  final isSelected = category == _selectedCategory;

                  return Container(
                    margin: const EdgeInsets.only(right: 12),
                    child: FilterChip(
                      label: Text(category),
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() => _selectedCategory = category);
                      },
                      backgroundColor: Colors.grey[800],
                      selectedColor: AppTheme.primaryPurple,
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.white : Colors.white70,
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide.none,
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 24),

            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.only(
                  left: 24,
                  right: 24,
                  bottom: MediaQuery.of(context).padding.bottom + 24,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Recommended section
                    const Text(
                      'Recommended for You',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),

                    SizedBox(
                      height: 200,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _recommendedWorkouts.length,
                        itemBuilder: (context, index) {
                          final workout = _recommendedWorkouts[index];
                          return Container(
                            width: 160,
                            margin: EdgeInsets.only(
                              right: index == _recommendedWorkouts.length - 1
                                  ? 0
                                  : 16,
                            ),
                            child: _buildWorkoutCard(
                              workout,
                              isRecommended: true,
                            ),
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 32),

                    // All workouts section
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'All Workouts',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${_filteredWorkouts.length} workouts',
                          style: const TextStyle(
                            color: Colors.white54,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Workout grid
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.75,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                          ),
                      itemCount: _filteredWorkouts.length,
                      itemBuilder: (context, index) {
                        final workout = _filteredWorkouts[index];
                        return _buildWorkoutCard(workout);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWorkoutCard(Workout workout, {bool isRecommended = false}) {
    final isAdded = widget.plan.any((w) => w.id == workout.id);

    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          '/workout-detail',
          arguments: {
            'workout': workout,
            'onAdd': widget.onAdd,
            'added': isAdded,
          },
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            children: [
              // Background image placeholder
              Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      _getCategoryColor(workout.category).withOpacity(0.8),
                      _getCategoryColor(workout.category),
                    ],
                  ),
                ),
                child: Icon(
                  _getCategoryIcon(workout.category),
                  size: 48,
                  color: Colors.white.withOpacity(0.3),
                ),
              ),

              // Gradient overlay
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
                  ),
                ),
              ),

              // Content
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (isRecommended)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryPurple,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Text(
                            'Recommended',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      if (isRecommended) const SizedBox(height: 8),

                      Text(
                        workout.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),

                      Row(
                        children: [
                          Icon(
                            Icons.access_time,
                            size: 14,
                            color: Colors.white70,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${workout.durationMinutes} min',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: isAdded
                                  ? AppTheme.successGreen
                                  : Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              isAdded ? Icons.check : Icons.add,
                              size: 16,
                              color: isAdded ? Colors.white : Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Yoga':
        return Colors.green;
      case 'Strength':
        return Colors.red;
      case 'HIIT':
        return Colors.orange;
      case 'Cardio':
        return Colors.blue;
      case 'Pilates':
        return Colors.purple;
      case 'Stretching':
        return Colors.teal;
      default:
        return AppTheme.primaryPurple;
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Yoga':
        return Icons.self_improvement;
      case 'Strength':
        return Icons.fitness_center;
      case 'HIIT':
        return Icons.flash_on;
      case 'Cardio':
        return Icons.favorite;
      case 'Pilates':
        return Icons.accessibility_new;
      case 'Stretching':
        return Icons.accessibility;
      default:
        return Icons.sports_gymnastics;
    }
  }
}
