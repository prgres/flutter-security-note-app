import 'package:flutter/material.dart';
import 'package:note_app/biometric.dart';
import 'package:note_app/home_screen.dart';
import 'package:note_app/startup/startup.dart';

// Startup
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(SecNoteApp());
}

class SecNoteApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SecNoteApp',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      routes: {
        '/home_screen': (context) => HomeScreen(),
        '/': (context) => Startup(),
      },
    );
  }
}
