import 'package:flutter/material.dart';
import 'package:gestor_de_gastos/domain/categoria_helper.dart';
import 'package:gestor_de_gastos/domain/operacion_helper.dart';
import 'package:gestor_de_gastos/domain/tipo_operacion_helper.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class NewOperacionScreen extends StatefulWidget {
  const NewOperacionScreen({super.key});

  @override
  _NewOperacionScreenState createState() => _NewOperacionScreenState();
}

class _NewOperacionScreenState extends State<NewOperacionScreen> {
  final _montoController = TextEditingController();
  final _fechaController = TextEditingController();
  String? _categoriaSeleccionada;
  String? _tipoOperacionSeleccionada;
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _fechaController.text = DateFormat('yyyy-MM-dd')
        .format(_selectedDate); // Fecha actual por defecto
  }

  void _agregarOperacion() async {
    if (_montoController.text.isEmpty ||
        _categoriaSeleccionada == null ||
        _tipoOperacionSeleccionada == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor complete todos los campos')),
      );
      return;
    }

    Map<String, dynamic> nuevaOperacion = {
      'monto': double.parse(_montoController.text),
      'fecha': _fechaController.text,
      'categoria': int.parse(_categoriaSeleccionada!),
      'tipo_operacion': int.parse(_tipoOperacionSeleccionada!),
    };

    await Provider.of<OperacionHelper>(context, listen: false)
        .insertOperacion(nuevaOperacion);

    // Limpiar campos
    _montoController.clear();
    _fechaController.text = DateFormat('yyyy-MM-dd').format(DateTime.now());

    setState(() {
      _categoriaSeleccionada = null;
      _tipoOperacionSeleccionada = null;
    });

    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Operación añadida!')));
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
        _fechaController.text = DateFormat('yyyy-MM-dd').format(_selectedDate);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cargar Operaciones'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _montoController,
              decoration: const InputDecoration(labelText: 'Monto'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _fechaController,
              decoration: const InputDecoration(labelText: 'Fecha'),
              readOnly: true,
              onTap: () => _selectDate(context),
            ),
            FutureBuilder<List<Map<String, dynamic>>>(
              future: Provider.of<CategoriaHelper>(context, listen: false)
                  .queryAllCategorias(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }
                if (snapshot.hasError) {
                  return const Text('Error al cargar categorías');
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Text('No hay categorías disponibles');
                }
                return DropdownButton<String>(
                  hint: const Text('Seleccionar Categoría'),
                  value: _categoriaSeleccionada,
                  onChanged: (newValue) {
                    setState(() {
                      _categoriaSeleccionada = newValue;
                    });
                  },
                  items:
                      snapshot.data!.map<DropdownMenuItem<String>>((categoria) {
                    return DropdownMenuItem<String>(
                      value: categoria['id'].toString(),
                      child: Text(categoria['descripcion']),
                    );
                  }).toList(),
                );
              },
            ),
            FutureBuilder<List<Map<String, dynamic>>>(
              future: Provider.of<TipoOperacionHelper>(context, listen: false)
                  .queryAllTiposOperacion(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }
                if (snapshot.hasError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(snapshot.error.toString()),
                    ),
                  );

                  return const Text('Error al cargar tipos de operación');
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Text('No hay tipos de operación disponibles');
                }
                return DropdownButton<String>(
                  hint: const Text('Seleccionar Tipo de Operación'),
                  value: _tipoOperacionSeleccionada,
                  onChanged: (newValue) {
                    setState(() {
                      _tipoOperacionSeleccionada = newValue;
                    });
                  },
                  items: snapshot.data!
                      .map<DropdownMenuItem<String>>((tipoOperacion) {
                    return DropdownMenuItem<String>(
                      value: tipoOperacion['id'].toString(),
                      child: Text(tipoOperacion['descripcion']),
                    );
                  }).toList(),
                );
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _agregarOperacion,
              child: const Text('Agregar Operación'),
            ),
          ],
        ),
      ),
    );
  }
}
