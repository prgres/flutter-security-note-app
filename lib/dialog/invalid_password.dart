import 'package:flutter/material.dart';

class InvalidPasswordDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) => AlertDialog(
        elevation: 0,
        title: Text("Invalid password"),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
        actions: [
          FlatButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Dismiss"),
          ),
        ],
      );
}
