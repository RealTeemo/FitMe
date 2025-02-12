import 'package:flutter/material.dart';

/// FilterButton is a reusable widget for filtering exercises by different criteria.
/// Features:
/// - Shows current selection status with color
/// - Opens bottom sheet with options when tapped
/// - Allows selecting and deselecting options
/// - Supports "All" option to clear filter
class FilterButton extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<String> options;
  final String? selectedValue;
  final Function(String?) onChanged;

  FilterButton({
    required this.title,
    required this.icon,
    required this.options,
    required this.selectedValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      child: ElevatedButton.icon(
        icon: Icon(icon, size: 18),
        label: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(selectedValue ?? title),
            Icon(Icons.arrow_drop_down),
          ],
        ),
        // Change button color based on selection state
        style: ElevatedButton.styleFrom(
          backgroundColor: selectedValue != null ? Colors.blue : Colors.grey[800],
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        ),
        onPressed: () {
          // Show bottom sheet with filter options
          showModalBottomSheet(
            context: context,
            builder: (BuildContext context) {
              return Container(
                color: Colors.grey[900],
                child: ListView(
                  children: [
                    // Title of the filter
                    ListTile(
                      title: Text(
                        'Select $title',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Divider(color: Colors.grey),
                    // "All" option to clear filter
                    ListTile(
                      title: Text(
                        'All',
                        style: TextStyle(color: Colors.white),
                      ),
                      trailing: selectedValue == null
                          ? Icon(Icons.check, color: Colors.blue)
                          : null,
                      onTap: () {
                        onChanged(null);
                        Navigator.pop(context);
                      },
                    ),
                    // List of filter options
                    ...options.map((option) => ListTile(
                          title: Text(
                            option,
                            style: TextStyle(color: Colors.white),
                          ),
                          trailing: selectedValue == option
                              ? Icon(Icons.check, color: Colors.blue)
                              : null,
                          onTap: () {
                            onChanged(option == selectedValue ? null : option);
                            Navigator.pop(context);
                          },
                        )),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
