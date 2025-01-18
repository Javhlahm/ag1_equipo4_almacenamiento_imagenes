import 'dart:convert';

import 'package:ag1_equipo4_almacenamiento_imagenes/OperacionesMYSQL.dart';
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
          IconButton(onPressed: null, icon: Icon(Icons.search)),
          IconButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Paginaregistro()));
              },
              icon: Icon(Icons.book_online))
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
                  return Card(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Image.memory(snapshot.data![index].portada),
                        Text(
                          snapshot.data![index].titulo,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(snapshot.data![index].autor),
                        Text(snapshot.data![index].paginas.toString()),
                        Text(snapshot.data![index].editorial),
                        Text(snapshot.data![index].genero),
                      ],
                    ),
                  );
                });
          },
        ),
      ),
    );
  }
}
