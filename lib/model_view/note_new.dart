import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:note_app/model/note.dart';
import 'package:note_app/services/repository.dart';
import 'package:note_app/services/secure_storage.dart';

class NoteNewView extends StatelessWidget {
  NoteNewView();

  final contenteController = TextEditingController();
  final titleController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void _save(BuildContext context) async => await SecureStorage()
      .readPassword()
      .then((pass) => Note(
          title: titleController.text,
          content: contenteController.text,
          password: pass,
          salt: NoteRepository))
      .then((newNote) => NoteRepository().insertNote(newNote))
      .whenComplete(() => Navigator.pop(context));

  String validateTextFrom(value) =>
      (value.isEmpty) ? 'Please enter some text' : null;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text("New note"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  Container(
                      margin: const EdgeInsets.only(
                        top: 5.0,
                        bottom: 15.0,
                      ),
                      child: TextFormField(
                          validator: validateTextFrom,
                          autofocus: true,
                          controller: titleController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Tittle',
                          ))),
                  Container(
                    child: TextFormField(
                        validator: validateTextFrom,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Note',
                        ),
                        controller: contenteController,
                        keyboardType: TextInputType.multiline,
                        maxLines: 15),
                  ),
                ],
              ),
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _save(context),
          tooltip: 'Increment',
          child: Icon(Icons.save),
        ),
      );
}
