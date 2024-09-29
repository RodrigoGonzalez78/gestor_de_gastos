import 'package:flutter/material.dart';
import 'package:gestor_de_gastos/categoria/new_categoria_screen.dart';
import 'package:gestor_de_gastos/home/home.dart';
import 'package:gestor_de_gastos/operacion/new_operacion_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
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
