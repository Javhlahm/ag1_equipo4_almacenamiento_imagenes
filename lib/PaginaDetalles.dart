import 'dart:convert';

import 'package:ag1_equipo4_almacenamiento_imagenes/libro.dart';
import 'package:flutter/material.dart';

class Paginadetalles extends StatefulWidget {
  final Libro libro;
  const Paginadetalles({super.key, required this.libro});

  @override
  State<Paginadetalles> createState() => _PaginadetallesState();
}

class _PaginadetallesState extends State<Paginadetalles> {
  @override
  Widget build(BuildContext context) {
    Libro libro = widget.libro;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: Text(libro.titulo),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.memory(base64Decode(libro.portada!)),
            Padding(padding: EdgeInsets.symmetric(vertical: 15)),
            Text(libro.titulo,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0)),
            Text(libro.autor,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0)),
            Text(libro.paginas.toString(),
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0)),
            Text(libro.editorial,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0)),
            Text(libro.genero,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0)),
          ],
        ),
      ),
    );
  }
}
