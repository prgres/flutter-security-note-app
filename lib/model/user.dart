import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class User {
  String id;
  String password;
  String salt;

  Map<String, dynamic> toJson() =>
      {"id": this.id, "password": this.password, "salt": this.salt};

  Map<String, dynamic> toMap() => {
        'id': this.id,
        'password': this.password,
        'salt': this.salt,
      };

  User({@required this.password}) {
    this.id = Uuid().v4();
  }

  User.fromDb({
    @required this.id,
    @required this.password,
    @required this.salt,
  });

  User.loadFromDb({@required Map<dynamic, dynamic> userMap}) {
    this.id = userMap['id'];
    this.password = userMap['password'];
    this.salt = userMap['salt'];
  }
}
