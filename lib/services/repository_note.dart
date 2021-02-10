import 'package:note_app/model/note.dart';
import 'package:note_app/model/user.dart';
import 'package:note_app/services/database.dart';
import 'package:sqflite/sqflite.dart';
import 'login.dart';

class NoteRepository {
  DatabaseConnection _notesDatabaseService;

  NoteRepository() {
    _notesDatabaseService = DatabaseConnection();
  }

  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await _notesDatabaseService.setDatabase();

    return _database;
  }

  Future<List<Map>> getUserFromDB() async =>
      await database.then((db) => db.query('user'));

  Future<void> insertUser(User user, String notePassword) async =>
      await database
          .then((db) => db.insert(
                'user',
                user.toMap(),
                conflictAlgorithm: ConflictAlgorithm.replace,
              ))
          .whenComplete(
              () async => await LoginService().saveNotePassword(notePassword));

  Future<void> updateUserPassword(String password) async =>
      await getDefaultUserFromDB()
          .then((defaultUser) async => await database.then((db) => {
                db.update(
                  'user',
                  User.defaultUser(
                          password: password,
                          salt: defaultUser.salt,
                          notePassword: defaultUser.notePassword)
                      .toMap(),
                  where: 'id = ?',
                  whereArgs: [User.defaultUserID],
                )
              }));

  Future<User> getDefaultUserFromDB() async => await database
      .then((db) => db.query(
            'user',
            where: 'id = ?',
            whereArgs: [User.defaultUserID],
          ))
      .then((users) =>
          users.map((value) => (User.loadFromDb(userMap: value))).first);

  Future<User> getBiometricUserFromDB() async => await database
      .then((db) => db.query(
            'user',
            where: 'id = ?',
            whereArgs: [User.biometricUserID],
          ))
      .then((users) =>
          users.map((value) => (User.loadFromDb(userMap: value))).first);

  Future<List<Note>> getNotesFromDB() async =>
      await database.then((db) => db.query('notes')).then((rawNotes) =>
          rawNotes.map((value) => (Note.parseFromDb(value))).toList());

  Future<String> insertNote(Note note) async => await database
      .then((db) => db.insert(
            'notes',
            note.toMap(),
            conflictAlgorithm: ConflictAlgorithm.replace,
          ))
      .then((e) => note.id);

  Future<void> deleteNote(String id) async =>
      await database.then((db) => db.delete(
            'notes',
            where: "id = ?",
            whereArgs: [id],
          ));

  Future<void> updateNote(Note note) async =>
      await database.then((db) => db.update(
            'notes',
            note.toMap(),
            where: 'id = ?',
            whereArgs: [note.id],
          ));
}
