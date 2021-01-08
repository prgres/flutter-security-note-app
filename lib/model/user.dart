import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class User {
  String id;
  String password;

  Map<String, dynamic> toJson() => {"id": this.id, "password": this.password};

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'password': this.password,
    };
  }

  User({@required this.password}) {
    this.id = Uuid().v4();
  }

  User.fromDb({
    @required this.id,
    @required this.password,
  });

  User.loadFromDb({@required Map<dynamic, dynamic> userMap}) {
    this.id = userMap['id'];
    this.password = userMap['password'];
  }
}
