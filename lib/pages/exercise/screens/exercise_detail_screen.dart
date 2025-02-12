import 'package:flutter/material.dart';
import 'package:work_out_app/features/data/models/exercise_model.dart';

class ExerciseDetailScreen extends StatelessWidget {
  final Exercise exercise;

  const ExerciseDetailScreen({Key? key, required this.exercise}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(exercise.name)),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.asset(exercise.image, height: 200, fit: BoxFit.cover),
            ),
            SizedBox(height: 20),
            _buildDetailRow(Icons.category, "Category", exercise.category),
            _buildDetailRow(Icons.fitness_center, "Equipment", exercise.equipment),
            _buildDetailRow(Icons.accessibility, "Muscle Group", exercise.muscleGroup),
            SizedBox(height: 20),
            Text("Instructions:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 5),
            _buildInstructionList(),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String title, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Icon(icon, color: Colors.blue),
          SizedBox(width: 10),
          Text(
            "$title: $value",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _buildInstructionList() {
    List<String> instructions = [
      "1. Get into position",
      "2. Perform the movement",
      "3. Maintain proper form",
      "4. Repeat for the desired reps"
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: instructions
          .map((step) => Padding(
                padding: EdgeInsets.symmetric(vertical: 3),
                child: Text(step, style: TextStyle(fontSize: 16)),
              ))
          .toList(),
    );
  }
}
