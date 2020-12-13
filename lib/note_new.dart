import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:note_app/note.dart';
import 'package:note_app/services/repository.dart';

class NoteNewView extends StatefulWidget {
  NoteNewView({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _NoteNewView();
}

class _NoteNewView extends State<NoteNewView> {
  _NoteNewView();
  final contenteController = TextEditingController();
  final titleController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    contenteController.dispose();
    titleController.dispose();
    passwordController.dispose();

    super.dispose();
  }

  void _save() async {
    var newNote = Note(
        title: titleController.text,
        content: contenteController.text,
        password: passwordController.text);

    await NoteRepository().insertNote(newNote);

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text("New note"),
        ),
        body: Padding(
            padding: const EdgeInsets.all(50.0),
            // child: Flexible(
            child: Column(children: <Widget>[
              TextField(
                autofocus: true,
                controller: titleController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Tittle',
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Password',
                ),
              ),
              SizedBox(height: 30),
              TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Note',
                  ),
                  controller: contenteController,
                  keyboardType: TextInputType.multiline,
                  maxLines: 20),
            ])),
        floatingActionButton: FloatingActionButton(
          onPressed: _save,
          tooltip: 'Increment',
          child: Icon(Icons.save),
        ),
      );
}
