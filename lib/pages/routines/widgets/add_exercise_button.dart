import 'package:flutter/material.dart';

class AddExerciseButton extends StatelessWidget {
  final VoidCallback onPressed;

  const AddExerciseButton({Key? key, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
  icon: Icon(Icons.add),
                    label: Text('Add exercise'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                      );
  }
}
