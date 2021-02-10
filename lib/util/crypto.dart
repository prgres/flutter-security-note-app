import 'dart:typed_data';
import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart' as enc;
import 'dart:convert';
import 'dart:math';

class CryptoUtil {
  static const int desireKeyLength = 32;
  static const int saltLenght = 128;
  static const String encryptedPartsSplitter = ";;__;;";

  static String generatePasswordHash(String password) =>
      sha512.convert(utf8.encode(password)).toString();

  static String getRandString() {
    var random = Random.secure();
    var values = List<int>.generate(64, (i) => random.nextInt(255));

    return base64UrlEncode(values);
  }

  static enc.Key _generateKey(String password, Uint8List salt) =>
      enc.Key.fromUtf8(password).stretch(
        CryptoUtil.desireKeyLength,
        iterationCount: 10000,
        salt: salt,
      );

  // https://cheatsheetseries.owasp.org/cheatsheets/Password_Storage_Cheat_Sheet.html#modern-algorithms

  static String generateSalt() => CryptoUtil.getRandString();

  static String decrypt(String password, String salt, String content) {
    var _salt = Uint8List.fromList(salt.codeUnits);

    final _encryptedParts = content.split(CryptoUtil.encryptedPartsSplitter);

    if (_encryptedParts.length != 2) throw Error();

    final _iv64 = _encryptedParts[0];

    return enc.Encrypter(enc.AES(_generateKey(password, _salt))).decrypt64(
      _encryptedParts[1],
      iv: enc.IV.fromUtf8(utf8.decode(base64.decode(_iv64))),
    );
  }

  static String _getRandString(int len) => base64UrlEncode(
      List<int>.generate(len, (i) => Random.secure().nextInt(255)));

  static String encrypt(String content, String password, String salt) {
    var _salt = Uint8List.fromList(salt.codeUnits);
    final iv = enc.IV.fromUtf8(_getRandString(8));

    return iv.base64 +
        CryptoUtil.encryptedPartsSplitter +
        enc.Encrypter(enc.AES(_generateKey(password, _salt)))
            .encrypt(content, iv: iv)
            .base64;
  }
}
