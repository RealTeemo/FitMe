import 'package:flutter/material.dart';
import 'package:work_out_app/features/data/models/routine_model.dart';
import 'package:work_out_app/pages/routines/screens/routine_detail_screen.dart';

/// Card widget displaying a workout routine summary.
/// 
/// Features:
/// - Shows routine name and exercise count
/// - Displays target muscles
/// - Shows exercise previews in horizontal scroll
/// - Provides quick access to start, edit, and delete actions
class RoutineCard extends StatelessWidget {
  final Routine routine;
  final VoidCallback onStart;
  final VoidCallback onEdit;
  final VoidCallback onDelete;


  const RoutineCard({
    Key? key,
    required this.routine,
    required this.onStart,
    required this.onEdit,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RoutineDetailScreen(routine: routine),
          ),
        );
      },
      child: Card(
        margin: EdgeInsets.only(bottom: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Routine header
            ListTile(
              leading: Icon(Icons.fitness_center, color: Colors.blue),
              title: Text(
                routine.name,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                '${routine.exercises.length} exercises • ${routine.targetMuscles.join(", ")}',
                style: TextStyle(color: Colors.grey),
              ),
              trailing: PopupMenuButton(
                icon: Icon(Icons.more_vert),
                itemBuilder: (context) => [
                  PopupMenuItem(
                    child: Text('Edit'),
                    onTap: onEdit,
                  ),
                  PopupMenuItem(
                    child: Text('Delete', style: TextStyle(color: Colors.red)), 
                    onTap: onDelete,
                  )
                ],
              ),
            ),

            // Exercise previews
            if (routine.exercises.isNotEmpty)
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: routine.exercises.map((exercise) {
                    return Container(
                      margin: EdgeInsets.only(right: 8),
                      width: 80,
                      child: Column(
                        children: [
                          Container(
                            height: 60,
                            width: 60,
                            decoration: BoxDecoration(
                              color: Colors.grey[800],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(Icons.fitness_center),
                          ),
                          SizedBox(height: 4),
                          Text(
                            exercise.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),

            // Start button
            Padding(
              padding: EdgeInsets.all(16),
              child: ElevatedButton.icon(
                onPressed: onStart,
                icon: Icon(Icons.play_arrow),
                label: Text('Start Workout'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  minimumSize: Size(double.infinity, 40),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
} 