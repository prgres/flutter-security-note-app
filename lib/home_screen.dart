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

  Future<void> setNotesList() async {
    print("Entered setNotes");
    var fetchedNotes = await NoteRepository().getNotesFromDB();

    setState(() {
      refreshList(fetchedNotes);
    });
  }

  void refreshList(notes) {
    List<NoteItem> tmpList = [];

    for (var it in parseNoteToObj(
      notes,
    )) {
      tmpList.add(NoteItem(note: it, refreshCallback: setNotesList));
    }

    this.noteItemList = tmpList;
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
        body: _buildList(),
        floatingActionButton: FloatingActionButton(
          onPressed: _addButtonTap,
          tooltip: 'Increment',
          child: Icon(Icons.add),
        ),
      );

  Widget _buildList() {
    return noteItemList.length != 0
        ? RefreshIndicator(
            child: ListView.builder(
                padding: EdgeInsets.only(
                    left: 20.0, right: 20.0, top: 20.0, bottom: 20.0),
                itemCount: noteItemList.length,
                itemBuilder: (BuildContext context, int index) {
                  return new Card(
                    margin: EdgeInsets.only(bottom: 10),
                    child: Column(
                      children: <Widget>[
                        noteItemList[index],
                      ],
                    ),
                  );
                }),
            onRefresh: setNotesList,
          )
        : Center(child: CircularProgressIndicator());
  }
}
