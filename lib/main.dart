import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:work_out_app/pages/exercise/screens/exercise.dart';
import 'package:work_out_app/pages/routines/screens/routine.dart';
import 'package:provider/provider.dart';
import 'package:work_out_app/providers/exercise_provider.dart';

void main() {
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) => ExerciseProvider()),
  ], child: WorkoutTaskManagerApp()));
}

class WorkoutTaskManagerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Workout Task Manager',
      theme: ThemeData.dark().copyWith(
        primaryColor: Colors.blue,
        scaffoldBackgroundColor: Colors.black,
        pageTransitionsTheme: PageTransitionsTheme(
          builders: {
            TargetPlatform.android: CupertinoPageTransitionsBuilder(),
            TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          },
        ),
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  late PageController _pageController;
  
  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _selectedIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _pageController.animateToPage(
        index,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Workout Task Manager'),
        centerTitle: true,
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        children: [
          RoutineScreen(),
          ExerciseScreen(),
          _buildTestScreen(),
          _buildHomeContent(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.grey[900],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.format_list_bulleted),
            label: 'Routines',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.watch_later_outlined),
            label: 'Exercises',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.fitness_center),
            label: 'Workout',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Account',
          ),
        ],
      ),
    );
  }

  Widget _buildHomeContent() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: CircularPercentIndicator(
            radius: 120.0,
            lineWidth: 13.0,
            animation: true,
            percent: 0.6,
            center: Text(
              "60%",
              style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            circularStrokeCap: CircularStrokeCap.round,
            progressColor: Colors.blue,
            backgroundColor: Colors.grey[800]!,
          ),
        ),
        SizedBox(height: 40.0),
        _buildButton(context, "Start Workout", Icons.fitness_center, Colors.green),
        _buildButton(context, "Workout History", Icons.history, Colors.orange),
        _buildButton(context, "Set Reminder", Icons.notifications, Colors.blue),
      ],
    );
  }

  Widget _buildButton(BuildContext context, String text, IconData icon, Color color) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 50.0, vertical: 10.0),
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 15.0),
          backgroundColor: color,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        ),
        icon: Icon(icon, color: Colors.white),
        label: Text(
          text,
          style: TextStyle(fontSize: 18.0, color: Colors.white, fontWeight: FontWeight.bold),
        ),
        onPressed: () {},
      ),
    );
  }

  Widget _buildTestScreen() {
    return const Scaffold(
      body: Center(
        child: Text('Working In Progress'),
      ),
    );
  }
}
