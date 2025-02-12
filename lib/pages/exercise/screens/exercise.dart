import 'package:flutter/material.dart';
import 'package:work_out_app/features/data/models/exercise_model.dart';
import 'package:work_out_app/pages/exercise/widgets/filter_buttons.dart';
import 'package:work_out_app/features/data/data_sources/exercise_data.dart';
import 'package:work_out_app/pages/exercise/widgets/add_exercise_dialog.dart';
import 'package:work_out_app/providers/exercise_provider.dart';
import 'package:work_out_app/pages/exercise/widgets/exercise_list.dart';
import 'package:provider/provider.dart';

class ExerciseScreen extends StatefulWidget {
  @override
  _ExerciseScreenState createState() => _ExerciseScreenState();
}

class _ExerciseScreenState extends State<ExerciseScreen> {
  String? selectedCategory;
  String? selectedEquipment;
  String? selectedMuscle;
  String searchQuery = '';

  List<Exercise> userExercises = [...exercises]; // Stores default + user-added exercises
  
  void _openAddExerciseDialog() {
    showDialog(
      context: context,
      builder: (context) => AddExerciseDialog(
        onExerciseAdded: (Exercise newExercise) {
           Provider.of<ExerciseProvider>(context, listen: false).addExercise(newExercise);
        },

      ),
    );
  }

  @override

  Widget build(BuildContext context) {

    final exerciseProvider = Provider.of<ExerciseProvider>(context);
    List<Exercise> filteredExercises = exerciseProvider.exercises.where((exercise) {
      return (selectedCategory == null || exercise.category == selectedCategory) &&
             (selectedEquipment == null || exercise.equipment == selectedEquipment) &&
             (selectedMuscle == null || exercise.muscleGroup == selectedMuscle) &&
             (searchQuery.isEmpty || exercise.name.toLowerCase().contains(searchQuery.toLowerCase()));
    }).toList();

    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                Expanded(
                  flex: 90,
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "Search exercises...",
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0)
                      ),
                    ),
                    onChanged: (value) {
                      setState(() => searchQuery = value);
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  flex: 10,
                  child: SizedBox(
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _openAddExerciseDialog,
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      child: const Icon(Icons.add),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Row(
              children: [
                Expanded(
                  child: FilterButton(
                    title: "Category",
                    icon: Icons.category,
                    options: ['Strength','Cardio','Stretching'],
                    selectedValue: selectedCategory,
                    onChanged: (value) => setState(() => selectedCategory = value),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: FilterButton(
                    title: "Equipment",
                    icon: Icons.fitness_center,
                    options: ['Body Weight', 'Dumbbell', 'Barbell','Machine',],
                    selectedValue: selectedEquipment,
                    onChanged: (value) => setState(() => selectedEquipment = value),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: FilterButton(
                    title: "Muscle Group",
                    icon: Icons.accessibility_new,
                    options: ['Chest', 'Back', 'Legs','Arms','Core','Shoulders','Abs'],
                    selectedValue: selectedMuscle,
                    onChanged: (value) => setState(() => selectedMuscle = value),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Expanded(child: ExerciseList(filteredExercises: filteredExercises)),
        ],
      ),
    );
  }
}