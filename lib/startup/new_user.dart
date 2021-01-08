import 'package:flutter/material.dart';
import 'package:note_app/services/repository.dart';

class NewUserDialog extends StatefulWidget {
  NewUserDialog({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _NewUserDialogState();
}

class _NewUserDialogState extends State<NewUserDialog> {
  _NewUserDialogState();

  final passwordController = TextEditingController();
  final rePasswordController = TextEditingController();
  final _formKeyPass = GlobalKey<FormState>();

  void clearControllerText() {
    passwordController.text = "";
    rePasswordController.text = "";
  }

  String _textFromValidate(value) =>
      (value.isEmpty) ? 'Please enter some text' : null;

  void craeteButtonOnPressed() async => (!_formKeyPass.currentState.validate())
      ? clearControllerText()
      : await NoteRepository()
          .insertUser(passwordController.text)
          .whenComplete(() => Navigator.pop(context));

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Colors.transparent,
        body: AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
          elevation: 0,
          title: Text("Set a new password"),
          actions: [
            FlatButton(
              onPressed: craeteButtonOnPressed,
              child: Text("Create"),
            ),
          ],
          content: IntrinsicHeight(
            child: Form(
              key: _formKeyPass,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    margin: const EdgeInsets.only(
                      top: 10.0,
                      bottom: 10.0,
                    ),
                    child: TextFormField(
                      autofocus: true,
                      controller: passwordController,
                      obscureText: true,
                      validator: _textFromValidate,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Password',
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(
                      top: 10.0,
                      bottom: 10.0,
                    ),
                    child: TextFormField(
                      autofocus: true,
                      controller: rePasswordController,
                      obscureText: true,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter some text';
                        }

                        if (passwordController.text !=
                            rePasswordController.text) {
                          return "Password must be equal";
                        }

                        return null;
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'confirm password',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
}
