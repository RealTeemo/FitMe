import 'package:work_out_app/features/data/models/exercise_model.dart';

/// Represents a workout routine with exercises and target muscles.
/// 
/// A [Routine] contains:
/// - Unique identifier
/// - Name of the routine
/// - List of exercises included
/// - List of target muscle groups
/// - Optional notes for the routine
/// - Optional image URL
class Routine {
  final int? id;
  final String name;
  final List<Exercise> exercises;
  final List<String> targetMuscles;
  final String? imageUrl;
  final String? notes;
  final Map<String, Map<String, int>> exerciseConfigs;

  Routine({
    required this.id,
    required this.name,
    required this.exercises,
    required this.targetMuscles,
    this.imageUrl,
    this.notes,
    required this.exerciseConfigs
  });

  // Create a Routine from JSON data
  factory Routine.fromJson(Map<String, dynamic> json) {
    return Routine(
      id: json['id'] as int?,
      name: json['name'] as String,
      exercises: (json['exercises'] as List<dynamic>)
          .map((e) => Exercise.fromJson(e as Map<String, dynamic>))
          .toList(),
      targetMuscles: (json['targetMuscles'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      imageUrl: json['imageUrl'] as String?,
      notes: json['notes'] as String?,
      exerciseConfigs: (json['exerciseConfigs'] as Map<String, dynamic>).map(
        (key, value) => MapEntry(
          key,
          (value as Map<String, dynamic>).map(
            (k, v) => MapEntry(k, v as int),
          ),
        ),
      ),
    );
  }

  // Convert Routine to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'exercises': exercises.map((e) => e.toJson()).toList(),
      'targetMuscles': targetMuscles,
      'imageUrl': imageUrl,
      'notes': notes,
      'exerciseConfigs': exerciseConfigs.map(
        (key, value) => MapEntry(key, value),
      ),
    };
  }
} 