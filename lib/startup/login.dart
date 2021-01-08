import 'package:flutter/material.dart';
import 'package:note_app/services/login.dart';

class LoginDialog extends StatefulWidget {
  LoginDialog({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _LoginDialogState();
}

class _LoginDialogState extends State<LoginDialog> {
  _LoginDialogState();

  final passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void _handleFailedLogin() {
    print("failed valid");
    passwordController.text = "";

    return;
  }

  Future<void> _handleSuccLogin() async => await LoginService()
      .savePassword(passwordController.text)
      .whenComplete(() => Navigator.pop(context));

  void loginButtonOnPressed() async =>
      (!await LoginService().validatePassword(passwordController.text))
          ? _handleFailedLogin()
          : await _handleSuccLogin();

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Colors.transparent,
        body: AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
          elevation: 0,
          title: Text("Enter the password"),
          actions: [
            FlatButton(
              child: Text("Unlock"),
              onPressed: loginButtonOnPressed,
            ),
          ],
          content: IntrinsicHeight(
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  Container(
                    margin: const EdgeInsets.only(
                      top: 10.0,
                      bottom: 10.0,
                    ),
                    child: TextFormField(
                      validator: (value) =>
                          (value.isEmpty) ? 'Please enter some text' : null,
                      autofocus: true,
                      controller: passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Password',
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
