import 'package:flutter/material.dart';
import 'package:gestor_de_gastos/screens/categoria/new_categoria_screen.dart';
import 'package:gestor_de_gastos/domain/categoria_helper.dart';
import 'package:gestor_de_gastos/domain/operacion_helper.dart';
import 'package:gestor_de_gastos/domain/tipo_operacion_helper.dart';
import 'package:gestor_de_gastos/screens/home/home.dart';
import 'package:gestor_de_gastos/screens/operacion/new_operacion_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CategoriaHelper()),
        ChangeNotifierProvider(
            create: (_) => OperacionHelper()), // Agregar esto
        ChangeNotifierProvider(
            create: (_) => TipoOperacionHelper()), // Agregar esto
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Gestor de gastos',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),

      // Definir todas las rutas nombradas aquí
      initialRoute: '/',
      routes: {
        '/': (context) => const HomePage(),
        '/categorias': (context) => const NewCategoriaScreen(),
        '/operaciones': (context) => const NewOperacionScreen(),
      },
    );
  }
}
