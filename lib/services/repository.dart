import 'package:note_app/note.dart';
import 'package:note_app/services/database.dart';
import 'package:sqflite/sqflite.dart';

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

  Future<List<Map>> getNotesFromDB() async {
    return await database.then((db) => db.query('notes'));
  }

  Future<String> insertNote(Note note) async {
    await database.then((db) => db.insert(
          'notes',
          note.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        ));

    return note.id;
  }

  Future<void> deleteNote(String id) async {
    await database.then((db) => db.delete(
          'notes',
          where: "id = ?",
          whereArgs: [id],
        ));
  }
}
