import 'package:flutter/services.dart';

class Libro {
  int? id;
  String titulo;
  String autor;
  String genero;
  int paginas;
  String editorial;
  Uint8List portada;

  Libro(this.id, this.titulo, this.autor, this.genero, this.paginas,
      this.editorial, this.portada);
}
