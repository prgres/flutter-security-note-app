import 'package:note_app/model/user.dart';
import 'package:note_app/services/crypto.dart';
import 'package:note_app/services/repository.dart';
import 'package:note_app/services/secure_storage.dart';

class LoginService {
  Future<User> getUser() async => await NoteRepository()
      .getUserFromDB()
      .then((v) => User.loadFromDb(userMap: v[0]));

  Future<bool> validatePassword(String password) async =>
      (await this.getUser().then((user) => user.password) ==
          Crypto().generatePasswordHash(password));

  Future<void> savePassword(String password) async =>
      await SecureStorage().writePassword(password);
}
