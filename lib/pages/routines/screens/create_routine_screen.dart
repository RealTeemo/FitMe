import 'package:flutter/material.dart';
import 'package:work_out_app/features/data/models/exercise_model.dart';
import 'package:work_out_app/features/data/models/routine_model.dart';
import 'package:work_out_app/pages/routines/screens/exercise_list_screen.dart';
import 'package:work_out_app/pages/routines/widgets/add_exercise_button.dart';

class CreateRoutineScreen extends StatefulWidget {
  final Routine? routine; // Optional - for editing existing routine

  const CreateRoutineScreen({Key? key, this.routine}) : super(key: key);

  @override
  _CreateRoutineScreenState createState() => _CreateRoutineScreenState();
}

class _CreateRoutineScreenState extends State<CreateRoutineScreen> {
  late TextEditingController _nameController;
  late TextEditingController _notesController;
  List<Exercise> selectedExercises = [];
  Set<String> workingMuscles = {};
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _isEditing = widget.routine != null;
    _nameController = TextEditingController(text: widget.routine?.name ?? '');
    _notesController = TextEditingController(text: widget.routine?.notes ?? '');
    if (widget.routine != null) {
      selectedExercises = List.from(widget.routine!.exercises);
      workingMuscles = Set.from(widget.routine!.targetMuscles);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _addExercise() async {
    final List<Exercise>? result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ExerciseListScreen(initialSelectedExercises: selectedExercises),
      ),
    );

    if (result != null) {
      setState(() {
        selectedExercises = result;
        // Update working muscles based on selected exercises
        workingMuscles = result
            .map((exercise) => exercise.muscleGroup)
            .toSet();
      });
    }
  }

  void _saveRoutine() {
    if (_nameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a routine name'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    if (selectedExercises.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please add at least one exercise'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    final routine = Routine(
      id: widget.routine?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      name: _nameController.text,
      notes: _notesController.text,
      exercises: selectedExercises,
      targetMuscles: workingMuscles.toList(),
      exerciseConfigs: widget.routine?.exerciseConfigs ?? {},
    );
    
    

    Navigator.pop(context, routine);
  }

  Widget _buildExerciseList() {
    if (selectedExercises.isEmpty) {
      return const Center(
        child: Column(
          children: [
            SizedBox(height: 20),
            Text(
              'Please add exercises',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return ReorderableListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: selectedExercises.length,
      onReorder: (oldIndex, newIndex) {
        setState(() {
          if (newIndex > oldIndex) {
            newIndex -= 1;
          }
          final exercise = selectedExercises.removeAt(oldIndex);
          selectedExercises.insert(newIndex, exercise);
        });
      },
      buildDefaultDragHandles: false,
      itemBuilder: (context, index) {
        final exercise = selectedExercises[index];
        return Card(
          key: ValueKey(exercise.id),
          margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
          child: ListTile(
            leading: ReorderableDragStartListener(
              index: index,
              child: const Icon(Icons.drag_handle, color: Colors.grey),
            ),
            title: Text(exercise.name),
            subtitle: Text('${exercise.muscleGroup} • ${exercise.equipment}'),
            trailing: IconButton(
              icon: Icon(Icons.delete, color: Colors.red[300]),
              onPressed: () {
                setState(() {
                  selectedExercises.removeAt(index);
                  workingMuscles = selectedExercises.map((exercise) => exercise.muscleGroup).toSet();
                });
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildWorkingMusclesChips() {
    return Wrap(
      spacing: 8.0,
      runSpacing: 4.0,
      children: workingMuscles.map((muscle) => Chip(
        label: Text(muscle),
        backgroundColor: Colors.blue.withOpacity(0.2),
      )).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: TextField(
          controller: _nameController,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            hintText: 'Enter Routine Name',
            hintStyle: TextStyle(color: Colors.grey),
            border: InputBorder.none,
          ),
        ),
        actions: [
          // Only show save button if exercises are added
          if (selectedExercises.isNotEmpty)
            TextButton.icon(
              onPressed: _saveRoutine,
              icon: const Icon(Icons.save),
              label: Text(_isEditing ? 'Update' : 'Save'),
              style: TextButton.styleFrom(
                foregroundColor: Colors.blue,
              ),
            ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Working Muscles Section
              Row(
                children: [
                  const Icon(Icons.fitness_center, size: 24),
                  const SizedBox(width: 8),
                  const Text(
                    'Working Muscles',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.help_outline),
                    onPressed: () {
                      // Show help dialog for working muscles
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Working Muscles'),
                          content: const Text('This section shows the muscle groups targeted by the exercises in your routine. It updates automatically as you add or remove exercises.'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Got it'),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 8),
              if (workingMuscles.isNotEmpty)
                _buildWorkingMusclesChips()
              else
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Text(
                      'Please add exercises',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                ),

              // Routine Notes Section
              const SizedBox(height: 24),
              Row(
                children: [
                  const Icon(Icons.edit_note, size: 24),
                  const SizedBox(width: 8),
                  const Text(
                    'Routine Notes',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _notesController,
                decoration: InputDecoration(
                  hintText: 'Write your personal notes and tips',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.grey[900],
                ),
                maxLines: 3,
              ),

              // Exercises Section
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.fitness_center, size: 24),
                      const SizedBox(width: 8),
                      const Text(
                        'Exercises',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        icon: const Icon(Icons.help_outline),
                        onPressed: () {
                          // Show help dialog for exercises
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Exercises'),
                              content: const Text('Add exercises to your routine using the + button. You can reorder exercises by dragging them, and remove them using the delete button.'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('Got it'),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  AddExerciseButton(onPressed: _addExercise)
                ],
              ),
              const SizedBox(height: 16),
              _buildExerciseList(),
            ],
          ),
        ),
      ),
    );
  }
} 