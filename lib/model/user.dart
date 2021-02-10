import 'package:flutter/material.dart';
import 'package:note_app/util/crypto.dart';

class User {
  String id;
  String password;
  String _notePassword;
  String salt;

  static const String defaultUserID = "default";
  static const String biometricUserID = "biometric";

  User.biometricUser(
      {@required String password, String salt, @required String notePassword}) {
    this.id = User.biometricUserID;
    this.password = CryptoUtil.generatePasswordHash(password);
    var _salt = salt != null ? salt : CryptoUtil.generateSalt();
    this.salt = _salt;
    this.setNotePassword(notePassword, _salt);
  }

  User.defaultUser(
      {@required String password, String salt, @required String notePassword}) {
    this.id = User.defaultUserID;
    this.password = CryptoUtil.generatePasswordHash(password);
    var _salt = salt != null ? salt : CryptoUtil.generateSalt();
    this.salt = _salt;
    this.setNotePassword(notePassword, _salt);
  }

  User.loadFromDb({@required Map<dynamic, dynamic> userMap}) {
    this.id = userMap['id'];
    this.password = userMap['password'];
    this.notePassword = userMap['note_password'];
    this.salt = userMap['salt'];
  }

  String getNotePassword(pass) =>
      CryptoUtil.decrypt(password, this.salt, this._notePassword);

  set notePassword(String notePassword) {
    _notePassword = notePassword;
  }

  String get notePassword => _notePassword;

  void setNotePassword(String notePassword, String salt) {
    this._notePassword = CryptoUtil.encrypt(notePassword, this.password, salt);
  }

  Map<String, dynamic> toMap() => {
        'id': this.id,
        'password': this.password,
        'note_password': this._notePassword,
        'salt': this.salt,
      };
}
