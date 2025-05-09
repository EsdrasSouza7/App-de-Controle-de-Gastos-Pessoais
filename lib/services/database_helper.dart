import 'package:controle_de_gasto/models/gastos_models.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static const _version = 1;
  static const _dbName = "Gastos.db";

  static Future<Database> _getDB() async {
    return openDatabase(
      join(await getDatabasesPath(), _dbName),
      onCreate:
          (db, version) async => await db.execute(
            "CREATE TABLE Gastos(id INTEGER PRIMARY KEY AUTOINCREMENT, tipoDoGasto TEXT NOT NULL, valor DOUBLE NOT NULL, descricao TEXT, iconCode INTEGER NOT NULL, entrada INTEGER Not NULL);",
          ),
      version: _version,
    );
  }

  static Future<int> addGastos(Gastos gasto) async {
    final db = await _getDB();
    return await db.insert(
      "Gastos",
      gasto.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<int> updateGastos(Gastos gasto) async {
    final db = await _getDB();
    return await db.update(
      "Gastos",
      gasto.toJson(),
      where: 'id = ?',
      whereArgs: [gasto.id],
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<int> deleteGastos(Gastos gasto) async {
    final db = await _getDB();
    return await db.delete("Gastos", where: 'id = ?', whereArgs: [gasto.id]);
  }

  static Future<List<Gastos>?> getAllGastos() async {
    final db = await _getDB();
    final List<Map<String, dynamic>> maps = await db.query("Gastos");

    if (maps.isEmpty) {
      return null;
    }

    return List.generate(maps.length, (index) => Gastos.fromJson(maps[index]));
  }
}
