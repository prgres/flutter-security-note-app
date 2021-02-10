import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:note_app/dialog/invalid_password.dart';
import 'package:note_app/services/biometric.dart';
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

  @override
  void initState() {
    super.initState();
    _biometricButtonOnPressed();
  }

  @override
  void dispose() {
    passwordController.text = "";
    super.dispose();
  }

  Future<bool> _checkIfBiometricAvailable() async {
    if (!await Biometric().checkBiometrics()) return false;

    if (!await Biometric()
        .getAvailableBiometrics()
        .then((value) => value.length != 0)) return false;

    if (!await Biometric().authenticate()) return false;

    return true;
  }

  void _biometricButtonOnPressed() async => await _checkIfBiometricAvailable()
      ? await LoginService()
          .handleBiometricLogin()
          .whenComplete(() => Navigator.pop(context))
      : false;

  Future<void> _loginButtonOnPressed() async =>
      (!await LoginService().handleDefaultLogin(passwordController.text))
          ? await _handleFailedLogin()
          : Navigator.pop(context);

  Future<void> _handleFailedLogin() async {
    passwordController.text = "";
    await showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) => InvalidPasswordDialog());
  }

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
              onPressed: _loginButtonOnPressed,
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
                  IconButton(
                    icon: Icon(Icons.fingerprint),
                    onPressed: _biometricButtonOnPressed,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
}
