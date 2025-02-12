import 'package:flutter/material.dart';
import 'package:work_out_app/features/data/models/exercise_model.dart';
import 'package:work_out_app/pages/exercise/screens/add_exercise_screen.dart';
import 'package:work_out_app/pages/exercise/widgets/filter_buttons.dart';
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
      // Check if exercise matches all selected filters
      if (selectedCategory != null && 
          exercise.category != selectedCategory) {
        return false;
      }
      
      if (selectedEquipment != null && 
          exercise.equipment != selectedEquipment) {
        return false;
      }
      
      if (selectedMuscle != null && 
          exercise.muscleGroup != selectedMuscle) {
        return false;
      }
      
      if (searchQuery.isNotEmpty && 
          !exercise.name.toLowerCase().contains(searchQuery.toLowerCase())) {
        return false;
      }

      return true;
    }).toList();

    // Pass the filtered exercises to ExerciseList
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                //search bar
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
                      setState(() => searchQuery = value.trim());
                    },
                  ),
                ),
                const SizedBox(width: 10),
                //add exercise button
                Expanded(
                  flex: 10,
                  child: SizedBox(
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => AddExerciseScreen())),
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
                    onChanged: (value){
                      setState(() => selectedCategory = value);
                    }
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
          //exercise list
          Expanded(child: ExerciseList(filteredExercises: filteredExercises)),
        ],
      ),
    );
  }
}