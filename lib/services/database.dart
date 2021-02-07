import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseConnection {
  _onConfigureDatabase(Database db) async {
    print("Database configure");
    await db
        .execute(
            "CREATE TABLE IF NOT EXISTS notes(id TEXT PRIMARY KEY, title TEXT, content TEXT, salt TEXT)")
        .whenComplete(() async => await db.execute(
            "CREATE TABLE IF NOT EXISTS user(id TEXT PRIMARY KEY, password TEXT, salt TEXT)"));
  }

  _onUpgradeDatabase(Database db, int oldVersion, int newVersion) async {
    print("Database upgrade");
    await db
        .execute("DROP TABLE IF EXISTS notes")
        .whenComplete(() async => await db.execute("DROP TABLE IF EXISTS user"))
        .whenComplete(() async => await _onConfigureDatabase(db));
  }

  _onDowngradeDatabase(Database db, int oldVersion, int newVersion) async {
    print("Database downgrade");
    await db
        .execute("DROP TABLE IF EXISTS notes")
        .whenComplete(() async => await db.execute("DROP TABLE IF EXISTS user"))
        .whenComplete(() async => await _onConfigureDatabase(db));
  }

  setDatabase() async {
    print("CREATING DB");
    return await getApplicationDocumentsDirectory()
        .then((directory) => join(directory.path, 'notes.db'))
        .then((path) async => await openDatabase(path,
            version: 1,
            onConfigure: _onConfigureDatabase,
            onUpgrade: _onUpgradeDatabase,
            onDowngrade: _onDowngradeDatabase));
  }
}
