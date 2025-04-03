import 'package:flutter/material.dart';
import 'package:work_out_app/features/data/models/routine_model.dart';
import 'package:work_out_app/features/data/models/exercise_model.dart';
import 'package:work_out_app/pages/routines/widgets/exercise_config_dialog.dart';
import 'package:work_out_app/features/data/data_sources/routine_data.dart';
import 'package:work_out_app/pages/routines/screens/start_exercise_screen.dart';
/// Displays detailed information about a specific workout routine.
/// 
/// Features:
/// - Shows exercise list with sets and reps
/// - Displays target muscle groups
/// - Shows workout statistics
/// - Allows configuring sets and reps for each exercise
/// - Provides start workout functionality
class RoutineDetailScreen extends StatefulWidget {
  final Routine routine;

  const RoutineDetailScreen({
    Key? key,
    required this.routine,
  }) : super(key: key);

  @override
  State<RoutineDetailScreen> createState() => _RoutineDetailScreenState();
}

class _RoutineDetailScreenState extends State<RoutineDetailScreen> {
  // Map to store exercise configurations
  Map<String, Map<String, int>> exerciseConfigs = {};
  final RoutineData routineData = RoutineData();
  @override
  void initState() {
    super.initState();
    // Initialize default configurations
    exerciseConfigs = Map.from(widget.routine.exerciseConfigs);
  }

  Future<void> _showExerciseConfig(Exercise exercise) async {
    final currentConfig = exerciseConfigs[exercise.id] ?? {'sets': 3, 'reps': 12};
    final result = await showDialog<Map<String, int>?>(
      context: context,
      builder: (context) => ExerciseConfigDialog(
        exercise: exercise,
        sets: currentConfig['sets']!,
        reps: currentConfig['reps']!,
      ),
    );

    if (!mounted) return;

    setState(() {
      if (result != null) {
        exerciseConfigs[exercise.id] = result;
        widget.routine.exerciseConfigs[exercise.id] = result;
        routineData.updateExerciseConfig(widget.routine.id.toString(), exercise.id, result);
      } else {
        if (exerciseConfigs.containsKey(exercise.id)) {
          exerciseConfigs.remove(exercise.id);
          widget.routine.exerciseConfigs.remove(exercise.id);
          routineData.updateExerciseConfig(widget.routine.id.toString(), exercise.id, {});
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(widget.routine.name),
        actions: [
          TextButton.icon(
            onPressed: () {
              // TODO: Implement start workout
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => StartExerciseScreen(
                    routine: widget.routine,
                  ),
                ),
              );
            },
            icon: const Icon(Icons.play_arrow),
            label: const Text('Start'),
            style: TextButton.styleFrom(
              foregroundColor: Colors.blue,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Working Muscles Section
              Row(
                children: [
                  Icon(Icons.fitness_center, size: 24),
                  SizedBox(width: 8),
                  Text(
                    'Working Muscles',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: widget.routine.targetMuscles.map((muscle) => Chip(
                  label: Text(muscle),
                  backgroundColor: Colors.grey[800],
                )).toList(),
              ),

              // Exercises Section
              SizedBox(height: 24),
              Row(
                children: [
                  Icon(Icons.format_list_numbered, size: 24),
                  SizedBox(width: 8),
                  Text(
                    'Exercises (${widget.routine.exercises.length})',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(height: 16),
              // Constrain the height of the ListView
              SizedBox(
                height: 250, // Adjust this height based on item size and desired look (approx 3 items)
                child: ListView.builder(
                  // Remove shrinkWrap and physics to allow internal scrolling
                  // shrinkWrap: true, 
                  // physics: NeverScrollableScrollPhysics(), 
                  itemCount: widget.routine.exercises.length,
                  itemBuilder: (context, index) {
                    final exercise = widget.routine.exercises[index];
                    return Card(
                      margin: EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        leading: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.grey[800],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: Text(
                              '${index + 1}',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        title: Text(exercise.name),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${exercise.muscleGroup} • ${exercise.equipment}',
                              style: TextStyle(color: Colors.grey),
                            ),
                            if (exerciseConfigs[exercise.id] != null)
                              Text(
                                '${exerciseConfigs[exercise.id]!['sets']} sets × ${exerciseConfigs[exercise.id]!['reps']} reps',
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                          ],
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () => _showExerciseConfig(exercise),
                        ),
                        onTap: () => _showExerciseConfig(exercise),
                      ),
                    );
                  },
                ),
              ),

              // Stats Section
              SizedBox(height: 24),
              Row(
                children: [
                  Icon(Icons.bar_chart, size: 24),
                  SizedBox(width: 8),
                  Text(
                    'Workout Stats',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatCard('Exercises', widget.routine.exercises.length.toString()),
                  _buildStatCard('Est. Time', '${widget.routine.exercises.length * 3} min'),
                  _buildStatCard('Difficulty', 'Medium'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(String label, String value) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
