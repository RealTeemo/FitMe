import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import '../data/models/routine_model.dart';

class DatabaseHelper {
  static const int _version = 1;
  static const String _dbName = "routine_database.db";

  static Future<Database> _getDB() async {
    return openDatabase(
      join(await getDatabasesPath(), _dbName),
      version: _version,
      onCreate: (db, version) async => await db.execute(
        "CREATE TABLE routines (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, description TEXT)",
      ),
    );
  }

  static Future<int> insertRoutine(Routine routine) async {
    final db = await _getDB();
    return await db.insert(
      "routines",
      routine.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
  
  static Future<int> updateRoutine(Routine routine) async {
    final db = await _getDB();
    return await db.update(
      "routines",
      routine.toJson(),
      where: "id = ?",
      whereArgs: [routine.id],
    );
  }

  static Future<int> deleteRoutine(Routine routine) async {
    final db = await _getDB();
    return await db.delete(
      "routines",
      where: "id = ?",
      whereArgs: [routine.id],
    );
  }
  
  static Future<List<Routine>> getAllRoutines() async {
    final db = await _getDB();
    final List<Map<String, dynamic>> maps = await db.query("routines");
    if (maps.isEmpty) {
      return [] ;
    }
    return List.generate(maps.length, (index) => Routine.fromJson(maps[index]));
  }
  
}