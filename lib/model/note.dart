import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:note_app/util/crypto.dart';

class Note {
  String id;
  String title;
  String salt;
  String _content;

  String getContent(String password) =>
      CryptoUtil.decrypt(password, this.salt, this._content);

  void setContent(String content) => this._content = content;

  Map<String, dynamic> toMap() => {
        'id': this.id,
        'title': this.title,
        'content': this._content,
        'salt': this.salt,
      };

  Note changePassword(String oldPassword, newPassword) {
    this._content = CryptoUtil.encrypt(
        CryptoUtil.decrypt(oldPassword, this.salt, this._content),
        newPassword,
        this.salt);

    return this;
  }

  Note({
    @required this.title,
    @required String content,
    @required String password,
  }) {
    this.id = Uuid().v4();
    this.salt = CryptoUtil.generateSalt();
    this._content = CryptoUtil.encrypt(content, password, this.salt);
  }

  Note.parseFromDb(dynamic map) {
    this.id = map['id'];
    this.title = map['title'];
    this._content = map['content'];
    this.salt = map['salt'];
  }

  Note.fromDb({
    @required this.id,
    @required this.title,
    @required content,
  }) {
    this.setContent(content);
  }

  Map<String, dynamic> toJson() =>
      {"id": this.id, "title": this.title, "content": this._content};
}
