import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/login_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/task_list_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Student Task Manager',
      initialRoute: '/',
      routes: {
        '/': (context) => LoginScreen(),
        '/profile': (context) => ProfileScreen(),
        '/tasks': (context) => TaskListScreen(),
      },
    );
  }
}

