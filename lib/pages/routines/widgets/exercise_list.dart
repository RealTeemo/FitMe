import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:work_out_app/features/data/models/exercise_model.dart';

class ExerciseList extends StatelessWidget {
  final List<Exercise> selectedExercises;
  final Function(int, int) onReorder;
  final Function(int) onDelete;

  const ExerciseList({
    Key? key,
    required this.selectedExercises,
    required this.onReorder,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ReorderableListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: selectedExercises.length,
      onReorder: onReorder,
      buildDefaultDragHandles: false,
      itemBuilder: (context, index) {
        final exercise = selectedExercises[index];
        return Card(
          key: ValueKey(exercise.id),
          margin: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
          child: ListTile(
            leading: ReorderableDragStartListener(
              index: index,
              child: Icon(Icons.drag_handle, color: Colors.grey),
            ),
            title: Text(exercise.name),
            subtitle: Text('${exercise.muscleGroup} • ${exercise.equipment}'),
            trailing: IconButton(
              icon: Icon(Icons.delete, color: Colors.red[300]),
              onPressed: () => onDelete(index),
            ),
          ),
        );
      },
    );
  }
}
