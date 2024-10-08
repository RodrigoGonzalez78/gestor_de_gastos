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
    total = operaciones.fold(
      0.0,
      (sum, operacion) => operacion['tipo_operacion'] == 2
          ? sum + operacion['monto']
          : sum - operacion['monto'],
    );
  }

  // Insertar una operación y actualizar la UI
  Future<int> insertOperacion(Map<String, dynamic> row) async {
    Database db = await _dbHelper.database;
    int result = await db.insert('Operacion', row);
    await getOperaciones(); // Refrescar operaciones y recalcular el total
    return result;
  }

  // Obtener todas las operaciones
  Future<List<Map<String, dynamic>>> queryAllOperaciones() async {
    Database db = await _dbHelper.database;
    return await db.query('Operacion');
  }

  // Actualizar una operación y recalcular el total
  Future<int> updateOperacion(Map<String, dynamic> row) async {
    Database db = await _dbHelper.database;
    int id = row['id'];
    int result =
        await db.update('Operacion', row, where: 'id = ?', whereArgs: [id]);
    await getOperaciones(); // Refrescar operaciones y recalcular el total
    return result;
  }

  // Eliminar una operación y recalcular el total
  Future<int> deleteOperacion(int id) async {
    Database db = await _dbHelper.database;
    int result = await db.delete('Operacion', where: 'id = ?', whereArgs: [id]);
    await getOperaciones(); // Refrescar operaciones y recalcular el total
    return result;
  }
}
