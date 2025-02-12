import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../features/data/models/exercise_model.dart';
import '../features/data/data_sources/exercise_data.dart';

class ExerciseProvider with ChangeNotifier {
  List<Exercise> _exercises = [];

  List<Exercise> get exercises => _exercises;

  ExerciseProvider() {
    // Initialize with default exercises immediately
    _exercises = [...exercises]; // from exercise_data.dart
    loadExercises(); // Load any saved exercises
  }

  Future<void> loadExercises() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      List<String>? storedExercises = prefs.getStringList('exercises');
      
      if (storedExercises != null) {
        final List<Exercise> loadedExercises = storedExercises
            .map((e) => Exercise.fromJson(jsonDecode(e)))
            .toList();
        _exercises = [...exercises, ...loadedExercises]; // Combine default and saved exercises
      }
      notifyListeners();
    } catch (e) {
      _exercises = [...exercises];
      print('Error loading exercises: $e');
    }
  }

  void addExercise(Exercise newExercise) {
    _exercises.add(newExercise);
    saveExercises();
    notifyListeners();
  }

  void updateExercise(int index, Exercise updatedExercise) {
    _exercises[index] = updatedExercise;
    // saveExercises();
    notifyListeners();
  }

  void deleteExercise(int index) {
    _exercises.removeAt(index);
    // saveExercises();
    notifyListeners();
  }

  Future<void> saveExercises() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      // Only save user-added exercises (not the default ones)
      final userExercises = _exercises.where((e) => !e.isAssetImage).toList();
      List<String> jsonList = userExercises
          .map((e) => jsonEncode(e.toJson()))
          .toList();
      await prefs.setStringList('exercises', jsonList);
    } catch (e) {
      print('Error saving exercises: $e');
    }
  }
}
