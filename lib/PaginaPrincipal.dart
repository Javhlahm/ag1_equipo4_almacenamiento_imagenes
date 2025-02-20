import 'dart:convert';

import 'package:ag1_equipo4_almacenamiento_imagenes/OperacionesMYSQL.dart';
import 'package:ag1_equipo4_almacenamiento_imagenes/PaginaBusqueda.dart';
import 'package:ag1_equipo4_almacenamiento_imagenes/PaginaDetalles.dart';
import 'package:ag1_equipo4_almacenamiento_imagenes/PaginaRegistro.dart';
import 'package:ag1_equipo4_almacenamiento_imagenes/libro.dart';
import 'package:flutter/material.dart';

class Paginaprincipal extends StatefulWidget {
  const Paginaprincipal({super.key});

  @override
  State<Paginaprincipal> createState() => _PaginaprincipalState();
}

class _PaginaprincipalState extends State<Paginaprincipal> {
  Operacionesmysql? baseDatos;

  void initState() {
    // TODO: implement initState
    super.initState();
    baseDatos = Operacionesmysql();
    obtenerLibros();
  }

  Future<List<Libro>> obtenerLibros() async {
    return baseDatos!.obtenerLibros();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Libreria AG4"),
        centerTitle: true,
        backgroundColor: Colors.amber,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Paginabusqueda()));
              },
              icon: Icon(Icons.search)),
          IconButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Paginaregistro()));
              },
              icon: Icon(Icons.new_label))
        ],
      ),
      body: Center(
        child: FutureBuilder(
          future: obtenerLibros(),
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return CircularProgressIndicator();
            }
            if (!snapshot.hasData) {
              return Center(
                child: Text("Sin datos"),
              );
            }
            return ListView.builder(
                padding: EdgeInsets.all(10),
                itemCount: snapshot.data?.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Paginadetalles(
                                    libro: snapshot.data![index],
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
                                base64Decode(snapshot.data![index].portada!)),
                          ),
                          Padding(
                              padding: EdgeInsets.symmetric(vertical: 10.0)),
                          Text(
                            snapshot.data![index].titulo,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20.0),
                          ),
                          Padding(padding: EdgeInsets.symmetric(vertical: 15)),
                        ],
                      ),
                    ),
                  );
                });
          },
        ),
      ),
    );
  }
}
