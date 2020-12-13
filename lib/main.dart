import 'package:flutter/material.dart';
import 'package:note_app/home_screen.dart';
// import 'package:note_app/services/database.dart';
// import 'package:note_app/services/repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // NotesDatabaseService.db.getDB();
  // await NoteRepository().database;

  runApp(SecNoteApp());
}

class SecNoteApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SecNoteApp',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      routes: {
        '/': (context) => HomeScreen(),
      },
    );
  }
}
