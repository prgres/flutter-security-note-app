import 'package:encrypt/encrypt.dart';
import 'package:flutter/material.dart';
import 'package:note_app/services/login.dart';
import 'package:uuid/uuid.dart';

class User {
  String id;
  String password;
  String salt;

  static const String defaultUserID = "default";
  static const String biometricUserID = "biometric";

  Map<String, dynamic> toMap() => {
        'id': this.id,
        'password': this.password,
        'salt': this.salt,
      };

  User.biometricUser({@required this.password}) {
    this.id = User.biometricUserID;
    this.password = LoginService().generatePasswordHash(password);
    this.salt = String.fromCharCodes(SecureRandom(128).bytes);
  }

  User.defaultUser({@required this.password}) {
    this.id = User.defaultUserID;
    this.password = LoginService().generatePasswordHash(password);
    this.salt = String.fromCharCodes(SecureRandom(128).bytes);
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
