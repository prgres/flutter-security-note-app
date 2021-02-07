import 'dart:typed_data';
import 'package:encrypt/encrypt.dart' as enc;
import 'package:encrypt/encrypt.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'dart:convert';
import 'dart:math';

class Note {
  String id;
  String title;
  Uint8List salt;
  String content;

  static const int desireKeyLength = 32;
  static const String encryptedPartsSplitter = ";;__;;";

  Map<String, dynamic> toJson() =>
      {"id": this.id, "title": this.title, "content": this.content};

  enc.Key _generateKey(String password) => enc.Key.fromUtf8(password).stretch(
        Note.desireKeyLength,
        iterationCount: 10000,
        salt: this.salt,
      );

  // https://cheatsheetseries.owasp.org/cheatsheets/Password_Storage_Cheat_Sheet.html#modern-algorithms

  String decrypt(String password) {
    final _encryptedParts = this.content.split(Note.encryptedPartsSplitter);

    if (_encryptedParts.length != 2) throw Error();

    final _iv64 = _encryptedParts[0];

    return enc.Encrypter(enc.AES(_generateKey(password))).decrypt64(
      _encryptedParts[1],
      iv: enc.IV.fromUtf8(utf8.decode(base64.decode(_iv64))),
    );
  }

  String _getRandString(int len) => base64UrlEncode(
      List<int>.generate(len, (i) => Random.secure().nextInt(255)));

  String encrypt(String content, String password) {
    final iv = enc.IV.fromUtf8(_getRandString(8));

    return iv.base64 +
        Note.encryptedPartsSplitter +
        enc.Encrypter(enc.AES(_generateKey(password)))
            .encrypt(content, iv: iv)
            .base64;
  }

  Map<String, dynamic> toMap() => {
        'id': this.id,
        'title': this.title,
        'content': this.content,
        'salt': this.salt,
      };

  Note changePassword(String oldPassword, newPassword) {
    this.content = encrypt(decrypt(oldPassword), newPassword);

    return this;
  }

  Note({
    @required this.title,
    @required String content,
    @required String password,
  }) {
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

  Note.fromDb({
    @required this.id,
    @required this.title,
    @required this.content,
  });
}
