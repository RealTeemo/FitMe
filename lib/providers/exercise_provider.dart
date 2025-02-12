import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../features/data/models/exercise_model.dart';
import '../features/data/data_sources/exercise_data.dart';
import 'package:flutter/foundation.dart';

class ExerciseProvider with ChangeNotifier {
  List<Exercise> _exercises = [];

  List<Exercise> get exercises => _exercises;

  ExerciseProvider() {
    // Initialize with default exercises immediately
    _exercises = [...exercises]; // from exercise_data.dart
    loadExercises(); // Load any saved exercises
  }

  // Future<void> loadExercises() async {
  //   // try {
  //   //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   //   List<String>? storedExercises = prefs.getStringList('exercises');
      
  //   //   if (storedExercises != null) {
  //   //     final List<Exercise> loadedExercises = storedExercises
  //   //         .map((e) => Exercise.fromJson(jsonDecode(e)))
  //   //         .toList();
  //   //     _exercises = [...exercises, ...loadedExercises]; // Combine default and saved exercises
  //   //   }
  //   //   notifyListeners();
  //   // } catch (e) {
  //   //   _exercises = [...exercises];
  //   //   print('Error loading exercises: $e');
  //   // }
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   List<String>? storedData = prefs.getStringList('exercises');

  //   if (storedData != null) {
  //     _exercises = storedData.map((e) => Exercise.fromJson(jsonDecode(e))).toList();
  //   } else {
  //     _exercises = [...exercises]; // ✅ Load prebuilt exercises if no saved exercises exist
  //   }
  //   notifyListeners();
  // }

  Future<void> loadExercises() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  List<String>? storedData = prefs.getStringList('exercises');

  if (storedData != null) {
    List<Exercise> savedExercises = storedData.map((e) => Exercise.fromJson(jsonDecode(e))).toList();

    // ✅ Ensure prebuilt exercises are included if they are not in saved exercises
    for (var exercise in exercises) {
      if (!savedExercises.any((e) => e.id == exercise.id)) {
        savedExercises.insert(0, exercise);
      }
    }

    _exercises = savedExercises;
  } else {
    _exercises = [...exercises]; // ✅ Load prebuilt exercises if no saved exercises exist
  }

  notifyListeners();
}

  void initializeExercises(List<Exercise> initialExercises) {
    if (_exercises.isEmpty) {
      _exercises = List.from(initialExercises);
      notifyListeners();
    }
  }

  void addExercise(Exercise exercise) {
    _exercises.add(exercise);
    notifyListeners();
  }

  void removeExercise(Exercise exercise) {
    _exercises.remove(exercise);
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
