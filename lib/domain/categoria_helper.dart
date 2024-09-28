import 'package:gestor_de_gastos/domain/database_helper.dart';
import 'package:sqflite/sqflite.dart';

class CategoriaHelper {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  // Insertar una categoría
  Future<int> insertCategoria(Map<String, dynamic> row) async {
    Database db = await _dbHelper.database;
    return await db.insert('Categoria', row);
  }

  // Obtener todas las categorías
  Future<List<Map<String, dynamic>>> queryAllCategorias() async {
    Database db = await _dbHelper.database;
    return await db.query('Categoria');
  }

  // Actualizar una categoría
  Future<int> updateCategoria(Map<String, dynamic> row) async {
    Database db = await _dbHelper.database;
    int id = row['id'];
    return await db.update('Categoria', row, where: 'id = ?', whereArgs: [id]);
  }

  // Eliminar una categoría
  Future<int> deleteCategoria(int id) async {
    Database db = await _dbHelper.database;
    return await db.delete('Categoria', where: 'id = ?', whereArgs: [id]);
  }
}
