import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  static FlutterSecureStorage _storage;

  Future<FlutterSecureStorage> get storage async {
    if (_storage != null) return _storage;

    _storage = FlutterSecureStorage();
    return _storage;
  }

  Future<String> readPassword() async =>
      await storage.then((st) => st.read(key: "password"));

  Future<void> writePassword(String pass) async =>
      await storage.then((st) => st.write(key: "password", value: pass));
}
