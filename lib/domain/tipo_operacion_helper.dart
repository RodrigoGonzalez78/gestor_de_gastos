import 'package:gestor_de_gastos/domain/database_helper.dart';
import 'package:sqflite/sqflite.dart';

class TipoOperacionHelper {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  // Insertar un tipo de operación
  Future<int> insertTipoOperacion(Map<String, dynamic> row) async {
    Database db = await _dbHelper.database;
    return await db.insert('TipoOperacion', row);
  }

  // Obtener todos los tipos de operación
  Future<List<Map<String, dynamic>>> queryAllTiposOperacion() async {
    Database db = await _dbHelper.database;
    return await db.query('TipoOperacion');
  }

  // Actualizar un tipo de operación
  Future<int> updateTipoOperacion(Map<String, dynamic> row) async {
    Database db = await _dbHelper.database;
    int id = row['id'];
    return await db
        .update('TipoOperacion', row, where: 'id = ?', whereArgs: [id]);
  }

  // Eliminar un tipo de operación
  Future<int> deleteTipoOperacion(int id) async {
    Database db = await _dbHelper.database;
    return await db.delete('TipoOperacion', where: 'id = ?', whereArgs: [id]);
  }
}
