import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:work_out_app/features/data/models/exercise_model.dart';
import 'package:work_out_app/providers/exercise_provider.dart';
import 'package:work_out_app/pages/exercise/widgets/custom_form_field.dart';

class AddExerciseScreen extends StatefulWidget {
  @override
  _AddExerciseScreenState createState() => _AddExerciseScreenState();
}

class _AddExerciseScreenState extends State<AddExerciseScreen> {
  final _formKey = GlobalKey<FormState>();
  String name = '';
  String category = 'Strength';
  String equipment = 'None';
  String muscleGroup = 'Chest';

  // Predefined options for dropdowns
  final List<String> categories = ['Strength', 'Cardio', 'Flexibility', 'Bodyweight'];
  final List<String> equipmentOptions = ['None', 'Dumbbells', 'Barbell', 'Kettlebell', 'Resistance Bands'];
  final List<String> muscleGroups = ['Chest', 'Back', 'Legs', 'Shoulders', 'Arms', 'Core'];

  String? selectedCategory;
  String? selectedEquipment;
  String? selectedMuscleGroup;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Exercise'),
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Image placeholder
              Container(
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.grey[800],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.add_a_photo, size: 50, color: Colors.white70),
              ),
              SizedBox(height: 24),

              // Exercise name field
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Exercise Name',
                  border: OutlineInputBorder(),
                  filled: true,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an exercise name';
                  }
                  return null;
                },
                onSaved: (value) => name = value ?? '',
              ),
              SizedBox(height: 16),

              // Category dropdown

              // Equipment dropdown

              // Muscle group dropdown
              CustomDropdownField(label: "Type", options: ["Strength", "Cardio", "Stretching"], selectedValue: selectedCategory, onChanged: (value) => setState(() => selectedCategory = value)),
              SizedBox(height: 16),
              CustomDropdownField(label: "Equipment", options: ["Body Weight", "Dumbbell", "Barbell", "Machine"], selectedValue: selectedEquipment, onChanged: (value) => setState(() => selectedEquipment = value)),
              SizedBox(height: 16),
              CustomDropdownField(label: "Muscle Group", options: ["Chest", "Back", "Legs", "Arms", "Core", "Shoulders","Abs"], selectedValue: selectedMuscleGroup, onChanged: (value) => setState(() => selectedMuscleGroup = value)),
              SizedBox(height: 24),
              // Save button
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.blue,
                ),
                onPressed: _saveExercise,
                child: Text(
                  'Save Exercise',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _saveExercise() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      
      final exercise = Exercise(
        id: DateTime.now().toString(), // Generate a unique ID
        name: name,
        category: category,
        equipment: equipment,
        muscleGroup: muscleGroup,
        image: 'assets/placeholder.png', // Default image path
      );

      // Add the exercise using the provider
      Provider.of<ExerciseProvider>(context, listen: false).addExercise(exercise);
      
      Navigator.pop(context);
    }
  }
} 