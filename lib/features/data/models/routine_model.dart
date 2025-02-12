import 'package:work_out_app/features/data/models/exercise_model.dart';

/// Represents a workout routine with exercises and target muscles.
/// 
/// A [Routine] contains:
/// - Unique identifier
/// - Name of the routine
/// - List of exercises included
/// - List of target muscle groups
/// - Optional image URL
class Routine {
  final String id;
  final String name;
  final List<Exercise> exercises;
  final List<String> targetMuscles;
  final String? imageUrl;
  final Map<String, Map<String, int>> exerciseConfigs;

  Routine({
    required this.id,
    required this.name,
    required this.exercises,
    required this.targetMuscles,
    this.imageUrl,
    required this.exerciseConfigs
  });
} 