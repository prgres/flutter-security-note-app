import 'package:flutter/material.dart';
import 'package:note_app/services/login.dart';
import 'package:note_app/services/repository_note.dart';
import 'package:note_app/dialog/invalid_password.dart';
import 'package:note_app/dialog/password_change_succesfly.dart';

class NoteItemChangePasswordDialog extends StatelessWidget {
  NoteItemChangePasswordDialog({@required this.refreshCallback});

  final oldPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();

  final _formKeyPass = GlobalKey<FormState>();
  final Function refreshCallback;

  Future<void> clearPasswordsControllerText() async {
    oldPasswordController.text = "";
    newPasswordController.text = "";
  }

  void dismissBtnOnTap(BuildContext context) async =>
      clearPasswordsControllerText().whenComplete(() => Navigator.pop(context));

  Future<void> handleInvalidPassword(BuildContext context) async =>
      await clearPasswordsControllerText().whenComplete(() => showDialog(
          context: context,
          barrierDismissible: true,
          builder: (context) => InvalidPasswordDialog()));

  Future<void> handleSuccPassword(BuildContext context) async =>
      await NoteRepository()
          .updateUserPassword(newPasswordController.text)
          .whenComplete(() {
        Navigator.pop(context);
        clearPasswordsControllerText();
        refreshCallback();
        showDialog(
            context: context,
            barrierDismissible: true,
            builder: (context) => PasswordChangeSuccessfullyDialog());
      });

  void changeBtnOnTap(BuildContext context) async => (!await LoginService()
          .validateDefaultUserPassword(oldPasswordController.text))
      ? await handleInvalidPassword(context)
      : await handleSuccPassword(context);

  String validatePasswordField(dynamic value) =>
      (value.isEmpty) ? 'Please enter some text' : null;

  @override
  Widget build(BuildContext context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
        actions: [
          FlatButton(
            onPressed: () => dismissBtnOnTap(context),
            child: Text("Dismiss"),
          ),
          FlatButton(
            onPressed: () => changeBtnOnTap(context),
            child: Text("Change"),
          ),
        ],
        elevation: 0,
        title: Text("Changing password"),
        content: IntrinsicHeight(
          child: Form(
            key: _formKeyPass,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                    margin: const EdgeInsets.only(top: 10.0),
                    child: TextFormField(
                      obscureText: true,
                      autofocus: true,
                      controller: oldPasswordController,
                      validator: validatePasswordField,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Old password',
                      ),
                    )),
                Container(
                  margin: const EdgeInsets.only(top: 10.0),
                  child: TextFormField(
                    obscureText: true,
                    autofocus: false,
                    controller: newPasswordController,
                    validator: validatePasswordField,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'New password',
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      );
}
