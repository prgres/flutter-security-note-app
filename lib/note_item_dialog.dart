import 'package:note_app/note.dart';
import 'package:flutter/material.dart';
import 'package:note_app/note_view.dart';
import 'package:note_app/note_view_invalid_password_dialog.dart';

class NoteItemDialog extends StatefulWidget {
  NoteItemDialog({Key key, this.note}) : super(key: key);
  final Note note;

  @override
  State<StatefulWidget> createState() => _NoteItemDialogState(note: note);
}

class _NoteItemDialogState extends State<NoteItemDialog> {
  var _passwordValid = true;

  _NoteItemDialogState({this.note});
  final passwordController = TextEditingController();

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
                    note.title,
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
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      errorText:
                          _passwordValid ? null : "Password must not be empty",
                      labelText: 'Password',
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
                            passwordController.text = "";
                            Navigator.pop(context);
                          },
                          child: Text("Dismiss"),
                        ),
                        FlatButton(
                          onPressed: () {
                            if (passwordController.text.isEmpty) {
                              setState(() {
                                _passwordValid = false;
                              });
                              return;
                            }

                            try {
                              note.decrypt(passwordController.text);
                            } catch (error) {
                              showDialog(
                                  context: context,
                                  barrierDismissible: true,
                                  builder: (context) =>
                                      NoteViewInvalidPasswordDialog());
                              return;
                            }

                            Navigator.pop(context);

                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => NoteView(
                                          note: note,
                                          password: passwordController.text,
                                        ))).whenComplete(
                                () => passwordController.text = "");
                          },
                          child: Text("Unlock"),
                        ),
                      ]),
                ],
              ),
            ),
          ),
        ),
      );
}
