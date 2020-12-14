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

  List<Note> parseNoteToObj(List<Map> maps) {
    List<Note> notesList = [];

    if (maps.length > 0) {
      maps.forEach((map) {
        notesList.add(Note.fromDb(
          id: map['id'],
          title: map['title'],
          content: map['content'],
        ));
      });
    }

    return notesList;
  }

  Future<void> deleteNote(String id) async {
    await database.then((db) => db.delete(
          'notes',
          where: "id = ?",
          whereArgs: [id],
        ));
  }

  Future<void> updateNote(Note note) async {
    await database.then((db) => db.update(
          'notes',
          note.toMap(),
          where: 'id = ?',
          whereArgs: [note.id],
        ));
  }

  Future<void> changePassword(
      Note note, String oldPassword, String newPassword) async {
    var updatedNote = note.changePassword(oldPassword, newPassword);

    await updateNote(updatedNote);
  }
}
