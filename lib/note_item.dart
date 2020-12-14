import 'package:note_app/note.dart';
import 'package:flutter/material.dart';
import 'package:note_app/note_item_dialog.dart';
import 'package:note_app/note_item_delete_dialog.dart';
import 'package:note_app/note_item_change_password_dialog.dart';

import 'package:flutter_slidable/flutter_slidable.dart';

class NoteItem extends StatelessWidget {
  // NoteItem({this.note});

  NoteItem({this.note, this.refreshCallback});
  final Function refreshCallback;

  final passwordController = TextEditingController();
  final Note note;

  @override
  Widget build(BuildContext context) => InkWell(
      onTap: () {
        showDialog(
            context: context,
            barrierDismissible: true,
            builder: (context) => NoteItemDialog(note: note));
      },
      child: Column(children: <Widget>[
        Slidable(
          key: ValueKey(note.title),
          actionPane: SlidableDrawerActionPane(),
          secondaryActions: <Widget>[
            IconSlideAction(
              caption: 'Change password',
              color: Colors.grey.shade200,
              icon: Icons.more_horiz,
              onTap: () async {
                showDialog(
                  context: context,
                  barrierDismissible: true,
                  builder: (context) =>
                      NoteItemChangePasswordDialog(note: note),
                );
              },
            ),
            IconSlideAction(
              caption: 'Delete',
              color: Colors.red,
              icon: Icons.delete,
              onTap: () async {
                showDialog(
                  context: context,
                  barrierDismissible: true,
                  builder: (context) => NoteItemDeleteDialog(
                      note: note, refreshCallback: refreshCallback),
                );
              },
            ),
          ],
          dismissal: SlidableDismissal(
            child: SlidableDrawerDismissal(),
          ),
          child: ListTile(
            title: Text(note.title),
          ),
        ),
      ]));
}
