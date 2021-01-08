import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:note_app/model/user.dart';
import 'package:note_app/services/repository.dart';
import 'package:note_app/services/secure_storage.dart';

class LoginService {
  Future<User> getUser() async => await NoteRepository()
      .getUserFromDB()
      .then((v) => User.loadFromDb(userMap: v[0]));

  Future<bool> validatePassword(String password) async =>
      (await this.getUser().then((user) => user.password) ==
          generatePasswordHash(password));

  Future<void> savePassword(String password) async =>
      await SecureStorage().writePassword(password);

  String generatePasswordHash(String password) =>
      sha512.convert(utf8.encode(password)).toString();

  String generatePasswordHash256(String password) =>
      sha256.convert(utf8.encode(password)).toString();
}
