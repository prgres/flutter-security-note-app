//   Future<List<Note>> getNotesFromDB() async {
//     // final Database db = await database;
//     final Database db = await getDB();

//     if (db == null) {
//       print("db is null");
//     }
//     List<Note> notesList = [];
//     List<Map> maps = await db.query('notes');

//     // await db.query('notes', columns: ['id', 'title', 'content']);
//     if (maps.length > 0) {
//       maps.forEach((map) {
//         notesList.add(Note.fromDb(
//           id: map['id'],
//           title: map['title'],
//           content: map['content'],
//         ));
//       });
//     }

//     return notesList;
//   }

//   // updateNote(Note note) async {
//   //   // Get a reference to the database.
//   //   final Database db = await database;

//   //   // Update.
//   //   await db.update(
//   //     'notes',
//   //     note.toMap(),
//   //     // Ensure that the object has a matching id.
//   //     where: "id = ?",
//   //     // Pass the id as a whereArg to prevent SQL injection.
//   //     whereArgs: [note.id],
//   //   );
//   // }

//   // deleteNote(int id) async {
//   //   // Get a reference to the database.
//   //   final db = await database;

//   //   // Remove the Dog from the database.
//   //   await db.delete(
//   //     'notes',
//   //     // Use a `where` clause to delete a specific dog.
//   //     where: "id = ?",
//   //     // Pass the id as a whereArg to prevent SQL injection.
//   //     whereArgs: [id],
//   //   );
//   // }
