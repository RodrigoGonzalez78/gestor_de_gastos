import 'package:flutter/material.dart';
import 'package:gestor_de_gastos/domain/categoria_helper.dart';
import 'package:gestor_de_gastos/domain/operacion_helper.dart';
import 'package:gestor_de_gastos/domain/tipo_operacion_helper.dart';
import 'package:provider/provider.dart';

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

  void _agregarOperacion() async {
    if (_montoController.text.isEmpty ||
        _fechaController.text.isEmpty ||
        _categoriaSeleccionada == null ||
        _tipoOperacionSeleccionada == null) {
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
    _fechaController.clear();

    setState(() {
      _categoriaSeleccionada = null;
      _tipoOperacionSeleccionada = null;
    });

    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Operación añadida!')));
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
              decoration:
                  const InputDecoration(labelText: 'Fecha (YYYY-MM-DD)'),
            ),
            FutureBuilder<List<Map<String, dynamic>>>(
              future:
                  Provider.of<CategoriaHelper>(context).queryAllCategorias(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const CircularProgressIndicator();
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
              future: Provider.of<TipoOperacionHelper>(context)
                  .queryAllTiposOperacion(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const CircularProgressIndicator();
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
