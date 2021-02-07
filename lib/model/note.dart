import 'dart:typed_data';

import 'package:encrypt/encrypt.dart' as enc;
import 'package:encrypt/encrypt.dart';
import 'package:flutter/material.dart';
import 'package:crypto/crypto.dart';
import 'package:uuid/uuid.dart';
import 'dart:convert';
import 'dart:math';

class Note {
  String id;
  String title;
  Uint8List salt;
  String content;

  static const int desireKeyLength = 32;

  Map<String, dynamic> toJson() =>
      {"id": this.id, "title": this.title, "content": this.content};

  // String _generateMd5(String input) =>
  // md5.convert(utf8.encode(input)).toString();

  enc.Key _generateKey(String password) =>
      // enc.Key.fromUtf8(_generateMd5(password)).stretch(Note.desireKeyLength,
      enc.Key.fromUtf8(password).stretch(Note.desireKeyLength,
          iterationCount: 10000, salt: this.salt);
  // salt: Uint8List.fromList(this.salt.codeUnits));

  // https://cheatsheetseries.owasp.org/cheatsheets/Password_Storage_Cheat_Sheet.html#modern-algorithms

  String decrypt(String password) {
    final key = _generateKey(password);
    final _encryptedNote = this.content;
    final _encryptedParts = _encryptedNote.split(";;__;;");

    if (_encryptedParts.length != 2) throw Error();

    final _iv64 = _encryptedParts[0];
    final _iv = utf8.decode(base64.decode(_iv64));
    final iv = enc.IV.fromUtf8(_iv);
    final encrypter = enc.Encrypter(enc.AES(key));

    return encrypter.decrypt64(_encryptedParts[1], iv: iv);
  }

  String _getRandString(int len) {
    final random = Random.secure();
    final values = List<int>.generate(len, (i) => random.nextInt(255));

    return base64UrlEncode(values);
  }

  String encrypt(String content, String password) {
    final key = _generateKey(password);
    final _iv = _getRandString(8);
    final iv = enc.IV.fromUtf8(_iv);

    final encrypter = enc.Encrypter(enc.AES(key));
    final content64 =
        iv.base64 + ";;__;;" + encrypter.encrypt(content, iv: iv).base64;

    return content64;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'title': this.title,
      'content': this.content,
      'salt': this.salt,
    };
  }

  Note changePassword(String oldPassword, newPassword) {
    this.content = encrypt(decrypt(oldPassword), newPassword);

    return this;
  }

  Note(
      {@required this.title,
      @required String content,
      @required String password}) {
    this.id = Uuid().v4();
    this.salt = SecureRandom(Note.desireKeyLength).bytes;

    this.content = encrypt(content, password);
  }

  Note.parseFromDb(dynamic map) {
    this.id = map['id'];
    this.title = map['title'];
    this.content = map['content'];
    this.salt = map['salt'];
  }

  Note.fromDb(
      {@required this.id, @required this.title, @required this.content});
}
