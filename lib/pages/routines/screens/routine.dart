import 'package:flutter/material.dart';
import 'package:work_out_app/features/data/models/routine_model.dart';
import 'package:work_out_app/pages/routines/widgets/routine_card.dart';
import 'package:work_out_app/pages/routines/screens/create_routine_screen.dart';
import 'package:work_out_app/features/data/data_sources/routine_data.dart';

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
  final RoutineData _routineData = RoutineData();
  
  // Remove the local userRoutines list and use _routineData.routines instead
  List<Routine> get userRoutines => _routineData.routines;

  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

  @override
  Widget build(BuildContext context) {
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
                    onPressed: () => _showCreateRoutineDialog(),
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
                            onEdit: () => _editRoutine(userRoutines[index]),
                            onDelete: () => _deleteRoutine(userRoutines[index]),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  void _showCreateRoutineDialog() async {
    final Routine? newRoutine = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreateRoutineScreen(),
      ),
    );

    if (newRoutine != null) {
      // Get the index where the new routine will be added
      final newIndex = userRoutines.length;

      setState(() {
        // Add to data source
        _routineData.addRoutine(newRoutine);
        
        // Notify AnimatedList about the insertion
        _listKey.currentState?.insertItem(
          newIndex,
          duration: const Duration(milliseconds: 300),
        );
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Routine saved successfully'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  void _startRoutine(Routine routine) {
    // TODO: Implement routine start functionality
  }

  void _deleteRoutine(Routine routine) {
    final routineIndex = userRoutines.indexOf(routine);
    final routineName = routine.name;

    // Store the routine for undo
    final deletedRoutine = routine;

    // Remove from data source and get the index before removal
    setState(() {
      _routineData.deleteRoutine(routine.id);
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
              routine: deletedRoutine,
              onStart: () => _startRoutine(deletedRoutine),
              onEdit: () => _editRoutine(deletedRoutine),
              onDelete: () => _deleteRoutine(deletedRoutine),
            ),
          ),
        ),
        duration: const Duration(milliseconds: 300),
      );
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$routineName deleted'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
          action: SnackBarAction(
            label: 'Undo',
            textColor: Colors.white,
            onPressed: () {
              setState(() {
                _routineData.addRoutine(deletedRoutine);
                // Insert back into AnimatedList
                _listKey.currentState?.insertItem(
                  routineIndex,
                  duration: const Duration(milliseconds: 300),
                );
              });
            },
          ),
        ),
      );
    }
  }

  void _editRoutine(Routine routine) async {
    final Routine? updatedRoutine = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreateRoutineScreen(routine: routine),
      ),
    );

    if (updatedRoutine != null) {
      final index = userRoutines.indexWhere((r) => r.id == routine.id);
      setState(() {
        _routineData.updateRoutine(updatedRoutine);
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
                onEdit: () => _editRoutine(routine),
                onDelete: () => _deleteRoutine(routine),
              ),
            ),
          ),
          duration: const Duration(milliseconds: 150),
        );
        _listKey.currentState?.insertItem(
          index,
          duration: const Duration(milliseconds: 300),
        );
      });
    }
  }
}
