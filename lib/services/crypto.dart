import 'dart:convert';
import 'package:crypto/crypto.dart';

class Crypto {
  String generatePasswordHash(String password) {
    var bytes = utf8.encode(password);
    var hash = sha512.convert(bytes).toString();

    return hash;
  }

  String generatePasswordHash256(String password) {
    var bytes = utf8.encode(password);
    var hash = sha256.convert(bytes).toString();

    return hash;
  }
}
