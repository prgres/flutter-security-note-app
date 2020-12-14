import 'package:flutter/material.dart';

class NoteViewPasswordSuccesflyChangedDialog extends StatefulWidget {
  NoteViewPasswordSuccesflyChangedDialog({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() =>
      _NoteViewPasswordSuccesflyChangedDialogState();
}

class _NoteViewPasswordSuccesflyChangedDialogState
    extends State<NoteViewPasswordSuccesflyChangedDialog> {
  _NoteViewPasswordSuccesflyChangedDialogState();

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
                    "Password change successfully",
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
