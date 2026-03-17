import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/task.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({Key? key}) : super(key: key);

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  List<Task> tasks = [];
  final List<Task> defaultTasks = [
    Task(title: 'Assignment 1', courseCode: 'CSC101', dueDate: DateTime(2026, 3, 20)),
    Task(title: 'Project Report', courseCode: 'CSC202', dueDate: DateTime(2026, 3, 25)),
    Task(title: 'Midterm Exam', courseCode: 'CSC303', dueDate: DateTime(2026, 3, 30)),
  ];

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final String? tasksJson = prefs.getString('tasks');
    if (tasksJson != null) {
      final List decoded = jsonDecode(tasksJson);
      setState(() {
        tasks = decoded.map((e) => Task(
          title: e['title'],
          courseCode: e['courseCode'],
          dueDate: DateTime.parse(e['dueDate']),
          isComplete: e['isComplete'] ?? false,
        )).toList();
      });
    } else {
      setState(() {
        tasks = List.from(defaultTasks);
      });
    }
  }

  Future<void> _saveTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final List<Map<String, dynamic>> taskList = tasks.map((task) => {
      'title': task.title,
      'courseCode': task.courseCode,
      'dueDate': task.dueDate.toIso8601String(),
      'isComplete': task.isComplete,
    }).toList();
    await prefs.setString('tasks', jsonEncode(taskList));
  }

  void _addTask(Task task) {
    setState(() {
      tasks.add(task);
    });
    _saveTasks();
  }

  void _showAddTaskDialog() async {
    String title = '';
    String courseCode = '';
    DateTime? dueDate;
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Task'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(labelText: 'Title'),
                onChanged: (value) => title = value,
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Course Code'),
                onChanged: (value) => courseCode = value,
              ),
              ElevatedButton(
                onPressed: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2030),
                  );
                  if (picked != null) {
                    dueDate = picked;
                  }
                },
                child: const Text('Pick Due Date'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (title.isNotEmpty && courseCode.isNotEmpty && dueDate != null) {
                  _addTask(Task(title: title, courseCode: courseCode, dueDate: dueDate!));
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Save'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Task List')),
      body: ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          final task = tasks[index];
          return ListTile(
            title: Text(task.title),
            subtitle: Text('Course: ${task.courseCode}\nDue: ${_formatDate(task.dueDate)}'),
            trailing: Checkbox(
              value: task.isComplete,
              onChanged: (val) {
                setState(() {
                  task.isComplete = val ?? false;
                });
                _saveTasks();
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTaskDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}
