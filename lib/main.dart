import 'package:ag1_equipo4_almacenamiento_imagenes/PaginaPrincipal.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "AG1_EQUIPO4",
      home: Paginaprincipal(),
    );
  }
}
