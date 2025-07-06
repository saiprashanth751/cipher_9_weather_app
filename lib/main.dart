import 'package:flutter/material.dart';

void main() {
  runApp(HabitTrackerApp());
}

class HabitTrackerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HabitTrackerHome(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class Habit {
  final String title;
  bool isDone;
  double progress;

  Habit({required this.title, this.isDone = false, this.progress = 0});
}

class HabitTrackerHome extends StatefulWidget {
  @override
  State<HabitTrackerHome> createState() => _HabitTrackerHomeState();
}

class _HabitTrackerHomeState extends State<HabitTrackerHome> {
  List<Habit> habits = [
    Habit(title: 'Drink Water'),
    Habit(title: 'Exercise'),
    Habit(title: 'Read Book'),
    Habit(title: 'Meditate'),
  ];

  void toggleHabit(int index) {
    setState(() {
      var habit = habits[index];
      habit.isDone = !habit.isDone;
      habit.progress = habit.isDone ? 1.0 : 0.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Habit Tracker')),
      body: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: habits.length,
        itemBuilder: (context, index) {
          final habit = habits[index];
          return Card(
            margin: EdgeInsets.only(bottom: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 4,
            child: InkWell(
              onTap: () => toggleHabit(index),
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            habit.title,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        AnimatedSwitcher(
                          duration: Duration(milliseconds: 300),
                          transitionBuilder: (child, anim) =>
                              ScaleTransition(scale: anim, child: child),
                          child: habit.isDone
                              ? Icon(Icons.check_circle, color: Colors.green, key: ValueKey(true))
                              : Icon(Icons.radio_button_unchecked, color: Colors.grey, key: ValueKey(false)),
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
                    AnimatedContainer(
                      duration: Duration(milliseconds: 500),
                      height: 10,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: AnimatedContainer(
                          duration: Duration(milliseconds: 500),
                          width: MediaQuery.of(context).size.width * habit.progress * 0.8,
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
