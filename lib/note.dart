import 'package:encrypt/encrypt.dart' as enc;
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class Note {
  String id;
  String title;
  String content;

  Map<String, dynamic> toJson() =>
      {"id": this.id, "title": this.title, "content": this.content};

  enc.Key _generateKey(String password) {
    String key = password;

    if (password.length < 32) {
      final diff = 32 - password.length;
      final rep = diff ~/ password.length;
      final mod = diff % password.length;

      for (var i = 0; i < rep; i++) {
        key += password;
      }

      if (mod != 0) {
        for (var i = 0; i < mod; i++) {
          key += password[i];
        }
      }
    }

    return enc.Key.fromUtf8(key);
  }

  String decrypt(String password) {
    final key = _generateKey(password);
    final iv = enc.IV.fromLength(16);

    var encrypter = enc.Encrypter(enc.AES(key));

    // try {
    var decrypted =
        encrypter.decrypt(enc.Encrypted.fromBase64(this.content), iv: iv);
    return decrypted;
    // } catch (error) {
    // return content;
    // }
  }

  String encrypt(String content, String password) {
    final key = _generateKey(password);
    final iv = enc.IV.fromLength(16);

    var encrypter = enc.Encrypter(enc.AES(key));
    var encrypted = encrypter.encrypt(content, iv: iv);

    return encrypted.base64;
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

  Note({@required this.title, @required content, @required password}) {
    this.id = Uuid().v4();
    this.content = encrypt(content, password);
  }

  Note.fromDb(
      {@required this.id, @required this.title, @required this.content});
}
