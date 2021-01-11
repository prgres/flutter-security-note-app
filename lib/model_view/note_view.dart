import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:note_app/model/note.dart';

class NoteView extends StatelessWidget {
  NoteView({Key key, @required this.note, @required this.password});

  final Note note;
  final String password;

  String _decryptNote(String password) {
    try {
      return note.decrypt(password);
    } catch (e) {
      print("decryption failed");
      print(e);
      return "decryption failed";
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: Text("note")),
        body: Container(
          child: Center(
            child: Text(
              _decryptNote(password),
              style: TextStyle(
                fontSize: 20,
                color: Colors.black,
                decorationStyle: TextDecorationStyle.wavy,
              ),
            ),
          ),
        ),
      );
}
