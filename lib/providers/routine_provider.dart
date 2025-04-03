import 'package:flutter/material.dart';
import 'package:work_out_app/features/data/models/routine_model.dart';
import 'package:work_out_app/features/data/data_sources/routine_data.dart';
import 'package:work_out_app/features/data/models/exercise_model.dart';
import 'package:work_out_app/features/service/database_helper.dart';

class RoutineProvider extends ChangeNotifier {
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
    await DatabaseHelper.insertRoutine(routine);
    notifyListeners();
  }

  Future<void> deleteRoutine(String routineId) async {
    final routine = _routines.firstWhere((r) => r.id == routineId);
    await DatabaseHelper.deleteRoutine(routine);
    notifyListeners();
  }

  Future<void> updateRoutine(Routine updatedRoutine) async {
    await DatabaseHelper.updateRoutine(updatedRoutine);
    notifyListeners();
    
  }

  // Routine? getRoutineById(String routineId) {
  //   return _routines.firstWhere((routine) => routine.id == routineId, orElse: () => null);
  // }

  void setSelectedExercises(List<Exercise> exercises) {
    selectedExercises = exercises;
    notifyListeners();
  }

  List<Routine> getFilteredRoutines() {
    return _routines;
  }
}
