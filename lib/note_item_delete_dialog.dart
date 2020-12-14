import 'package:note_app/note.dart';
import 'package:flutter/material.dart';
import 'package:note_app/services/repository.dart';

class NoteItemDeleteDialog extends StatefulWidget {
  NoteItemDeleteDialog({Key key, this.note, this.refreshCallback})
      : super(key: key);
  final Function refreshCallback;

  final Note note;

  @override
  State<StatefulWidget> createState() =>
      _NoteItemDeleteDialog(note: note, refreshCallback: refreshCallback);
}

class _NoteItemDeleteDialog extends State<NoteItemDeleteDialog> {
  _NoteItemDeleteDialog({this.note, this.refreshCallback});
  final Function refreshCallback;

  final Note note;
  @override
  Widget build(BuildContext context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
        elevation: 0,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 10,
          ),
          child: IntrinsicWidth(
            child: IntrinsicHeight(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Are you sure?",
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        FlatButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text("Dismiss"),
                        ),
                        FlatButton(
                          onPressed: () async {
                            await NoteRepository().deleteNote(note.id);
                            await refreshCallback();
                            Navigator.pop(context);
                          },
                          child: Text("Yes"),
                        ),
                      ]),
                ],
              ),
            ),
          ),
        ),
      );
}
