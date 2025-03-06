import 'package:flutter/material.dart';
import 'package:work_out_app/features/data/models/routine_model.dart';
import 'package:work_out_app/features/data/data_sources/routine_data.dart';
import 'package:work_out_app/features/data/models/exercise_model.dart';

class RoutineProvider with ChangeNotifier {
  final RoutineData _routineData = RoutineData();
  List<Routine> _routines = []; // ✅ Store routines locally

  List<Routine> get routines => _routines; // ✅ Provide access to routines
  List<Exercise> selectedExercises = []; // ✅ Track selected exercises per routine

  RoutineProvider() {
    _loadRoutines(); // ✅ Load existing routines on startup
  }

  Future<void> _loadRoutines() async {
    _routines = _routineData.routines;
    notifyListeners();
  }

  Future<void> addRoutine(Routine routine) async {
    final newRoutine = Routine(
      id: routine.id,
      name: routine.name,
      notes: routine.notes,
      exercises: List.from(routine.exercises),
      targetMuscles: List.from(routine.targetMuscles),
      exerciseConfigs: Map.from(routine.exerciseConfigs),
    );

    _routines.add(newRoutine);
    await _routineData.addRoutine(newRoutine); // Persist to storage
    notifyListeners();
  }

  Future<void> deleteRoutine(String routineId) async {
    _routines.removeWhere((routine) => routine.id == routineId);
    await _routineData.deleteRoutine(routineId);
    notifyListeners();
  }

  Future<void> updateRoutine(Routine updatedRoutine) async {
    final index = _routines.indexWhere((r) => r.id == updatedRoutine.id);
    if (index != -1) {
      _routines[index] = updatedRoutine;
      await _routineData.updateRoutine(updatedRoutine);
      notifyListeners();
    }
  }

  // Routine? getRoutineById(String routineId) {
  //   return _routines.firstWhere((routine) => routine.id == routineId, orElse: () => null);
  // }

  void setSelectedExercises(List<Exercise> exercises) {
    selectedExercises = exercises;
    notifyListeners();
  }

  void clearSelectedExercises() {
    selectedExercises = [];
    notifyListeners();
  }

  List<Routine> getFilteredRoutines() {
    return _routines;
  }
}
