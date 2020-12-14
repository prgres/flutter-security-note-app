import 'package:note_app/note.dart';
import 'package:flutter/material.dart';
import 'package:note_app/services/repository.dart';
import 'package:note_app/note_view_invalid_password_dialog.dart';
import 'package:note_app/note_view_password_succesfly_changed_dialog.dart';

class NoteItemChangePasswordDialog extends StatefulWidget {
  NoteItemChangePasswordDialog({Key key, this.note}) : super(key: key);
  final Note note;

  @override
  State<StatefulWidget> createState() =>
      _NoteItemChangePasswordDialogState(note: note);
}

class _NoteItemChangePasswordDialogState
    extends State<NoteItemChangePasswordDialog> {
  var _oldPasswordValid = true;
  var _newPasswordValid = true;

  _NoteItemChangePasswordDialogState({this.note});
  final oldPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();

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
                    height: 10,
                  ),
                  Text(
                    "Changing password",
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  TextField(
                    autofocus: true,
                    controller: oldPasswordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      errorText: _oldPasswordValid
                          ? null
                          : "Password must not be empty",
                      labelText: 'Old password',
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextField(
                    autofocus: false,
                    controller: newPasswordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      errorText: _newPasswordValid
                          ? null
                          : "Password must not be empty",
                      labelText: 'New password',
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
                            oldPasswordController.text = "";
                            newPasswordController.text = "";
                            Navigator.pop(context);
                          },
                          child: Text("Dismiss"),
                        ),
                        FlatButton(
                          onPressed: () async {
                            if (oldPasswordController.text.isNotEmpty) {
                              setState(() => _oldPasswordValid = true);
                            } else {
                              setState(() => _oldPasswordValid = false);
                              return;
                            }

                            if (newPasswordController.text.isNotEmpty) {
                              setState(() => _newPasswordValid = true);
                            } else {
                              setState(() => _newPasswordValid = false);
                              return;
                            }

                            try {
                              note.decrypt(oldPasswordController.text);
                            } catch (error) {
                              oldPasswordController.text = "";
                              newPasswordController.text = "";
                              showDialog(
                                  context: context,
                                  barrierDismissible: true,
                                  builder: (context) =>
                                      NoteViewInvalidPasswordDialog());
                              return;
                            }

                            await NoteRepository().changePassword(
                                note,
                                oldPasswordController.text,
                                newPasswordController.text);

                            Navigator.pop(context);
                            oldPasswordController.text = "";
                            newPasswordController.text = "";

                            showDialog(
                                context: context,
                                barrierDismissible: true,
                                builder: (context) =>
                                    NoteViewPasswordSuccesflyChangedDialog());
                          },
                          child: Text("Change"),
                        ),
                      ]),
                ],
              ),
            ),
          ),
        ),
      );
}
