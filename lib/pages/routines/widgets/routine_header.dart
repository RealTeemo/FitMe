import 'package:flutter/material.dart';

class RoutineHeader extends StatelessWidget {
  final TextEditingController notesController;

  const RoutineHeader({Key? key, required this.notesController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.fitness_center, size: 24),
            SizedBox(width: 8),
            Text(
              'Working Muscles',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            IconButton(
              icon: Icon(Icons.help_outline),
              onPressed: () {}, // TODO: Show help info
            ),
          ],
        ),
        SizedBox(height: 24),
        Row(
          children: [
            Icon(Icons.edit_note, size: 24),
            SizedBox(width: 8),
            Text(
              'Routine Note',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        SizedBox(height: 8),
        TextField(
          controller: notesController,
          decoration: InputDecoration(
            hintText: 'Write your personal notes and tips',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            filled: true,
            fillColor: Colors.grey[900],
          ),
          maxLines: 3,
        ),
      ],
    );
  }
}
