import 'package:encrypt/encrypt.dart';
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

  Future<void> insertUser(String password) async => await database
      .then((db) => db.insert(
            'user',
            {
              "id": "default",
              "password": LoginService().generatePasswordHash(password),
              "salt": String.fromCharCodes(SecureRandom(128).bytes),
            },
            conflictAlgorithm: ConflictAlgorithm.replace,
          ))
      .whenComplete(() async => await LoginService().savePassword(password));

  Future<void> updateUserPassword(String password) async => await database
      .then((db) => db.update(
            'user',
            {
              "id": "default",
              "password": LoginService().generatePasswordHash(password),
              "salt": String.fromCharCodes(SecureRandom(128).bytes),
            },
            where: 'id = ?',
            whereArgs: ["default"],
          ))
      .whenComplete(() async => await LoginService().savePassword(password));

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

  Future<void> changePassword(String oldPassword, String newPassword) async {
    final allNote = await this.getNotesFromDB();
    await updateUserPassword(newPassword);

    final user = await NoteRepository()
        .getUserFromDB()
        .then((v) => User.loadFromDb(userMap: v[0]));

    allNote.forEach((note) async {
      var updatedNote =
          note.changePassword(oldPassword, newPassword, user.salt);
      await updateNote(updatedNote);
    });
  }
}
