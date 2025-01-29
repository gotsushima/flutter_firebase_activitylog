import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/activity.dart';
import '../utils/colors.dart';
import '../utils/icons.dart';
import '../widgets/activity_card.dart';
import '../widgets/activity_type_icon.dart';
import '../screens/stats_screen.dart';
import '../services/firebase_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Activity> activities = [];
  ActivityType? selectedType;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController commentController = TextEditingController();
  Evaluation? selectedEvaluation;
  DateTime selectedDate = DateTime.now();
  final FocusNode _dateFocusNode = FocusNode();
  ActivityType? filterType;
  final FirebaseService _firebaseService = FirebaseService();
  final ScrollController _scrollController = ScrollController();
  String? editingActivityId;

  @override
  void initState() {
    super.initState();
    _loadActivities();
  }

  Future<void> _loadActivities() async {
    try {
      final loadedActivities = await _firebaseService.getActivities();
      if (!mounted) return;
      setState(() {
        activities.clear();
        activities.addAll(loadedActivities);
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load activities: $e')),
      );
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
                  surface: const Color(0xFF1E2433),
                ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
      _dateFocusNode.unfocus();
    }
  }

  Future<void> _saveActivity() async {
    if (selectedType != null &&
        nameController.text.isNotEmpty &&
        selectedEvaluation != null) {
      try {
        final activity = Activity(
          id: editingActivityId,
          type: selectedType!,
          name: nameController.text,
          comment: commentController.text,
          evaluation: selectedEvaluation!,
          createdAt: selectedDate,
        );

        final savedActivity = editingActivityId != null
            ? await _firebaseService.updateActivity(activity)
            : await _firebaseService.createActivity(activity);

        if (!mounted) return;
        setState(() {
          if (editingActivityId != null) {
            final index =
                activities.indexWhere((a) => a.id == editingActivityId);
            if (index != -1) {
              activities[index] = savedActivity;
            }
          } else {
            activities.insert(0, savedActivity);
          }
          editingActivityId = null;
          selectedType = null;
          nameController.clear();
          commentController.clear();
          selectedEvaluation = null;
          selectedDate = DateTime.now();
        });
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save activity: $e')),
        );
      }
    }
  }

  Map<String, List<Activity>> _getFilteredActivities() {
    // 1. アクティビティをソート
    final sortedActivities = List<Activity>.from(activities)
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

    // 2. フィルタリング
    final filteredActivities = filterType == null
        ? sortedActivities
        : sortedActivities
            .where((activity) => activity.type == filterType)
            .toList();

    // 3. 日付でグループ化（月日のみ）
    final groupedActivities = <String, List<Activity>>{};
    String currentYear = '';

    for (var activity in filteredActivities) {
      final year = DateFormat('yyyy').format(activity.createdAt);
      final dateStr = DateFormat('MM/dd').format(activity.createdAt);

      // 年が変わったら年を表示
      if (year != currentYear) {
        currentYear = year;
        final yearKey = year;
        if (!groupedActivities.containsKey(yearKey)) {
          groupedActivities[yearKey] = [];
        }
      }

      // 月日でグループ化
      if (!groupedActivities.containsKey(dateStr)) {
        groupedActivities[dateStr] = [];
      }
      groupedActivities[dateStr]!.add(activity);
    }

    return groupedActivities;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Activity Log'),
        backgroundColor: Theme.of(context).colorScheme.surface,
        actions: [
          IconButton(
            icon: const Icon(Icons.bar_chart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => StatsScreen(activities: activities),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Activity Type Selection
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: ActivityType.values.map((type) {
                  return ActivityTypeIcon(
                    type: type,
                    selectedType: selectedType,
                    onTap: () => setState(() => selectedType = type),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),

              // Date Selection
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      focusNode: _dateFocusNode,
                      controller: TextEditingController(
                        text: DateFormat('yyyy/MM/dd').format(selectedDate),
                      ),
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.calendar_today,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        border: const OutlineInputBorder(),
                        labelStyle: TextStyle(color: Colors.white70),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white24),
                        ),
                      ),
                      readOnly: true,
                      onTap: () => _selectDate(context),
                      onSubmitted: (_) => _selectDate(context),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Name Input
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Title',
                  border: const OutlineInputBorder(),
                  labelStyle: TextStyle(color: Colors.white70),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white24),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Comment Input
              TextField(
                controller: commentController,
                decoration: InputDecoration(
                  labelText: 'Comment',
                  border: const OutlineInputBorder(),
                  labelStyle: TextStyle(color: Colors.white70),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white24),
                  ),
                ),
                maxLines: 1,
              ),
              const SizedBox(height: 12),

              // Evaluation Icons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: Evaluation.values.map((evaluation) {
                  return IconButton(
                    icon: Icon(
                      AppIcons.getEvaluationIcon(evaluation),
                      color: selectedEvaluation == evaluation
                          ? AppColors.getEvaluationColor(evaluation)
                          : Colors.white70,
                    ),
                    style: IconButton.styleFrom(
                      backgroundColor: selectedEvaluation == evaluation
                          ? AppColors.getEvaluationColor(evaluation)
                              .withAlpha(51)
                          : Colors.transparent,
                      padding: const EdgeInsets.all(12),
                    ),
                    onPressed: () =>
                        setState(() => selectedEvaluation = evaluation),
                  );
                }).toList(),
              ),
              const SizedBox(height: 12),

              // Save Button
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: double.infinity,
                height: 56,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: LinearGradient(
                    colors: [
                      Theme.of(context).colorScheme.primary,
                      Theme.of(context).colorScheme.secondary,
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color:
                          Theme.of(context).colorScheme.primary.withAlpha(77),
                      blurRadius: 12,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: _saveActivity,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    foregroundColor: Colors.white,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    'Save',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Filter Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // All filter
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          filterType = null;
                        });
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: filterType == null
                              ? Theme.of(context)
                                  .colorScheme
                                  .primary
                                  .withAlpha(51)
                              : Colors.white10,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: filterType == null
                                ? Theme.of(context).colorScheme.primary
                                : Colors.transparent,
                            width: 1.5,
                          ),
                        ),
                        child: Icon(
                          Icons.all_inclusive,
                          size: 20,
                          color: filterType == null
                              ? Theme.of(context).colorScheme.primary
                              : Colors.white70,
                        ),
                      ),
                    ),
                  ),
                  // Type filters
                  ...ActivityType.values.map((type) {
                    return ActivityTypeIcon(
                      type: type,
                      selectedType: filterType,
                      onTap: () {
                        setState(() {
                          filterType = filterType == type ? null : type;
                        });
                      },
                      showLabel: false,
                    );
                  }),
                ],
              ),
              const SizedBox(height: 16),

              // Activities List
              ...(_getFilteredActivities().entries.map(
                (entry) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 7),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.blue[900]!.withAlpha(51),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: Colors.blue[300]!.withAlpha(51),
                              width: 1,
                            ),
                          ),
                          child: Text(
                            entry.key,
                            style: TextStyle(
                              color: Colors.blue[100],
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      ...entry.value.map((activity) => ActivityCard(
                            activity: activity,
                            onEdit: () {
                              setState(() {
                                editingActivityId = activity.id;
                                selectedType = activity.type;
                                nameController.text = activity.name;
                                commentController.text = activity.comment;
                                selectedEvaluation = activity.evaluation;
                                selectedDate = activity.createdAt;
                              });
                              _scrollController.animateTo(
                                0,
                                duration: const Duration(milliseconds: 500),
                                curve: Curves.easeInOut,
                              );
                            },
                            onDelete: () async {
                              final scaffoldMessenger =
                                  ScaffoldMessenger.of(context);
                              try {
                                await _firebaseService
                                    .deleteActivity(activity.id!);
                                if (!mounted) return;
                                setState(() {
                                  activities
                                      .removeWhere((a) => a.id == activity.id);
                                });
                              } catch (e) {
                                if (!mounted) return;
                                scaffoldMessenger.showSnackBar(
                                  SnackBar(
                                      content: Text(
                                          'Failed to delete activity: $e')),
                                );
                              }
                            },
                          )),
                    ],
                  );
                },
              )),

              if (activities.isEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 32.0),
                  child: Center(
                    child: Text(
                      'No activities yet. Add some!',
                      style: TextStyle(color: Colors.white70),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _dateFocusNode.dispose();
    nameController.dispose();
    commentController.dispose();
    super.dispose();
  }
}
