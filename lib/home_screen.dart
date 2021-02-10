import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:note_app/model/note.dart';
import 'package:note_app/model_view/note_item.dart';
import 'package:note_app/dialog/change_password.dart';
import 'package:note_app/model_view/note_new.dart';
import 'package:note_app/services/repository_note.dart';

class HomeScreen extends StatefulWidget {
  final String title = "SecNoteApp";

  HomeScreen({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<NoteItem> noteItemList = [];

  void _addButtonTap() async => await Navigator.push(
          context, MaterialPageRoute(builder: (context) => NoteNewView()))
      .then((value) => setNotesList());

  @override
  void initState() {
    super.initState();
    setNotesList();
  }

  Future<void> setNotesList() async {
    print("Entered setNotes");
    var fetchedNotes = await NoteRepository().getNotesFromDB();

    setState(() => refreshList(fetchedNotes));
  }

  void refreshList(List<Note> notes) {
    this.noteItemList = [];

    notes.forEach((e) =>
        noteItemList.add(NoteItem(note: e, refreshCallback: setNotesList)));
  }

  void _settingsButtonTap() async => await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) =>
          NoteItemChangePasswordDialog(refreshCallback: setNotesList));

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: _buildAppBar(),
        body: _buildList(),
      );

  Widget _buildList() =>
      (noteItemList.length != 0) ? _buildRefreshIndicator() : null;

  Widget _buildAppBar() => AppBar(
          title: Text(widget.title),
          leading: CupertinoButton(
            onPressed: _addButtonTap,
            child: Icon(
              CupertinoIcons.add,
              color: Colors.white,
            ),
          ),
          actions: [
            FlatButton(
              onPressed: _settingsButtonTap,
              child: Icon(
                Icons.settings,
                color: Colors.white,
              ),
            )
          ]);

  Widget _buildRefreshIndicator() => RefreshIndicator(
        onRefresh: setNotesList,
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
      );
}
