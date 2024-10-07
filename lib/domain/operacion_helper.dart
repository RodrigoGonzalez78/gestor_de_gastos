import 'package:flutter/foundation.dart';
import 'package:gestor_de_gastos/domain/database_helper.dart';
import 'package:sqflite/sqflite.dart';

class OperacionHelper extends ChangeNotifier {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  List<Map<String, dynamic>> operaciones = [];

  double total = 0.0;

  // Obtener todas las operaciones y calcular el total
  Future<void> getOperaciones() async {
    operaciones = await queryAllOperaciones();
    _calcularTotal();
    notifyListeners();
  }

  // Calcular el total de las operaciones
  void _calcularTotal() {
    total = operaciones.fold(0.0, (sum, operacion) => sum + operacion['monto']);
  }

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
