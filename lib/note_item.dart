import 'package:note_app/model/note.dart';
import 'package:flutter/material.dart';
import 'package:note_app/dialog/delete_note.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:note_app/note_view.dart';
import 'package:note_app/services/secure_storage.dart';

class NoteItem extends StatelessWidget {
  NoteItem({this.note, this.refreshCallback});
  final globalKey = GlobalKey<ScaffoldState>();

  final Function refreshCallback;
  final Note note;

  Future<void> showNoteBtn(context) async {
    var pass = await SecureStorage().readPassword();

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => NoteView(
                  note: note,
                  password: pass,
                )));
  }

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
              onTap: () async => await showDialog(
                      context: context,
                      barrierDismissible: true,
                      builder: (context) => NoteItemDeleteDialog(note.id))
                  .then((value) => refreshCallback()),
            ),
          ],
          dismissal: SlidableDismissal(child: SlidableDrawerDismissal()),
          child: ListTile(title: Text(note.title)),
        ),
      ]));
}
