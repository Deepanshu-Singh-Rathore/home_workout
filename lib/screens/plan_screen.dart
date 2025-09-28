//lib/screens/plan_screen.dart
import 'package:flutter/material.dart';
import '../models/workout.dart';

class PlanScreen extends StatefulWidget {
  final List<Workout> plan;
  final void Function(String) onRemove;

  const PlanScreen({super.key, required this.plan, required this.onRemove});

  @override
  State<PlanScreen> createState() => _PlanScreenState();
}

class _PlanScreenState extends State<PlanScreen> with TickerProviderStateMixin {
  late AnimationController _headerController;
  late AnimationController _listController;
  late Animation<double> _headerAnimation;
  late Animation<double> _listAnimation;

  String _selectedSort = 'Order Added';
  bool _showStats = true;

  final List<String> _sortOptions = [
    'Order Added',
    'Duration (Short to Long)',
    'Duration (Long to Short)',
    'Alphabetical',
  ];

  @override
  void initState() {
    super.initState();
    _setupAnimations();
  }

  void _setupAnimations() {
    _headerController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _listController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _headerAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _headerController, curve: Curves.easeOut),
    );

    _listAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _listController, curve: Curves.elasticOut),
    );

    _headerController.forward();
    Future.delayed(const Duration(milliseconds: 300), () {
      _listController.forward();
    });
  }

  @override
  void dispose() {
    _headerController.dispose();
    _listController.dispose();
    super.dispose();
  }

  List<Workout> get _sortedPlan {
    final plan = List<Workout>.from(widget.plan);

    switch (_selectedSort) {
      case 'Duration (Short to Long)':
        plan.sort((a, b) => a.durationMinutes.compareTo(b.durationMinutes));
        break;
      case 'Duration (Long to Short)':
        plan.sort((a, b) => b.durationMinutes.compareTo(a.durationMinutes));
        break;
      case 'Alphabetical':
        plan.sort((a, b) => a.title.compareTo(b.title));
        break;
      case 'Order Added':
      default:
        // Keep original order
        break;
    }

    return plan;
  }

  int get _totalDuration =>
      widget.plan.fold(0, (sum, w) => sum + w.durationMinutes);

  double get _averageDuration =>
      widget.plan.isEmpty ? 0 : _totalDuration / widget.plan.length;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final sortedPlan = _sortedPlan;

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Enhanced header
            SliverToBoxAdapter(
              child: FadeTransition(
                opacity: _headerAnimation,
                child: _buildHeader(theme),
              ),
            ),

            // Stats section
            if (_showStats && widget.plan.isNotEmpty)
              SliverToBoxAdapter(
                child: FadeTransition(
                  opacity: _headerAnimation,
                  child: _buildStatsSection(theme),
                ),
              ),

            // Empty state or workout list
            widget.plan.isEmpty
                ? SliverToBoxAdapter(child: _buildEmptyState(theme))
                : SliverAnimatedList(
                    initialItemCount: sortedPlan.length,
                    itemBuilder: (context, index, animation) {
                      return SlideTransition(
                        position:
                            Tween<Offset>(
                              begin: const Offset(1.0, 0.0),
                              end: Offset.zero,
                            ).animate(
                              CurvedAnimation(
                                parent: animation,
                                curve: Curves.elasticOut,
                              ),
                            ),
                        child: _buildWorkoutItem(
                          sortedPlan[index],
                          index,
                          theme,
                        ),
                      );
                    },
                  ),

            // Bottom actions
            if (widget.plan.isNotEmpty)
              SliverToBoxAdapter(child: _buildBottomActions(theme)),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            theme.colorScheme.primary.withOpacity(0.1),
            theme.colorScheme.secondary.withOpacity(0.05),
            Colors.transparent,
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      theme.colorScheme.primary,
                      theme.colorScheme.secondary,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: theme.colorScheme.primary.withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.fitness_center_rounded,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'My Workout Plan',
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (widget.plan.isNotEmpty)
                      Text(
                        '${widget.plan.length} workout${widget.plan.length == 1 ? '' : 's'}',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                  ],
                ),
              ),
              if (widget.plan.isNotEmpty)
                PopupMenuButton<String>(
                  icon: Icon(
                    Icons.sort_rounded,
                    color: theme.colorScheme.primary,
                  ),
                  onSelected: (value) => setState(() => _selectedSort = value),
                  itemBuilder: (context) => _sortOptions.map((option) {
                    return PopupMenuItem(
                      value: option,
                      child: Row(
                        children: [
                          Icon(
                            _selectedSort == option
                                ? Icons.check_circle
                                : Icons.radio_button_unchecked,
                            color: _selectedSort == option
                                ? theme.colorScheme.primary
                                : Colors.grey,
                            size: 20,
                          ),
                          const SizedBox(width: 12),
                          Text(option),
                        ],
                      ),
                    );
                  }).toList(),
                ),
            ],
          ),

          if (widget.plan.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Row(
                children: [
                  Expanded(
                    child: _buildQuickStat(
                      'Total Time',
                      '$_totalDuration min',
                      Icons.timer_rounded,
                      theme.colorScheme.primary,
                      theme,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildQuickStat(
                      'Average',
                      '${_averageDuration.round()} min',
                      Icons.trending_up_rounded,
                      theme.colorScheme.secondary,
                      theme,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildQuickStat(
    String label,
    String value,
    IconData icon,
    Color color,
    ThemeData theme,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsSection(ThemeData theme) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.insights_rounded,
                color: theme.colorScheme.primary,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Plan Overview',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              IconButton(
                icon: Icon(
                  _showStats ? Icons.expand_less : Icons.expand_more,
                  color: theme.colorScheme.primary,
                ),
                onPressed: () => setState(() => _showStats = !_showStats),
              ),
            ],
          ),

          if (_showStats) ...[
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    'Workouts',
                    '${widget.plan.length}',
                    Icons.fitness_center_rounded,
                    Colors.blue,
                    theme,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    'Est. Completion',
                    '${(_totalDuration / 60).ceil()}h ${_totalDuration % 60}m',
                    Icons.schedule_rounded,
                    Colors.green,
                    theme,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
    ThemeData theme,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            title,
            style: theme.textTheme.bodySmall?.copyWith(
              color: color.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(ThemeData theme) {
    return FadeTransition(
      opacity: _listAnimation,
      child: Container(
        padding: const EdgeInsets.all(40),
        child: Column(
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(50),
              ),
              child: Icon(
                Icons.fitness_center_outlined,
                size: 50,
                color: theme.colorScheme.primary.withOpacity(0.5),
              ),
            ),

            const SizedBox(height: 24),

            Text(
              'No Workouts Yet',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              ),
            ),

            const SizedBox(height: 12),

            Text(
              'Start building your personalized workout plan by adding exercises from the search page.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.grey[600],
              ),
            ),

            const SizedBox(height: 32),

            ElevatedButton.icon(
              onPressed: () {
                // Navigate to search
                DefaultTabController.of(context).animateTo(1);
              },
              icon: const Icon(Icons.search_rounded),
              label: const Text('Find Workouts'),
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWorkoutItem(Workout workout, int index, ThemeData theme) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Dismissible(
        key: Key(workout.id),
        direction: DismissDirection.endToStart,
        background: Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 20),
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Icon(
            Icons.delete_outline,
            color: Colors.white,
            size: 28,
          ),
        ),
        confirmDismiss: (direction) async {
          return await _showRemoveDialog(workout, theme);
        },
        onDismissed: (direction) {
          widget.onRemove(workout.id);
        },
        child: ListTile(
          contentPadding: const EdgeInsets.all(16),
          leading: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  theme.colorScheme.primary.withOpacity(0.8),
                  theme.colorScheme.secondary.withOpacity(0.6),
                ],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.fitness_center_rounded,
              color: Colors.white,
              size: 24,
            ),
          ),
          title: Text(
            workout.title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(Icons.timer_rounded, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Text(
                    '${workout.durationMinutes} minutes',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ],
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '#${index + 1}',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 8),
              Icon(Icons.drag_handle_rounded, color: Colors.grey[400]),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomActions(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _showClearAllDialog(theme),
                  icon: const Icon(Icons.clear_all_rounded),
                  label: const Text('Clear All'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red,
                    side: const BorderSide(color: Colors.red),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    _showStartWorkoutDialog(theme);
                  },
                  icon: const Icon(Icons.play_arrow_rounded),
                  label: const Text('Start Workout'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Future<bool?> _showRemoveDialog(Workout workout, ThemeData theme) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Remove Workout?'),
        content: Text(
          'Are you sure you want to remove "${workout.title}" from your plan?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Remove'),
          ),
        ],
      ),
    );
  }

  void _showClearAllDialog(ThemeData theme) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Clear All Workouts?'),
        content: const Text(
          'This will remove all workouts from your plan. This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              for (final workout in widget.plan) {
                widget.onRemove(workout.id);
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Clear All'),
          ),
        ],
      ),
    );
  }

  void _showStartWorkoutDialog(ThemeData theme) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Start Workout Session'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Ready to begin your workout? This feature will guide you through each exercise.',
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: theme.colorScheme.primary),
                  const SizedBox(width: 8),
                  const Expanded(child: Text('Workout timer coming soon!')),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Maybe Later'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.colorScheme.primary,
            ),
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }
}
