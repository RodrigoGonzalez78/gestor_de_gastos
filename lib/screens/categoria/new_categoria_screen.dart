import 'package:flutter/material.dart';
import 'package:gestor_de_gastos/domain/categoria_helper.dart';
import 'package:provider/provider.dart';

class NewCategoriaScreen extends StatefulWidget {
  const NewCategoriaScreen({super.key});

  @override
  _NewCategoriaScreenState createState() => _NewCategoriaScreenState();
}

class _NewCategoriaScreenState extends State<NewCategoriaScreen> {
  final _descripcionController = TextEditingController();
  final _colorController = TextEditingController();

  void _agregarCategoria() async {
    if (_descripcionController.text.isEmpty || _colorController.text.isEmpty) {
      return;
    }

    Map<String, dynamic> nuevaCategoria = {
      'descripcion': _descripcionController.text,
      'color': _colorController.text
    };

    await Provider.of<CategoriaHelper>(context, listen: false)
        .insertCategoria(nuevaCategoria);

    // Limpiar campos
    _descripcionController.clear();
    _colorController.clear();
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Categoría añadida!')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cargar Categorías'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _descripcionController,
              decoration: const InputDecoration(labelText: 'Descripción'),
            ),
            TextField(
              controller: _colorController,
              decoration:
                  const InputDecoration(labelText: 'Color (Hexadecimal)'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _agregarCategoria,
              child: const Text('Agregar Categoría'),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future:
                    Provider.of<CategoriaHelper>(context).queryAllCategorias(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData)
                    return const CircularProgressIndicator();
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      var categoria = snapshot.data![index];
                      return ListTile(
                        title: Text(categoria['descripcion']),
                        subtitle: Text(categoria['color']),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
