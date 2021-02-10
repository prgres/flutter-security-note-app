import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:note_app/services/repository_note.dart';
import 'package:note_app/startup/new_user.dart';
import 'package:note_app/startup/login.dart';

class Startup extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _StartupState();
}

class _StartupState extends State<Startup> {
  @override
  void initState() {
    super.initState();
    handleUserState();
  }

  Future<void> handleNewUser() async => showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => NewUserDialog(),
      );

  Future<void> handleLogin() async => showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => LoginDialog(),
      );

  Future<void> handleUserState() async => await NoteRepository()
      .getUserFromDB()
      .then((fetchedUser) =>
          (fetchedUser.length == 0) ? handleNewUser() : handleLogin())
      .then((_) => Navigator.popAndPushNamed(context, "/home_screen"));

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Container(
          child: Center(
            child: RichText(
              text: TextSpan(
                text: "flutter note app",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                  decorationStyle: TextDecorationStyle.wavy,
                ),
              ),
            ),
          ),
        ),
      );
}
