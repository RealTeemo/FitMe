import 'package:flutter/material.dart';
import 'package:work_out_app/pages/exercise/screens/exercise_detail_screen.dart';
import 'package:work_out_app/features/data/models/exercise_model.dart';
import 'dart:io';
import 'package:provider/provider.dart';
import 'package:work_out_app/providers/exercise_provider.dart';

/// ExerciseList is a reusable widget that displays a scrollable list of exercises.
/// Features:
/// - Shows exercise image, name, and details
/// - Handles empty states with a message
/// - Navigates to detail screen on tap
class ExerciseList extends StatelessWidget {
  final List<Exercise> filteredExercises;

  ExerciseList({required this.filteredExercises});

  @override
  Widget build(BuildContext context) {
    // Show message when no exercises match the filters
    return filteredExercises.isEmpty
        ? const Center(
            child: Text(
              'No exercises match your filters',
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
          )
        // Build scrollable list of exercise cards
        : ListView.builder(
            itemExtent: 80,
            itemCount: filteredExercises.length,
            itemBuilder: (context, index) {
              final exercise = filteredExercises[index];
              return Card(
                margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                child: ListTile(
                  leading: _buildExerciseImage(exercise.image),
                  title: Text(exercise.name),
                  subtitle: Text('${exercise.muscleGroup} • ${exercise.equipment}'),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    // Navigate to detail screen when exercise is tapped
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ExerciseDetailScreen(exercise: exercise),
                      ),
                    );
                  },
                ),
              );
            },
          );
  }

  Widget _buildExerciseImage(String imagePath) {
    try {
      return imagePath.startsWith('assets/')
          ? Image.asset(
              imagePath,
              width: 50,
              height: 50,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Icon(Icons.fitness_center),
            )
          : Image.file(
              File(imagePath),
              width: 50,
              height: 50,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Icon(Icons.fitness_center),
            );
    } catch (e) {
      return Icon(Icons.fitness_center);
    }
  }
}
