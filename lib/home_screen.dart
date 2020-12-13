import 'package:flutter/material.dart';
import 'package:note_app/note.dart';
import 'package:note_app/note_item.dart';
import 'package:note_app/note_new.dart';
import 'package:note_app/services/repository.dart';

class HomeScreen extends StatefulWidget {
  final String title = "SecNoteApp";

  HomeScreen({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<NoteItem> noteItemList = [];

  void _addButtonTap() async {
    await Navigator.push(
        context, MaterialPageRoute(builder: (context) => NoteNewView()));

    setNotesList();
  }

  @override
  void initState() {
    super.initState();
    setNotesList();
  }

  setNotesList() async {
    print("Entered setNotes");
    var fetchedNotes = await NoteRepository().getNotesFromDB();

    setState(() {
      var notes = fetchedNotes;
      List<NoteItem> tmpList = [];

      for (var it in parseNoteToObj(notes)) {
        tmpList.add(NoteItem(note: it));
      }

      this.noteItemList = tmpList;
    });
  }

  List<Note> parseNoteToObj(List<Map> maps) {
    List<Note> notesList = [];

    if (maps.length > 0) {
      maps.forEach((map) {
        notesList.add(Note.fromDb(
          id: map['id'],
          title: map['title'],
          content: map['content'],
        ));
      });
    }

    return notesList;
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: ListView(
          children: noteItemList,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _addButtonTap,
          tooltip: 'Increment',
          child: Icon(Icons.add),
        ),
      );
}
