import 'package:gestor_de_gastos/domain/database_helper.dart';
import 'package:sqflite/sqflite.dart';

class OperacionHelper {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  // Insertar una operación
  Future<int> insertOperacion(Map<String, dynamic> row) async {
    Database db = await _dbHelper.database;
    return await db.insert('Operacion', row);
  }

  // Obtener todas las operaciones
  Future<List<Map<String, dynamic>>> queryAllOperaciones() async {
    Database db = await _dbHelper.database;
    return await db.query('Operacion');
  }

  // Actualizar una operación
  Future<int> updateOperacion(Map<String, dynamic> row) async {
    Database db = await _dbHelper.database;
    int id = row['id'];
    return await db.update('Operacion', row, where: 'id = ?', whereArgs: [id]);
  }

  // Eliminar una operación
  Future<int> deleteOperacion(int id) async {
    Database db = await _dbHelper.database;
    return await db.delete('Operacion', where: 'id = ?', whereArgs: [id]);
  }
}
