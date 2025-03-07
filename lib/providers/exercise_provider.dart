import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../features/data/models/exercise_model.dart';
import '../features/data/data_sources/exercise_data.dart';
import 'package:flutter/foundation.dart';

class ExerciseProvider with ChangeNotifier {
  List<Exercise> _exercises = [];
  String _searchQuery = '';
  String? _selectedCategory;
  String? _selectedMuscle;
  String? _selectedEquipment;

  // Getters
  List<Exercise> get exercises => _exercises;
  String get searchQuery => _searchQuery;
  String? get selectedCategory => _selectedCategory;
  String? get selectedMuscle => _selectedMuscle;
  String? get selectedEquipment => _selectedEquipment;

  ExerciseProvider() {
    // Initialize with default exercises immediately
    _exercises = [...exercises]; // from exercise_data.dart
    loadExercises(); // Load any saved exercises
  }

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

  void setSearchQuery(String query) {
    _searchQuery = query.trim();
    notifyListeners();
  }

  void setCategory(String? category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void setMuscleGroup(String? muscle) {
    _selectedMuscle = muscle;
    notifyListeners();
  }

  void setEquipment(String? equipment) {
    _selectedEquipment = equipment;
    notifyListeners();
  }

  List<Exercise> getFilteredExercises() {
    return _exercises.where((exercise) {
      bool matchesSearch = _searchQuery.isEmpty || 
          exercise.name.toLowerCase().contains(_searchQuery.toLowerCase());
      
      bool matchesCategory = _selectedCategory == null || 
          exercise.category.toLowerCase() == _selectedCategory!.toLowerCase();
      
      bool matchesMuscle = _selectedMuscle == null || 
          exercise.muscleGroup.toLowerCase() == _selectedMuscle!.toLowerCase();
      
      bool matchesEquipment = _selectedEquipment == null || 
          exercise.equipment.toLowerCase() == _selectedEquipment!.toLowerCase();

      return matchesSearch && matchesCategory && matchesMuscle && matchesEquipment;
    }).toList();
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
}
