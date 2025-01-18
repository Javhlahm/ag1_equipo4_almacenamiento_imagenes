import 'dart:convert';
import 'dart:typed_data';

import 'package:ag1_equipo4_almacenamiento_imagenes/libro.dart';
import 'package:mysql1/mysql1.dart';

class Operacionesmysql {
  MySqlConnection? conn;

  Future<void> conectarBD() async {
    this.conn = await MySqlConnection.connect(ConnectionSettings(
        host: '3.21.203.48',
        port: 3306,
        user: 'javhlahm',
        password: 'Julio.212324',
        db: "unideh",
        characterSet: CharacterSet.UTF8MB4));
  }

  Future<void> cerrarBD() async {
    if (conn != null) {
      await conn!.close();
    }
  }

  Future<void> crearTablaSiNoExiste() async {
    await conectarBD();
    await Future.delayed(Duration(seconds: 2));
    await conn!.query('''
      CREATE TABLE IF NOT EXISTS libreria (
        id INT AUTO_INCREMENT PRIMARY KEY,
        titulo VARCHAR(100),
        autor VARCHAR(100),
        genero VARCHAR(100),
        paginas INT,
        editorial VARCHAR(100),
        portada BLOB
      );
    ''');
    await Future.delayed(Duration(seconds: 2));
  }

  Future<Libro?> guardarLibro(Libro libro) async {
    await conectarBD();
    await Future.delayed(Duration(seconds: 2));
    var results = await conn!.query(
        "INSERT INTO libreria (titulo, autor, genero, paginas, editorial, portada) VALUES (?, ?, ?, ?, ?, ?)",
        [
          libro.titulo,
          libro.autor,
          libro.genero,
          libro.paginas,
          libro.editorial,
          libro.portada,
        ]);
    await Future.delayed(Duration(seconds: 2));
    return results.affectedRows! > 0 ? libro : null;
  }

  Future<List<Libro>> obtenerLibros() async {
    await crearTablaSiNoExiste();
    await conectarBD();
    await Future.delayed(Duration(seconds: 2));
    var results = await conn!.query("SELECT * FROM libreria");
    await Future.delayed(Duration(seconds: 2));
    List<Libro> libros = [];

    for (var linea in results) {
      var blob = linea[6] as List<int>;
      Libro libro = new Libro(linea[0], linea[1], linea[2], linea[3], linea[4],
          linea[5], Uint8List.fromList(blob));
      libros.add(libro);
    }
    return libros;
  }

  Future<List<Libro>> seleccionarLibro(String titulo) async {
    titulo = "%$titulo%";
    await conectarBD();
    await Future.delayed(Duration(seconds: 2));
    var results = await conn!
        .query("SELECT * FROM libreria WHERE titulo LIKE ?", [titulo]);
    await Future.delayed(Duration(seconds: 2));
    List<Libro> libros = [];

    for (var fila in results) {
      Libro libro = new Libro(
          fila[0], fila[1], fila[2], fila[3], fila[4], fila[5], fila[6]);
      libros.add(libro);
    }
    return libros;
  }

  Future<int?> eliminarLibro(int id) async {
    await conectarBD();
    await Future.delayed(Duration(seconds: 2));
    var results = await conn!.query("DELETE FROM libreria WHERE id=?", [id]);
    await Future.delayed(Duration(seconds: 2));
    return results.affectedRows! > 0 ? id : null;
  }

  Future<Libro?> editarLibro(Libro libro) async {
    await conectarBD();
    await Future.delayed(Duration(seconds: 2));
    var results = await conn!.query(
        "UPDATE libreria SET titulo=?, autor=?, genero=?, paginas=?, editorial=?, portada=? WHERE id=?",
        [
          libro.titulo,
          libro.autor,
          libro.genero,
          libro.paginas,
          libro.editorial,
          libro.portada,
          libro.id,
        ]);
    await Future.delayed(Duration(seconds: 2));
    return results.affectedRows! > 0 ? libro : null;
  }
}
