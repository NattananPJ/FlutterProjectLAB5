import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter_application_2/models/note.dart';

class NotesRepository {
  static const _dbName = 'notes_database.db';
  static const _tableName = 'notes';

  static Future<Database> _database() async {
    final database = openDatabase(
      join(await getDatabasesPath(), _dbName),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE $_tableName(id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, description TEXT, time TEXT, createdAt TEXT)',
        );
      },
      version: 1,
    );
    return database;
  }
  static insert({required Note note}) async {
    final db = await _database();
    await db.insert(
      _tableName,
      note.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<List<Note>> getNotes() async {
    final db = await _database();
    
    final List<Map<String, dynamic>> maps = await db.query(_tableName);
    return List.generate(maps.length, (index) {
      return Note(
        id: maps[index]['id'] as int,
        title: maps[index]['title'] as String,
        description: maps[index]['description'] as String,
        time: maps[index]['time'] as String,
        createdAt: DateTime.parse(maps[index]['createdAt']),
      );
    });
  }
  static update({required Note note}) async {
    final db = await _database();
    await db.update(
      _tableName,
      note.toMap(),
      where: 'id = ?',
      whereArgs: [note.id],
    );
  }
  static delete({required Note note}) async {
    final db = await _database();
    await db.delete(
      _tableName,
      where: 'id = ?',
      whereArgs: [note.id],
    );
  }
}