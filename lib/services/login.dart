import 'package:note_app/model/user.dart';
import 'package:note_app/services/repository_note.dart';
import 'package:note_app/services/secure_storage.dart';
import 'package:note_app/util/crypto.dart';

class LoginService {
  Future<void> handleBiometricLogin() async {
    var biometricUserPassword = SecureStorage().readBiometricUserPassword();
    var biometricUser = await NoteRepository().getBiometricUserFromDB();
    var notePassword = biometricUser.getNotePassword(biometricUserPassword);
    this.saveNotePassword(notePassword);
  }

  Future<bool> handleDefaultLogin(String pass) async =>
      await validateDefaultUserPassword(pass).then((flag) async => flag
          ? await NoteRepository()
              .getDefaultUserFromDB()
              .then((user) => user.getNotePassword(pass))
              .then((notePassword) => this.saveNotePassword(notePassword))
              .then((_) => true)
          : false);

  Future<bool> validateDefaultUserPassword(String password) async =>
      await NoteRepository()
          .getDefaultUserFromDB()
          .then((user) => validatePassword(user, password));

  Future<bool> validatePassword(User user, String password) async =>
      user.password == CryptoUtil.generatePasswordHash(password);

  Future<void> saveNotePassword(String notePassword) async =>
      await SecureStorage().writePassword(notePassword);
}
