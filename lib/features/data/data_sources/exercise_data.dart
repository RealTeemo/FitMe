import '../models/exercise_model.dart';

/// Manages the storage and retrieval of exercise data.
/// 
/// Contains:
/// - List of predefined exercises
/// - Exercise categories
/// - Equipment types
/// - Muscle groups
/// - Methods for filtering and searching exercises
final List<Exercise> exercises = [
  Exercise(
    id: "1",
    name: "Push-Ups",
    category: "Strength",
    equipment: "Body Weight",
    muscleGroup: "Chest",
    image: "assets/pushups.png"
  ),
  Exercise(id: "2", name: "Squats", category: "Strength", equipment: "None", muscleGroup: "Legs", image: "assets/squats.png"),
  Exercise(id: "3", name: "Deadlifts", category: "Strength", equipment: "Barbell", muscleGroup: "Back", image: "assets/deadlifts.png"),
  Exercise(id: "4", name: "Planks", category: "Bodyweight", equipment: "None", muscleGroup: "Core", image: "assets/planks.png"),
  Exercise(id: "5", name: "Dumbbell Rows", category: "Strength", equipment: "Dumbbells", muscleGroup: "Back", image: "assets/dumbbell_rows.png"),
  Exercise(id: "6", name: "Bench Press", category: "Strength", equipment: "Barbell", muscleGroup: "Chest", image: "assets/bench_press.png"),

];