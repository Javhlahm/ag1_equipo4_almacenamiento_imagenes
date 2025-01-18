import 'dart:convert';

import 'package:ag1_equipo4_almacenamiento_imagenes/OperacionesMYSQL.dart';
import 'package:ag1_equipo4_almacenamiento_imagenes/PaginaDetalles.dart';
import 'package:ag1_equipo4_almacenamiento_imagenes/libro.dart';
import 'package:flutter/material.dart';

class Paginabusqueda extends StatefulWidget {
  const Paginabusqueda({super.key});

  @override
  State<Paginabusqueda> createState() => _PaginabusquedaState();
}

class _PaginabusquedaState extends State<Paginabusqueda> {
  late List<Libro> libroEncontrado = [];
  var formKey = GlobalKey<FormState>();
  Operacionesmysql db = new Operacionesmysql();
  TextEditingController ctrlBuscar = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Buscar Libro"),
        centerTitle: true,
        backgroundColor: Colors.amber,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(padding: EdgeInsets.symmetric(vertical: 20)),
          Form(
              key: formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: ctrlBuscar,
                    validator: (value) {
                      return value!.isEmpty ? "Campo Vacío" : null;
                    },
                    decoration: InputDecoration(
                        labelText: "Libro",
                        border: new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(25.0),
                        )),
                  ),
                  Padding(padding: EdgeInsets.symmetric(vertical: 20)),
                  ElevatedButton(
                      onPressed: () async {
                        formKey.currentState?.validate();
                        libroEncontrado =
                            await db.seleccionarLibro(ctrlBuscar.text);
                        setState(() {});
                      },
                      child: Icon(Icons.search)),
                ],
              )),
          Padding(padding: EdgeInsets.symmetric(vertical: 20)),
          Expanded(
            child: ListView.builder(
                itemCount: libroEncontrado.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Paginadetalles(
                                    libro: libroEncontrado[index],
                                  )));
                    },
                    child: Card(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            height: 200,
                            width: 100,
                            child: Image.memory(
                                scale: 2.0,
                                base64Decode(libroEncontrado[index].portada!)),
                          ),
                          Padding(
                              padding: EdgeInsets.symmetric(vertical: 10.0)),
                          Text(
                            libroEncontrado[index].titulo,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20.0),
                          ),
                          Padding(padding: EdgeInsets.symmetric(vertical: 15)),
                        ],
                      ),
                    ),
                  );
                }),
          )
        ],
      ),
    );
  }
}
