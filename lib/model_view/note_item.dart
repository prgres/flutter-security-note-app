import 'package:note_app/model/note.dart';
import 'package:flutter/material.dart';
import 'package:note_app/dialog/delete_note.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:note_app/model_view/note_view.dart';
import 'package:note_app/services/secure_storage.dart';

class NoteItem extends StatelessWidget {
  NoteItem({this.note, this.refreshCallback});
  final globalKey = GlobalKey<ScaffoldState>();

  final Function refreshCallback;
  final Note note;

  Future<void> showNoteBtn(context) async =>
      await SecureStorage().readPassword().then((pass) => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => NoteView(
                    note: note,
                    password: pass,
                  ))));

  Future<void> deleteNoteBtn(context) async => await showDialog(
          context: context,
          barrierDismissible: true,
          builder: (context) => NoteItemDeleteDialog(note.id))
      .then((value) => refreshCallback());

  @override
  Widget build(BuildContext context) => InkWell(
      onTap: () async => showNoteBtn(context),
      child: Column(children: <Widget>[
        Slidable(
          key: ValueKey(note.title),
          actionPane: SlidableDrawerActionPane(),
          secondaryActions: <Widget>[
            IconSlideAction(
              caption: 'Delete',
              color: Colors.red,
              icon: Icons.delete,
              onTap: () async => deleteNoteBtn(context),
            ),
          ],
          dismissal: SlidableDismissal(
              onDismissed: (actionType) => deleteNoteBtn(context),
              child: SlidableDrawerDismissal()),
          child: ListTile(title: Text(note.title)),
        ),
      ]));
}
