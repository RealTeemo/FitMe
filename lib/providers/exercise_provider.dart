import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../features/data/models/exercise_model.dart';
import '../features/data/data_sources/exercise_data.dart' as exercise_data; // Alias import
import 'package:flutter/foundation.dart';

class ExerciseProvider with ChangeNotifier {
  List<Exercise> _exercises = [];
  String _searchQuery = '';
  String? _selectedCategory;
  String? _selectedMuscle;
  String? _selectedEquipment;
  bool _isLoaded = false; // Flag to track if exercises have been loaded

  // Getters
  List<Exercise> get exercises => _exercises;
  String get searchQuery => _searchQuery;
  String? get selectedCategory => _selectedCategory;
  String? get selectedMuscle => _selectedMuscle;
  String? get selectedEquipment => _selectedEquipment;
  bool get isLoaded => _isLoaded;

  ExerciseProvider() {
    // Don't load exercises immediately in constructor
    // Initialize with empty list or potentially default data if needed synchronously
    _exercises = [...exercise_data.exercises]; // Initialize with default data for immediate use
  }

  // Method to ensure exercises are loaded, called by screens when needed
  Future<void> ensureLoaded() async {
    if (_isLoaded) return; // Already loaded

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      List<String>? storedData = prefs.getStringList('exercises');
      List<Exercise> loadedExercises = [];

      if (storedData != null) {
        loadedExercises = storedData.map((e) => Exercise.fromJson(jsonDecode(e))).toList();

        // Merge default exercises with saved exercises (avoid duplicates)
        final defaultExercises = [...exercise_data.exercises];
        final Map<String, Exercise> exerciseMap = { for (var e in loadedExercises) e.id : e };
        for (var defaultExercise in defaultExercises) {
          if (!exerciseMap.containsKey(defaultExercise.id)) {
            exerciseMap[defaultExercise.id] = defaultExercise;
          }
        }
        _exercises = exerciseMap.values.toList();

      } else {
        // If no saved data, use only the default exercises
        _exercises = [...exercise_data.exercises];
      }

      _isLoaded = true;
    } catch (e) {
      print('Error loading exercises: $e');
      // Fallback to default exercises in case of error
      _exercises = [...exercise_data.exercises];
      _isLoaded = true; // Mark as loaded even on error to prevent reload loops
    } finally {
      notifyListeners(); // Notify listeners after loading attempt
    }
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
    // Use the current _exercises list which is updated by ensureLoaded
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
    // This saving logic might need adjustment if default exercises shouldn't be re-saved
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      // Consider filtering which exercises to save (e.g., only non-default ones)
       final userExercises = _exercises.where((e) => !e.isAssetImage).toList(); // Example: saving non-asset images
      List<String> jsonList = userExercises // Use the filtered list if needed
          .map((e) => jsonEncode(e.toJson()))
          .toList();
      await prefs.setStringList('exercises', jsonList);
    } catch (e) {
      print('Error saving exercises: $e');
    }
  }
   void initializeExercises(List<Exercise> initialExercises) {
     // This method might become redundant with the ensureLoaded approach
     // If still needed, ensure it works correctly with _isLoaded flag
     if (!_isLoaded) {
       _exercises = List.from(initialExercises);
      //  _isLoaded = true; // Consider if initializing manually counts as "loaded"
       notifyListeners();
     }
   }

  void addExercise(Exercise exercise) {
    _exercises.add(exercise);
     saveExercises(); // Save after adding
    notifyListeners();
  }

  void removeExercise(Exercise exercise) {
     // Need a way to identify the exercise to remove, typically by ID
     _exercises.removeWhere((e) => e.id == exercise.id);
     saveExercises(); // Save after removing
    notifyListeners();
  }

  void updateExercise(int index, Exercise updatedExercise) {
     // Check index bounds
     if (index >= 0 && index < _exercises.length) {
       _exercises[index] = updatedExercise;
       saveExercises(); // Save after updating
       notifyListeners();
     }
  }

  void deleteExercise(int index) {
     // Check index bounds
     if (index >= 0 && index < _exercises.length) {
      _exercises.removeAt(index);
       saveExercises(); // Save after deleting
       notifyListeners();
     }
   }
  
  void clearFilters() {
    _searchQuery = '';
    _selectedCategory = null;
    _selectedMuscle = null;
    _selectedEquipment = null;
    notifyListeners();
  }
}
