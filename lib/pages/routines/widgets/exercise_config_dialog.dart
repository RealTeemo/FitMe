import 'package:flutter/material.dart';
import 'package:work_out_app/features/data/models/exercise_model.dart';

/// Dialog for configuring exercise sets and reps.
/// 
/// Features:
/// - Slider for selecting number of sets (1-10)
/// - Slider for selecting number of reps (1-30)
/// - Shows exercise name
/// - Save and cancel options
class ExerciseConfigDialog extends StatefulWidget {
  final Exercise exercise;
  final int sets;
  final int reps;

  const ExerciseConfigDialog({
    Key? key,
    required this.exercise,
    this.sets = 3,
    this.reps = 12,
  }) : super(key: key);

  @override
  State<ExerciseConfigDialog> createState() => _ExerciseConfigDialogState();
}

class _ExerciseConfigDialogState extends State<ExerciseConfigDialog> {
  late int sets;
  late int reps;

  @override
  void initState() {
    super.initState();
    sets = widget.sets;
    reps = widget.reps;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.exercise.name),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Sets slider
          Row(
            children: [
              Text('Sets: '),
              Expanded(
                child: Slider(
                  value: sets.toDouble(),
                  min: 1,
                  max: 10,
                  divisions: 9,
                  label: sets.toString(),
                  onChanged: (value) {
                    setState(() => sets = value.round());
                  },
                ),
              ),
              SizedBox(width: 8),
              Text(sets.toString()),
            ],
          ),
          // Reps slider
          Row(
            children: [
              Text('Reps: '),
              Expanded(
                child: Slider(
                  value: reps.toDouble(),
                  min: 1,
                  max: 30,
                  divisions: 29,
                  label: reps.toString(),
                  onChanged: (value) {
                    setState(() => reps = value.round());
                  },
                ),
              ),
              SizedBox(width: 8),
              Text(reps.toString()),
            ],
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            // Return null to indicate clearing the configuration
            Navigator.pop(context, null);
          },
          child: Text("Clear")
        ),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context, {
              'sets': sets,
              'reps': reps,
            });
          },
          child: Text('Save'),
        ),
      ],
    );
  }
} 