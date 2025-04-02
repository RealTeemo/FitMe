import 'package:flutter/material.dart';
import 'package:work_out_app/features/data/models/routine_model.dart';
import 'package:work_out_app/pages/routines/widgets/routine_card.dart';
import 'package:work_out_app/pages/routines/screens/create_routine_screen.dart';
import 'package:provider/provider.dart';
import 'package:work_out_app/providers/routine_provider.dart';
import 'package:work_out_app/pages/routines/screens/start_exercise_screen.dart';
/// Main screen for managing workout routines.
/// 
/// Features:
/// - Displays list of user's custom routines
/// - Allows creating new routines
/// - Provides AI routine creator
/// - Enables editing and deleting routines
/// - Shows quick start button for each routine
class RoutineScreen extends StatefulWidget {
  @override
  _RoutineScreenState createState() => _RoutineScreenState();
}

class _RoutineScreenState extends State<RoutineScreen> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

  @override
  Widget build(BuildContext context) {
    return Consumer<RoutineProvider>(
      builder: (context, routineProvider, child) {
        final List<Routine> userRoutines = routineProvider.routines;

        return Scaffold(
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Tab selector for My Routines and Explore
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Row(
                  children: [
                    Text(
                      'My Routines',
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 40),
                    Text(
                      'Explore',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 24,
                      ),
                    ),
                  ],
                ),
              ),

              // Action buttons row
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Row(
                  children: [
                    // New Routine button
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => _showCreateRoutineDialog(context),
                        icon: Icon(Icons.add),
                        label: Text('New Routine'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[800],
                          padding: EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    // AI Creator button
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {},
                        icon: Icon(Icons.auto_awesome),
                        label: Text('AI Creator'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          padding: EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                    // Help button
                    IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.help_outline),
                    ),
                  ],
                ),
              ),

              // Routines list
              Expanded(
                child: userRoutines.isEmpty
                    ? Center(
                        child: Text(
                          'No routines yet.\nCreate one to get started!',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey),
                        ),
                      )
                    : AnimatedList(
                        key: _listKey,
                        initialItemCount: userRoutines.length,
                        padding: EdgeInsets.all(16),
                        itemBuilder: (context, index, animation) {
                          if (index >= userRoutines.length) {
                            return const SizedBox.shrink();
                          }
                          return SlideTransition(
                            position: animation.drive(
                              Tween(
                                begin: const Offset(1.0, 0.0),
                                end: Offset.zero,
                              ),
                            ),
                            child: FadeTransition(
                              opacity: animation,
                              child: RoutineCard(
                                routine: userRoutines[index],
                                onStart: () => _startRoutine(userRoutines[index]),
                                onEdit: () => _editRoutine(context, userRoutines[index]),
                                onDelete: () => _deleteRoutine(context, userRoutines[index]),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showCreateRoutineDialog(BuildContext context) async {
    final routineProvider = Provider.of<RoutineProvider>(context, listen: false);
    final Routine? newRoutine = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreateRoutineScreen(),
      ),
    );

    if (newRoutine != null) {
      try {
        // Add the routine using the provider
        await routineProvider.addRoutine(newRoutine);

        // Get the index where the new routine will be added
        final newIndex = routineProvider.routines.length - 1;

        // Notify AnimatedList about the insertion
        _listKey.currentState?.insertItem(
          newIndex,
          duration: const Duration(milliseconds: 300),
        );

        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Routine saved successfully'),
            backgroundColor: Colors.green,
          ),
        );
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving routine: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _startRoutine(Routine routine) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => StartExerciseScreen(routine: routine),
      ),
    );
  }

  void _deleteRoutine(BuildContext context, Routine routine) async {
    final routineProvider = Provider.of<RoutineProvider>(context, listen: false);
    final routineIndex = routineProvider.routines.indexOf(routine);
    final routineName = routine.name;

    try {
      // Remove from provider
      await routineProvider.deleteRoutine(routine.id);

      // Notify AnimatedList about the removal
      _listKey.currentState?.removeItem(
        routineIndex,
        (context, animation) => SlideTransition(
          position: animation.drive(
            Tween(
              begin: const Offset(1.0, 0.0),
              end: Offset.zero,
            ),
          ),
          child: FadeTransition(
            opacity: animation,
            child: RoutineCard(
              routine: routine,
              onStart: () => _startRoutine(routine),
              onEdit: () => _editRoutine(context, routine),
              onDelete: () => _deleteRoutine(context, routine),
            ),
          ),
        ),
        duration: const Duration(milliseconds: 300),
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$routineName deleted'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
          action: SnackBarAction(
            label: 'Undo',
            textColor: Colors.white,
            onPressed: () async {
              try {
                await routineProvider.addRoutine(routine);
                // Insert back into AnimatedList
                _listKey.currentState?.insertItem(
                  routineIndex,
                  duration: const Duration(milliseconds: 300),
                );
              } catch (e) {
                if (!mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Error restoring routine: $e'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error deleting routine: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _editRoutine(BuildContext context, Routine routine) async {
    final routineProvider = Provider.of<RoutineProvider>(context, listen: false);
    final Routine? updatedRoutine = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreateRoutineScreen(routine: routine),
      ),
    );

    if (updatedRoutine != null) {
      try {
        final index = routineProvider.routines.indexWhere((r) => r.id == routine.id);
        await routineProvider.updateRoutine(updatedRoutine);

        // Trigger a rebuild of the specific item
        _listKey.currentState?.removeItem(
          index,
          (context, animation) => SlideTransition(
            position: animation.drive(
              Tween(
                begin: const Offset(-1.0, 0.0),
                end: Offset.zero,
              ),
            ),
            child: FadeTransition(
              opacity: animation,
              child: RoutineCard(
                routine: routine,
                onStart: () => _startRoutine(routine),
                onEdit: () => _editRoutine(context, routine),
                onDelete: () => _deleteRoutine(context, routine),
              ),
            ),
          ),
          duration: const Duration(milliseconds: 150),
        );
        _listKey.currentState?.insertItem(
          index,
          duration: const Duration(milliseconds: 300),
        );

        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Routine updated successfully'),
            backgroundColor: Colors.green,
          ),
        );
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error updating routine: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
