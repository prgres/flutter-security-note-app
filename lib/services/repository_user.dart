// import 'package:note_app/model/user.dart';
// import 'package:note_app/services/database.dart';
// import 'package:sqflite/sqflite.dart';
// import 'login.dart';

// class UserRepository {
//   DatabaseConnection _userDatabaseService;

//   UserRepository() {
//     _userDatabaseService = DatabaseConnection();
//   }

//   static Database _database;

//   Future<Database> get database async {
//     if (_database != null) return _database;
//     _database = await _userDatabaseService.setDatabase();

//     return _database;
//   }

//   Future<List<Map>> getUserFromDB() async =>
//       await database.then((db) => db.query('user'));

//   Future<void> insertUser(User user, String notePassword) async =>
//       await database
//           .then((db) => db.insert(
//                 'user',
//                 user.toMap(),
//                 conflictAlgorithm: ConflictAlgorithm.replace,
//               ))
//           .whenComplete(
//               () async => await LoginService().saveNotePassword(notePassword));

//   Future<void> updateUserPassword(String password) async =>
//       await getDefaultUserFromDB()
//           .then((defaultUser) async => await database.then((db) => {
//                 db.update(
//                   'user',
//                   User.defaultUser(
//                           password: password,
//                           salt: defaultUser.salt,
//                           notePassword: defaultUser.notePassword)
//                       .toMap(),
//                   where: 'id = ?',
//                   whereArgs: [User.defaultUserID],
//                 )
//               }));

//   Future<User> getDefaultUserFromDB() async => await database
//       .then((db) => db.query(
//             'user',
//             where: 'id = ?',
//             whereArgs: [User.defaultUserID],
//           ))
//       .then((users) =>
//           users.map((value) => (User.loadFromDb(userMap: value))).first);

//   Future<User> getBiometricUserFromDB() async => await database
//       .then((db) => db.query(
//             'user',
//             where: 'id = ?',
//             whereArgs: [User.biometricUserID],
//           ))
//       .then((users) =>
//           users.map((value) => (User.loadFromDb(userMap: value))).first);
// }
