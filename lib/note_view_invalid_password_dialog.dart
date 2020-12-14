import 'package:flutter/material.dart';

class NoteViewInvalidPasswordDialog extends StatefulWidget {
  NoteViewInvalidPasswordDialog({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _NoteViewInvalidPasswordDialogState();
}

class _NoteViewInvalidPasswordDialogState
    extends State<NoteViewInvalidPasswordDialog> {
  _NoteViewInvalidPasswordDialogState();

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
                    "Invalid password",
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: FlatButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text("Dismiss"),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
}
