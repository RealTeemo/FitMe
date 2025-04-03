import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
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
  RoutineData._internal() {
    _loadRoutines();
  }

  static const String _storageKey = 'workout_routines';
  
  // In-memory storage for routines
  List<Routine> _routines = [];

  // Get all routines
  List<Routine> get routines => List.from(_routines);

  // Load routines from storage
  Future<void> _loadRoutines() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? routinesJson = prefs.getString(_storageKey);
      
      if (routinesJson != null) {
        final List<dynamic> decoded = jsonDecode(routinesJson);
        _routines = decoded.map((json) => Routine.fromJson(json)).toList();
      }
    } catch (e) {
      print('Error loading routines: $e');
      _routines = [];
    }
  }

  // Save routines to storage
  Future<void> _saveRoutines() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String routinesJson = jsonEncode(_routines.map((r) => r.toJson()).toList());
      await prefs.setString(_storageKey, routinesJson);
    } catch (e) {
      print('Error saving routines: $e');
      throw Exception('Failed to save routines: $e');
    }
  }

  // Add a new routine
  Future<void> addRoutine(Routine routine) async {
    try {
      _routines.add(routine);
      await _saveRoutines();
    } catch (e) {
      print('Error adding routine: $e');
      throw Exception('Failed to add routine: $e');
    }
  }

  // Update existing routine
  Future<void> updateRoutine(Routine updatedRoutine) async {
    try {
      final index = _routines.indexWhere((r) => r.id == updatedRoutine.id);
      if (index >= 0) {
        _routines[index] = updatedRoutine;
        await _saveRoutines();
      } else {
        throw Exception('Routine not found');
      }
    } catch (e) {
      print('Error updating routine: $e');
      throw Exception('Failed to update routine: $e');
    }
  }

  // Delete routine
  Future<void> deleteRoutine(String routineId) async {
    try {
      _routines.removeWhere((r) => r.id == routineId);
      await _saveRoutines();
    } catch (e) {
      print('Error deleting routine: $e');
      throw Exception('Failed to delete routine: $e');
    }
  }

  // Find routine by ID
  Routine? findRoutineById(String id) {
    try {
      return _routines.firstWhere((r) => r.id == id);
    } catch (e) {
      return null;
    }
  }

  // Update exercise config for a specific exercise
  Future<void> updateExerciseConfig(String routineId, String exerciseId, Map<String, int> config) async {
    try {
      final routine = findRoutineById(routineId);
      if (routine != null) {
        final updatedConfigs = Map<String, Map<String, int>>.from(routine.exerciseConfigs);
        updatedConfigs[exerciseId] = config;
        
        final updatedRoutine = Routine(
          id: routine.id,
          name: routine.name,
          notes: routine.notes,
          exercises: routine.exercises,
          targetMuscles: routine.targetMuscles,
          exerciseConfigs: updatedConfigs,
        );
        
        await updateRoutine(updatedRoutine);
      } else {
        throw Exception('Routine not found');
      }
    } catch (e) {
      print('Error updating exercise config: $e');
      throw Exception('Failed to update exercise config: $e');
    }
  }
}

