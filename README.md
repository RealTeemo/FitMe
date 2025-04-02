# FitMe
workout app

A Flutter-based workout tracking application that helps users create, manage, and track their exercise routines.

## Features

### Exercise Management
- Browse comprehensive exercise library
- Filter exercises by:
  - Category (Stretching, Strength, Cardio, Bodyweight)
  - Muscle Group (Chest, Back, Legs, Arms, Core)
  - Equipment (None, Dumbbells, Barbell, Machine, Body Weight)
- Search exercises by name
- View exercise details including images and instructions

### Routine Management
- Create custom workout routines
- Add/remove exercises to routines
- Organize exercises within routines
- Save and manage multiple routines

## Project Structure
lib/
├── features/
│ └── data/
│ └── models/
│ ├── exercise_model.dart
│ └── routine_model.dart
├── pages/
│ └── routines/
│ ├── screens/
│ │ └── exercise_list_screen.dart
│ └── widgets/
│ └── exercise_image.dart
├── providers/
│ ├── exercise_provider.dart
│ └── routine_provider.dart
└── main.dart

## Setup & Installation

1. **Prerequisites**
   - Flutter SDK (latest version)
   - Dart SDK (latest version)
   - Android Studio or VS Code with Flutter extensions

2. **Installation**
   ```bash
   # Clone the repository
   git clone [repository-url]

   # Navigate to project directory
   cd workout-app

   # Install dependencies
   flutter pub get

   # Run the app
   flutter run
   ```

## State Management

The app uses Provider pattern for state management:

- **ExerciseProvider**: Manages exercise data and filtering
- **RoutineProvider**: Handles workout routine creation and management

## Data Persistence

- Exercise data is stored using SharedPreferences
- Routine data is managed through a singleton pattern with SharedPreferences

## Dependencies

yaml
dependencies:
flutter:
sdk: flutter
provider: ^6.0.0
shared_preferences: ^2.0.0
# Add other dependencies from pubspec.yaml

## Usage

### Creating a New Routine

1. Navigate to the Routines screen
2. Tap "Create New Routine"
3. Select exercises using the Exercise List Screen
4. Configure exercise details
5. Save the routine

### Filtering Exercises

1. Open the Exercise List Screen
2. Use the search bar for name-based filtering
3. Use filter chips for:
   - Category selection
   - Muscle group filtering
   - Equipment filtering

## Contributing

1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

## Testing
