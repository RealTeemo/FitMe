import 'package:flutter/material.dart';
import '../../../providers/exercise_provider.dart';
import '../../../features/data/models/exercise_model.dart';
import '../../../features/data/models/routine_model.dart';

class StartExerciseScreen extends StatelessWidget {
  final Routine routine;

  const StartExerciseScreen({super.key, required this.routine});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(routine.name),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(10),
              itemCount: routine.exercises.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(routine.exercises[index].name),
                  subtitle: Text(routine.exerciseConfigs[routine.exercises[index].id] != null ? "sets: ${routine.exerciseConfigs[routine.exercises[index].id]?['sets'].toString()??''}\nreps: ${routine.exerciseConfigs[routine.exercises[index].id]?['reps'].toString() ?? ''}" : ""),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
