import 'package:encrypt/encrypt.dart' as enc;
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';

class Note {
  String id;
  String title;
  String content;

  Map<String, dynamic> toJson() =>
      {"id": this.id, "title": this.title, "content": this.content};

  String _generateMd5(String input) {
    return md5.convert(utf8.encode(input)).toString();
  }

  enc.Key _generateKey(String password) =>
      enc.Key.fromUtf8(_generateMd5(password));

  String decrypt(String password) {
    final key = _generateKey(password);
    final iv = enc.IV.fromLength(16);
    final encrypter = enc.Encrypter(enc.AES(key));

    return encrypter.decrypt(enc.Encrypted.fromBase64(this.content), iv: iv);
  }

  String encrypt(String content, String password) {
    final key = _generateKey(password);
    final iv = enc.IV.fromLength(16);
    final encrypter = enc.Encrypter(enc.AES(key));

    return encrypter.encrypt(content, iv: iv).base64;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'title': this.title,
      'content': this.content,
    };
  }

  Note changePassword(String oldPassword, newPassword) {
    var decrypted = decrypt(oldPassword);
    var encrypted = encrypt(decrypted, newPassword);
    this.content = encrypted;

    return this;
  }

  Note(
      {@required this.title,
      @required String content,
      @required String password}) {
    this.id = Uuid().v4();
    this.content = encrypt(content, password);
  }

  Note.parseFromDb(dynamic map) {
    this.id = map['id'];
    this.title = map['title'];
    this.content = map['content'];
  }

  Note.fromDb(
      {@required this.id, @required this.title, @required this.content});
}
