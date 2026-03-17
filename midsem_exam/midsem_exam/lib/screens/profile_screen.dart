import 'package:flutter/material.dart';
import '../models/student.dart';
import 'task_list_screen.dart';

class ProfileScreen extends StatelessWidget {
  final Student student = Student(
    name: 'John Doe',
    studentId: 'S12345',
    programName: 'Computer Science',
    level: 300,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  radius: 40,
                  child: Text(
                    student.name[0], // initial
                    style: const TextStyle(fontSize: 30),
                  ),
                ),
                const SizedBox(height: 16),
                Text('Name: ${student.name}', style: const TextStyle(fontSize: 18)),
                Text('ID: ${student.studentId}'),
                Text('Programme: ${student.programName}'),
                Text('Level: ${student.level}'),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {}, // Edit profile not implemented
                  child: const Text('Edit Profile'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const TaskListScreen()),
                    );
                  },
                  child: const Text('View Tasks'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
// ...existing code...
