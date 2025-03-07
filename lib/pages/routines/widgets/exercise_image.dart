import 'package:flutter/material.dart';
import 'package:work_out_app/features/data/models/exercise_model.dart';

class ExerciseImage extends StatelessWidget {
  final Exercise exercise;
  final double width;
  final double height;
  final BoxFit fit;

  const ExerciseImage({
    Key? key,
    required this.exercise,
    this.width = 56,
    this.height = 56,
    this.fit = BoxFit.cover,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: width,
        height: height,
        color: Colors.grey[900],
        child: _buildImage(),
      ),
    );
  }

  Widget _buildImage() {
    // Return default icon immediately if image path is empty or invalid
    if (exercise.image.isEmpty) {
      return _buildDefaultIcon();
    }

    return Image.asset(
      exercise.image,
      width: width,
      height: height,
      fit: fit,
      errorBuilder: (context, error, stackTrace) {
        // Return a default icon when image fails to load
        return _buildDefaultIcon();
      },
    );
  }

  Widget _buildDefaultIcon() {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(
        _getExerciseIcon(),
        color: Colors.grey[400],
        size: width * 0.6,
      ),
    );
  }

  IconData _getExerciseIcon() {
    // Return appropriate icon based on exercise category or equipment
    switch (exercise.category.toLowerCase()) {
      case 'cardio':
        return Icons.directions_run;
      case 'strength':
        return Icons.fitness_center;
      case 'stretching':
        return Icons.accessibility_new;
      case 'bodyweight':
        return Icons.accessibility_new;
      default:
        // Return icon based on equipment if category doesn't match
        switch (exercise.equipment.toLowerCase()) {
          case 'dumbbells':
            return Icons.fitness_center;
          case 'barbell':
            return Icons.fitness_center;
          case 'machine':
            return Icons.settings;
          case 'body weight':
          case 'none':
            return Icons.accessibility_new;
          default:
            return Icons.fitness_center;
        }
    }
  }
} 