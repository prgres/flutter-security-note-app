import 'package:flutter/material.dart';
import 'package:note_app/model/user.dart';
import 'package:note_app/services/login.dart';
import 'package:note_app/services/repository.dart';
import 'package:note_app/services/secure_storage.dart';
import 'package:note_app/util/crypto.dart';

class NewUserDialog extends StatelessWidget {
  final passwordController = TextEditingController();
  final rePasswordController = TextEditingController();
  final _formKeyPass = GlobalKey<FormState>();

  void clearControllerText() {
    passwordController.text = "";
    rePasswordController.text = "";
  }

  String _textFromValidate(value) =>
      (value.isEmpty) ? 'Please enter some text' : null;

  Future<void> handleNewUser() async {
    String notePassword = CryptoUtil.getRandString();
    String biometricUserPassword = CryptoUtil.getRandString();

    await NoteRepository().insertUser(
        User.defaultUser(
          password: passwordController.text,
          notePassword: notePassword,
        ),
        notePassword);

    await NoteRepository()
        .insertUser(
            User.biometricUser(
                password: biometricUserPassword, notePassword: notePassword),
            notePassword)
        .then((value) =>
            SecureStorage().writeBiometricUserPassword(biometricUserPassword));

    LoginService().saveNotePassword(notePassword);
  }

  void craeteButtonOnPressed(BuildContext context) async =>
      _formKeyPass.currentState.validate()
          ? await handleNewUser().whenComplete(() => Navigator.pop(context))
          : clearControllerText();

  String passwordValidator(String value) {
    if (value.isEmpty) return 'Please enter some text';

    if (passwordController.text != rePasswordController.text)
      return "Password must be equal";

    return null;
  }

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
              onPressed: () => craeteButtonOnPressed(context),
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
                      validator: passwordValidator,
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
