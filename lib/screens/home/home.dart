import 'package:flutter/material.dart';
import 'package:gestor_de_gastos/domain/operacion_helper.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    // Obtener operaciones al inicio
    context.read<OperacionHelper>().getOperaciones();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<OperacionHelper>(
        builder: (context, operacionHelper, child) {
          final operaciones = operacionHelper.operaciones;
          final gastos = operaciones.where((op) => op['tipo_operacion'] == 1).toList();
          final ingresos = operaciones.where((op) => op['tipo_operacion'] == 2).toList();

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const Text(
                      'Total',
                      style: TextStyle(fontSize: 19),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '\$${operacionHelper.total.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: DefaultTabController(
                  length: 2,
                  child: Column(
                    children: [
                      const TabBar(
                        tabs: [
                          Tab(text: 'Gastos'),
                          Tab(text: 'Ingresos'),
                        ],
                        labelColor: Colors.black,
                      ),
                      Expanded(
                        child: TabBarView(
                          children: [
                            _listViewBuilder(gastos.length, gastos),
                            _listViewBuilder(ingresos.length, ingresos),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: _floatingActionButton(context),
    );
  }
}

Widget _listViewBuilder(int length, List<Map<String, dynamic>> items) {
  return ListView.builder(
    itemCount: items.length,
    itemBuilder: (context, index) {
      final operacion = items[index];
      return ListTile(
        title: Text('Monto: \$${operacion['monto']}'),
        subtitle: Text('Fecha: ${operacion['fecha']}'),
      );
    },
  );
}

Widget _floatingActionButton(BuildContext context) {
  return FloatingActionButton(
    onPressed: () {
      Navigator.pushNamed(context, '/operaciones');
    },
    child: const Icon(Icons.add),
  );
}

