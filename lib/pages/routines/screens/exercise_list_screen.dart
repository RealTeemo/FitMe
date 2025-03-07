import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:work_out_app/features/data/models/exercise_model.dart';
import 'package:work_out_app/providers/exercise_provider.dart';
import 'package:work_out_app/pages/routines/widgets/exercise_image.dart';

class ExerciseListScreen extends StatefulWidget {
  final List<Exercise> selectedExercises;
  
  const ExerciseListScreen({
    Key? key,
    required this.selectedExercises,
  }) : super(key: key);

  @override
  _ExerciseListScreenState createState() => _ExerciseListScreenState();
}

class _ExerciseListScreenState extends State<ExerciseListScreen> {
  List<Exercise> selectedExercises = [];

  @override
  void initState() {
    super.initState();
    selectedExercises = List.from(widget.selectedExercises);
    
    // Initialize ExerciseProvider with selected exercises
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final exerciseProvider = Provider.of<ExerciseProvider>(context, listen: false);
      if (exerciseProvider.exercises.isEmpty) {
        exerciseProvider.loadExercises();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ExerciseProvider>(
      builder: (context, exerciseProvider, child) {
        final List<Exercise> filteredExercises = exerciseProvider.getFilteredExercises();

        return Scaffold(
          appBar: AppBar(
            title: const Text('Select Exercises'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context, selectedExercises);
                },
                child: Text(
                  'Done (${selectedExercises.length})',
                  style: const TextStyle(color: Colors.blue),
                ),
              ),
            ],
          ),
          body: Column(
            children: [
              // Search Bar
              Padding(
                padding: const EdgeInsets.all(16),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search exercises...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onChanged: (value) => exerciseProvider.setSearchQuery(value),
                ),
              ),

              // Filter Chips
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    FilterChip(
                      label: const Text('Category'),
                      selected: exerciseProvider.selectedCategory != null,
                      onSelected: (bool selected) {
                        _showFilterOptions(
                          'Category',
                          ['Stretching', 'Strength', 'Cardio'],
                          exerciseProvider.selectedCategory,
                          exerciseProvider.setCategory,
                        );
                      },
                    ),
                    const SizedBox(width: 8),
                    FilterChip(
                      label: const Text('Muscle Group'),
                      selected: exerciseProvider.selectedMuscle != null,
                      onSelected: (bool selected) {
                        _showFilterOptions(
                          'Muscle Group',
                          ['Chest', 'Back', 'Legs', 'Arms', 'Core'],
                          exerciseProvider.selectedMuscle,
                          exerciseProvider.setMuscleGroup,
                        );
                      },
                    ),
                    const SizedBox(width: 8),
                    FilterChip(
                      label: const Text('Equipment'),
                      selected: exerciseProvider.selectedEquipment != null,
                      onSelected: (bool selected) {
                        _showFilterOptions(
                          'Equipment',
                          ['None', 'Dumbbells', 'Barbell', 'Machine'],
                          exerciseProvider.selectedEquipment,
                          exerciseProvider.setEquipment,
                        );
                      },
                    ),
                  ],
                ),
              ),

              // Exercise List
              Expanded(
                child: ListView.builder(
                  itemCount: filteredExercises.length,
                  itemBuilder: (context, index) {
                    final exercise = filteredExercises[index];
                    final isSelected = selectedExercises.contains(exercise);

                    return ListTile(
                      leading: ExerciseImage(
                        exercise: exercise,
                        width: 56,
                        height: 56,
                      ),
                      title: Text(exercise.name),
                      subtitle: Text(
                        '${exercise.muscleGroup} • ${exercise.equipment}',
                        style: const TextStyle(color: Colors.grey),
                      ),
                      trailing: IconButton(
                        icon: Icon(
                          isSelected ? Icons.check_circle : Icons.add_circle_outline,
                          color: isSelected ? Colors.blue : Colors.grey,
                        ),
                        onPressed: () {
                          setState(() {
                            if (isSelected) {
                              selectedExercises.remove(exercise);
                            } else {
                              selectedExercises.add(exercise);
                            }
                          });
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showFilterOptions(
    String title,
    List<String> options,
    String? selectedValue,
    Function(String?) onChanged,
  ) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text(title),
                trailing: TextButton(
                  child: const Text('Clear'),
                  onPressed: () {
                    onChanged(null);
                    Navigator.pop(context);
                  },
                ),
              ),
              const Divider(),
              ...options.map((option) => ListTile(
                title: Text(option),
                trailing: selectedValue == option
                    ? const Icon(Icons.check, color: Colors.blue)
                    : null,
                onTap: () {
                  onChanged(option);
                  Navigator.pop(context);
                },
              )),
            ],
          ),
        );
      },
    );
  }
}