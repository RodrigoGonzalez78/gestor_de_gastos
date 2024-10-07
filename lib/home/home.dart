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
    // Obtener las operaciones cuando la página se inicializa
    final operacionHelper =
        Provider.of<OperacionHelper>(context, listen: false);
    operacionHelper.getOperaciones();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestor de Gastos'),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: Consumer<OperacionHelper>(
        builder: (context, operacionHelper, child) {
          final operaciones = operacionHelper.operaciones;
          final gastos =
              operaciones.where((op) => op['tipo_operacion'] == 1).toList();
          final ingresos =
              operaciones.where((op) => op['tipo_operacion'] == 2).toList();

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const Text(
                      'Total',
                      style: TextStyle(fontSize: 18),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '\$${operacionHelper.total.toStringAsFixed(2)}',
                      style: const TextStyle(
                          fontSize: 36, fontWeight: FontWeight.bold),
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
                          Tab(text: 'Expenses'),
                          Tab(text: 'Income'),
                        ],
                        labelColor: Colors.black,
                      ),
                      Expanded(
                        child: TabBarView(
                          children: [
                            // Mostrar gastos
                            ListView.builder(
                              itemCount: gastos.length,
                              itemBuilder: (context, index) {
                                final operacion = gastos[index];
                                return ListTile(
                                  title: Text('Monto: \$${operacion['monto']}'),
                                  subtitle:
                                      Text('Fecha: ${operacion['fecha']}'),
                                );
                              },
                            ),
                            // Mostrar ingresos
                            ListView.builder(
                              itemCount: ingresos.length,
                              itemBuilder: (context, index) {
                                final operacion = ingresos[index];
                                return ListTile(
                                  title: Text('Monto: \$${operacion['monto']}'),
                                  subtitle:
                                      Text('Fecha: ${operacion['fecha']}'),
                                );
                              },
                            ),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/operaciones');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
