import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:note_app/note.dart';

class NoteView extends StatefulWidget {
  NoteView({Key key, @required this.note, @required this.password})
      : super(key: key);

  final Note note;
  final String password;

  @override
  State<StatefulWidget> createState() =>
      _NoteView(note: note, password: password);
}

class _NoteView extends State<NoteView> {
  final Note note;
  final String password;

  _NoteView({@required this.note, @required this.password});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text("note"),
        ),
        body: Container(
            child: Center(
                child: RichText(
                    text: TextSpan(
          text: note.decrypt(password),
          style: TextStyle(
            fontSize: 20,
            color: Colors.black,
            decorationStyle: TextDecorationStyle.wavy,
          ),
        )))),
      );
}
