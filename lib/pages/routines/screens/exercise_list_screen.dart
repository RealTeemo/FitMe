import 'package:flutter/material.dart';
import 'package:work_out_app/features/data/models/exercise_model.dart';
import 'package:work_out_app/features/data/data_sources/exercise_data.dart';

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
  String searchQuery = '';
  String? selectedCategory;
  String? selectedMuscle;
  String? selectedEquipment;

  @override
  void initState() {
    super.initState();
    selectedExercises = List.from(widget.selectedExercises);
  }

  List<Exercise> get filteredExercises {
    return exercises.where((exercise) {
      bool matchesSearch = searchQuery.isEmpty || 
          exercise.name.toLowerCase().contains(searchQuery.toLowerCase());
      bool matchesCategory = selectedCategory == null || 
          exercise.category == selectedCategory;
      bool matchesMuscle = selectedMuscle == null || 
          exercise.muscleGroup == selectedMuscle;
      bool matchesEquipment = selectedEquipment == null || 
          exercise.equipment == selectedEquipment;

      return matchesSearch && matchesCategory && matchesMuscle && matchesEquipment;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Exercises'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context, selectedExercises);
            },
            child: Text(
              'Done (${selectedExercises.length})',
              style: TextStyle(color: Colors.blue),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: EdgeInsets.all(16),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search exercises...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
            ),
          ),

          // Filter Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                FilterChip(
                  label: Text('Category'),
                  selected: selectedCategory != null,
                  onSelected: (bool selected) {
                    _showFilterOptions(
                      'Category',
                      ['Stretching', 'Strength', 'Cardio'],
                      selectedCategory,
                      (value) => setState(() => selectedCategory = value),
                    );
                  },
                ),
                SizedBox(width: 8),
                FilterChip(
                  label: Text('Muscle Group'),
                  selected: selectedMuscle != null,
                  onSelected: (bool selected) {
                    _showFilterOptions(
                      'Muscle Group',
                      ['Chest', 'Back', 'Legs', 'Arms', 'Core'],
                      selectedMuscle,
                      (value) => setState(() => selectedMuscle = value),
                    );
                  },
                ),
                SizedBox(width: 8),
                FilterChip(
                  label: Text('Equipment'),
                  selected: selectedEquipment != null,
                  onSelected: (bool selected) {
                    _showFilterOptions(
                      'Equipment',
                      ['None', 'Dumbbells', 'Barbell', 'Machine'],
                      selectedEquipment,
                      (value) => setState(() => selectedEquipment = value),
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
                  leading: Image.asset(
                    exercise.image,
                    width: 56,
                    height: 56,
                    fit: BoxFit.cover,
                  ),
                  title: Text(exercise.name),
                  subtitle: Text(
                    '${exercise.muscleGroup} • ${exercise.equipment}',
                    style: TextStyle(color: Colors.grey),
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
                  child: Text('Clear'),
                  onPressed: () {
                    onChanged(null);
                    Navigator.pop(context);
                  },
                ),
              ),
              Divider(),
              ...options.map((option) => ListTile(
                title: Text(option),
                trailing: selectedValue == option
                    ? Icon(Icons.check, color: Colors.blue)
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