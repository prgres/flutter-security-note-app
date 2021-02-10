import 'package:flutter/material.dart';
import 'package:note_app/services/repository_note.dart';

class NoteItemDeleteDialog extends StatelessWidget {
  NoteItemDeleteDialog(this.id);

  final String id;

  @override
  Widget build(BuildContext context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
        elevation: 0,
        actions: [
          FlatButton(
            child: Text("Dismiss"),
            onPressed: () => Navigator.pop(context),
          ),
          FlatButton(
            child: Text("Yes"),
            onPressed: () async => await NoteRepository()
                .deleteNote(this.id)
                .then((value) => Navigator.pop(context, '/home_screen')),
          ),
        ],
        title: Text("Are you sure?"),
      );
}
