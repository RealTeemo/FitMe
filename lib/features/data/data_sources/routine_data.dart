import 'package:work_out_app/features/data/models/routine_model.dart';

/// Manages the storage and retrieval of workout routines.
/// 
/// Uses the Singleton pattern to ensure a single source of truth for routine data.
/// Provides methods to:
/// - Add new routines
/// - Update existing routines
/// - Delete routines
/// - Find routines by ID
class RoutineData {
  static final RoutineData _instance = RoutineData._internal();
  factory RoutineData() => _instance;
  RoutineData._internal();

  // In-memory storage for routines
  final List<Routine> _routines = [];

  // Get all routines
  List<Routine> get routines => List.unmodifiable(_routines);

  // Add a new routine
  void addRoutine(Routine routine) {
    _routines.add(routine);
  }

  // Update existing routine
  void updateRoutine(Routine updatedRoutine) {
    final index = _routines.indexWhere((r) => r.id == updatedRoutine.id);
    if (index >= 0) {
      _routines[index] = updatedRoutine;
    }
  }

  // Delete routine
  void deleteRoutine(String routineId) {
    _routines.removeWhere((r) => r.id == routineId);
  }

  // Find routine by ID
  Routine? findRoutineById(String id) {
    try {
      return _routines.firstWhere((r) => r.id == id);
    } catch (e) {
      return null;
    }
  }

  // update exercise config
  // update exercise config for a specific exercise e.g. reps, sets, weight
  void updateExerciseConfig(String routineId, String exerciseId, Map<String, int> config) {
    final routine = findRoutineById(routineId);
    if (routine != null) {
      routine.exerciseConfigs[exerciseId] = config;
    }
  }
  
}
