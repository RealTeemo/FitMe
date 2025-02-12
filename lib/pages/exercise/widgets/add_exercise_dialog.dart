import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:work_out_app/features/data/models/exercise_model.dart';
import 'package:uuid/uuid.dart';
import 'package:work_out_app/pages/exercise/widgets/custom_form_field.dart';
import 'package:work_out_app/providers/exercise_provider.dart';
import 'package:provider/provider.dart';

class AddExerciseDialog extends StatefulWidget {
  final Function(Exercise) onExerciseAdded;

  const AddExerciseDialog({Key? key, required this.onExerciseAdded}) : super(key: key);
  @override
  _AddExerciseDialogState createState() => _AddExerciseDialogState();
}

class _AddExerciseDialogState extends State<AddExerciseDialog> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();
  final TextEditingController equipmentController = TextEditingController();
  final TextEditingController muscleGroupController = TextEditingController();
  
  String? selectedCategory;
  String? selectedEquipment;
  String? selectedMuscleGroup;
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(source: source);
      if (pickedFile != null) {
        setState(() {
          _imageFile = File(pickedFile.path);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to pick image: $e')),
      );
    }
  }

  void _showImageSourceDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Select Image Source'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.photo_camera),
              title: Text('Camera'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: Icon(Icons.photo_library),
              title: Text('Gallery'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _removeImage() {
    setState(() {
      _imageFile = null;
    });
  }

  void _addExercise() {
    final exerciseProvider = Provider.of<ExerciseProvider>(context, listen: false);
    
    if (nameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter exercise name')),
      );
      return;
    }

    bool exists = exerciseProvider.exercises.any((exercise) => 
      exercise.name.toLowerCase() == nameController.text.toLowerCase().trim() &&
      exercise.category == (selectedCategory ?? "General") &&
      exercise.equipment == (selectedEquipment ?? "None") &&
      exercise.muscleGroup == (selectedMuscleGroup ?? "Full Body")
    );

    if (exists) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Exercise already exists")),
      );
      return;
    }

    widget.onExerciseAdded(
      Exercise(
        id: const Uuid().v4(),
        name: nameController.text,
        category: selectedCategory ?? "General",
        equipment: selectedEquipment ?? "None",
        muscleGroup: selectedMuscleGroup ?? "Full Body",
        image: _imageFile?.path ?? "assets/default_exercise.png",
      ),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Add New Exercise"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Image picker section
            GestureDetector(
              onTap: _showImageSourceDialog,
              child: Container(
                height: 120,
                width: 120,
                decoration: BoxDecoration(
                  color: Colors.grey[800],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: _imageFile != null
                    ? Stack(
                        fit: StackFit.expand,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.file(
                              _imageFile!,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned(
                            top: 5,
                            right: 5,
                            child: GestureDetector(
                              onTap: _removeImage,
                              child: Container(
                                padding: EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: Colors.black54,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.close,
                                  size: 20,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    : Icon(
                        Icons.add_a_photo,
                        size: 40,
                        color: Colors.grey[400],
                      ),
              ),
            ),
          SizedBox(height: 16),
          CustomTextField(controller: nameController, hint: "Exercise Name"),
          CustomDropdownField(label: "Type", options: ["Strength", "Cardio", "Stretching"], selectedValue: selectedCategory, onChanged: (value) => setState(() => selectedCategory = value)),
          CustomDropdownField(label: "Equipment", options: ["Body Weight", "Dumbbell", "Barbell", "Machine"], selectedValue: selectedEquipment, onChanged: (value) => setState(() => selectedEquipment = value)),
          CustomDropdownField(label: "Muscle Group", options: ["Chest", "Back", "Legs", "Arms", "Core", "Shoulders","Abs"], selectedValue: selectedMuscleGroup, onChanged: (value) => setState(() => selectedMuscleGroup = value)),

        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: _addExercise,
          child: Text("Add"),
        ),
      ],
    );
  }
}
