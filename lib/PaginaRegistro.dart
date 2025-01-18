import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:ag1_equipo4_almacenamiento_imagenes/OperacionesMYSQL.dart';
import 'package:ag1_equipo4_almacenamiento_imagenes/PaginaPrincipal.dart';
import 'package:ag1_equipo4_almacenamiento_imagenes/libro.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Paginaregistro extends StatefulWidget {
  const Paginaregistro({super.key});

  @override
  State<Paginaregistro> createState() => _PaginaregistroState();
}

class _PaginaregistroState extends State<Paginaregistro> {
  File? imagen;
  String? imagenblob;
  Operacionesmysql db = Operacionesmysql();
  var formKey = new GlobalKey<FormState>();
  TextEditingController ctrlTitulo = new TextEditingController();
  TextEditingController ctrlAutor = new TextEditingController();
  TextEditingController ctrlGenero = new TextEditingController();
  TextEditingController ctrlPaginas = new TextEditingController();
  TextEditingController ctrlEditorial = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Registrar Libro"),
        centerTitle: true,
        backgroundColor: Colors.amber,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        scrollDirection: Axis.vertical,
        child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Padding(padding: EdgeInsets.symmetric(vertical: 15.0)),
                TextFormField(
                  validator: (value) {
                    return value!.isEmpty ? "Campo Vacío" : null;
                  },
                  controller: ctrlTitulo,
                  decoration: InputDecoration(
                      labelText: "Título",
                      border: new OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(25.0),
                      )),
                ),
                Padding(padding: EdgeInsets.symmetric(vertical: 15.0)),
                TextFormField(
                  validator: (value) {
                    return value!.isEmpty ? "Campo Vacío" : null;
                  },
                  controller: ctrlAutor,
                  decoration: InputDecoration(
                      labelText: "Autor",
                      border: new OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(25.0),
                      )),
                ),
                Padding(padding: EdgeInsets.symmetric(vertical: 15.0)),
                TextFormField(
                  validator: (value) {
                    return value!.isEmpty ? "Campo Vacío" : null;
                  },
                  controller: ctrlGenero,
                  decoration: InputDecoration(
                      labelText: "Género",
                      border: new OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(25.0),
                      )),
                ),
                Padding(padding: EdgeInsets.symmetric(vertical: 15.0)),
                TextFormField(
                  keyboardType: TextInputType.numberWithOptions(decimal: false),
                  validator: (value) {
                    int? number = int.tryParse(value!);
                    if (number == null || number <= 0) {
                      return 'El valor debe ser mayor a 0.';
                    }
                    return null;
                  },
                  controller: ctrlPaginas,
                  decoration: InputDecoration(
                      labelText: "Páginas",
                      border: new OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(25.0),
                      )),
                ),
                Padding(padding: EdgeInsets.symmetric(vertical: 15.0)),
                TextFormField(
                  validator: (value) {
                    return value!.isEmpty ? "Campo Vacío" : null;
                  },
                  controller: ctrlEditorial,
                  decoration: InputDecoration(
                      labelText: "Editorial",
                      border: new OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(25.0),
                      )),
                ),
                Padding(padding: EdgeInsets.symmetric(vertical: 15.0)),
                imagen != null ? Image.file(imagen!) : Container(),
                Padding(padding: EdgeInsets.symmetric(vertical: 15.0)),
                ElevatedButton(
                    onPressed: () async {
                      ImagePicker picker = new ImagePicker();
                      var imagenSeleccionada =
                          await picker.pickImage(source: ImageSource.gallery);
                      if (imagenSeleccionada != null) {
                        imagen = File(imagenSeleccionada.path);
                        imagenblob = base64Encode(imagen!.readAsBytesSync());
                        setState(() {});
                      }
                    },
                    child: Text("Buscar Portada")),
                Padding(padding: EdgeInsets.symmetric(vertical: 15.0)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                        onPressed: () async {
                          if (!formKey.currentState!.validate()) {
                            return;
                          }
                          Libro libro = new Libro(
                              null,
                              ctrlTitulo.text,
                              ctrlAutor.text,
                              ctrlGenero.text,
                              int.parse(ctrlPaginas.text),
                              ctrlEditorial.text,
                              imagenblob!);
                          Libro? libroGuardado = await db.guardarLibro(libro);
                          if (libroGuardado != null) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Paginaprincipal()));
                            return showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    insetPadding:
                                        EdgeInsets.fromLTRB(5, 370, 5, 370),
                                    content: Center(
                                      child: Text(
                                        "Guardado",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  );
                                });
                          }
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [Text("Guardar"), Icon(Icons.save)],
                        )),
                    Padding(padding: EdgeInsets.symmetric(vertical: 15.0)),
                    ElevatedButton(
                        onPressed: () {
                          ctrlAutor.text = "";
                          ctrlEditorial.text = "";
                          ctrlGenero.text = "";
                          ctrlPaginas.text = "";
                          ctrlTitulo.text = "";
                          imagen = null;
                          imagenblob = null;
                          setState(() {});
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [Text("Limpiar"), Icon(Icons.clear)],
                        ))
                  ],
                ),
                Padding(padding: EdgeInsets.symmetric(vertical: 15.0)),
              ],
            )),
      ),
    );
  }
}
