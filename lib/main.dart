import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => TaskProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: TodoHome(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class TodoHome extends StatefulWidget {
  @override
  State<TodoHome> createState() => _TodoHomeState();
}

class _TodoHomeState extends State<TodoHome> {
  final taskController = TextEditingController();
  String selectedPriority = 'Normal';

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TaskProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('To-Do App (${provider.taskCount} tasks)'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: taskController,
              decoration: InputDecoration(
                labelText: 'Enter Task',
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                DropdownButton<String>(
                  value: selectedPriority,
                  items: ['Low', 'Normal', 'High']
                      .map((val) => DropdownMenuItem(value: val, child: Text(val)))
                      .toList(),
                  onChanged: (val) {
                    if (val != null) setState(() => selectedPriority = val);
                  },
                ),
                ElevatedButton(
                  onPressed: () {
                    final text = taskController.text.trim();
                    if (text.isNotEmpty) {
                      provider.addTask(text, selectedPriority);
                      taskController.clear();
                    }
                  },
                  child: Text('Add Task'),
                ),
              ],
            ),
            SizedBox(height: 20),
            Expanded(
              child: Consumer<TaskProvider>(
                builder: (_, taskData, __) {
                  return ListView.builder(
                    itemCount: taskData.taskCount,
                    itemBuilder: (_, index) {
                      final task = taskData.tasks[index];
                      return ListTile(
                        leading: Checkbox(
                          value: task.isDone,
                          onChanged: (_) => taskData.toggleTask(index),
                        ),
                        title: Text(
                          task.title,
                          style: TextStyle(
                            decoration: task.isDone ? TextDecoration.lineThrough : null,
                          ),
                        ),
                        subtitle: Text('Priority: ${task.priority}'),
                        trailing: IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () => taskData.deleteTask(index),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Task {
  final String title;
  final String priority;
  bool isDone;

  Task({required this.title, required this.priority, this.isDone = false});
}

class TaskProvider extends ChangeNotifier {
  final List<Task> _tasks = [];

  List<Task> get tasks => _tasks;

  int get taskCount => _tasks.length;

  void addTask(String title, String priority) {
    _tasks.add(Task(title: title, priority: priority));
    notifyListeners();
  }

  void toggleTask(int index) {
    _tasks[index].isDone = !_tasks[index].isDone;
    notifyListeners();
  }

  void deleteTask(int index) {
    _tasks.removeAt(index);
    notifyListeners();
  }
}
