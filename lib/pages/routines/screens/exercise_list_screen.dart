import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:work_out_app/features/data/models/exercise_model.dart';
import 'package:work_out_app/providers/exercise_provider.dart';
import 'package:work_out_app/pages/routines/widgets/exercise_image.dart';

class ExerciseListScreen extends StatefulWidget {
  final List<Exercise> initialSelectedExercises;
  
  const ExerciseListScreen({
    Key? key,
    // Rename for clarity
    required this.initialSelectedExercises,
  }) : super(key: key);

  @override
  _ExerciseListScreenState createState() => _ExerciseListScreenState();
}

class _ExerciseListScreenState extends State<ExerciseListScreen> {
  // Local state for selected exercises within this screen instance
  late List<Exercise> _selectedExercises;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    // Initialize local selected exercises from the passed list
    _selectedExercises = List.from(widget.initialSelectedExercises);
    _initializeAndLoadExercises();
  }

  Future<void> _initializeAndLoadExercises() async {
    final exerciseProvider = Provider.of<ExerciseProvider>(context, listen: false);
    
    setState(() => _isLoading = true);
    
    try {
      // Clear any existing filters from previous uses
      exerciseProvider.clearFilters();
      
      // Ensure exercises are loaded in the provider
      await exerciseProvider.ensureLoaded(); 

    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading exercises: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Use Consumer to react to changes in ExerciseProvider (like filtering)
    return Consumer<ExerciseProvider>(
      builder: (context, exerciseProvider, child) {
        // Get the currently filtered list from the provider
        final List<Exercise> filteredExercises = exerciseProvider.getFilteredExercises();

        return Scaffold(
          appBar: AppBar(
            title: const Text('Select Exercises'),
            actions: [
              TextButton(
                onPressed: () {
                  // Return the locally managed selected exercises
                  Navigator.pop(context, _selectedExercises);
                },
                child: Text(
                  'Done (${_selectedExercises.length})',
                  style: const TextStyle(color: Colors.blue),
                ),
              ),
            ],
          ),
          body: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : Column(
                  children: [
                    // Search Bar
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: TextField(
                        // Use provider's query state if needed, or manage locally
                        // controller: _searchController, 
                        decoration: InputDecoration(
                          hintText: 'Search exercises...',
                          prefixIcon: const Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        // Update provider's search query on change
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
                                ['Stretching', 'Strength', 'Cardio', 'Bodyweight'], // Added Bodyweight
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
                                // Consider dynamically getting these from loaded exercises
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
                                // Consider dynamically getting these from loaded exercises
                                ['None', 'Dumbbells', 'Barbell', 'Machine', 'Body Weight'], 
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
                      child: filteredExercises.isEmpty
                          ? const Center(
                              child: Text(
                                'No exercises match filters',
                                style: TextStyle(color: Colors.grey),
                              ),
                            )
                          : ListView.builder(
                              itemCount: filteredExercises.length,
                              itemBuilder: (context, index) {
                                final exercise = filteredExercises[index];
                                // Check against the local selection state
                                final isSelected = _selectedExercises.any((e) => e.id == exercise.id);

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
                                      // Update the local selection state
                                      setState(() {
                                        if (isSelected) {
                                          _selectedExercises.removeWhere((e) => e.id == exercise.id);
                                        } else {
                                          _selectedExercises.add(exercise);
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

  // _showFilterOptions remains largely the same
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