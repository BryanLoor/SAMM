import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sammseguridad_apk/provider/mainprovider.dart';
import 'package:sammseguridad_apk/provider/visitasProvider.dart';
import 'package:sammseguridad_apk/services/ApiService.dart';

class HomePageAnfitrion extends StatefulWidget {
  HomePageAnfitrion({Key? key}) : super(key: key);

  @override
  State<HomePageAnfitrion> createState() => _HomePageAnfitrionState();
}

class _HomePageAnfitrionState extends State<HomePageAnfitrion> {
  static const routeName = 'HomePageAnfitrion';
  String nombreUsuario = MainProvider.prefs.getString("Nombres") ?? "";
 
  
  

  @override
  Widget build(BuildContext context) {
    final VisitasProvider visitasProvider =
        Provider.of<VisitasProvider>(context);

    return Column(
      //mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
            margin: EdgeInsets.only(top: 100),
            child: Text(
              'Bienvenido $nombreUsuario',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            )),
        Container(
          height: 100,
          decoration: BoxDecoration(
            color: Colors.blue[900],
            //borderRadius: BorderRadius.only( bottomLeft: Radius.elliptical(100, 100))
          ),
          child: Container(
            height: 100,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.elliptical(100, 100),
                    bottomRight: Radius.elliptical(100, 100))),
          ),
        ),
        Container(
            width: double.infinity,
            padding: EdgeInsets.all(16),
            alignment: Alignment.centerLeft,
            color: Colors.blue[900],
            child: Text(
              "Tus últimas 5 visitas",
              style: TextStyle(color: Colors.white, fontSize: 20),
            )),
        Expanded(
          child: Container(
            height: MediaQuery.of(context).size.height * 0.7,
            decoration: BoxDecoration(
              color: Colors.blue[900],
              // borderRadius: BorderRadius.only( topLeft: Radius.elliptical(100, 100))
            ),
            child: Container(
              padding: EdgeInsets.only(top: 10, bottom: 350),
              child: FutureBuilder(
                  future: visitasProvider.refreshvisitas(context, visitasProvider),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                          child:
                              CircularProgressIndicator()); // Mostrar un indicador de carga mientras se espera la respuesta.
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      List<Map<String, dynamic>> visitas = snapshot.data ?? [];
                      if (visitas.length > 5) visitas = visitas.take(5).toList();
                      sleep(Duration(seconds: 1));
                      if (visitas.isEmpty) {
                        visitasProvider.getVisitaList(ApiService());
                        
                        return Center(
                          child: Text('No hay visitas'),
                        );
                      }
                      return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: visitas.length,
                        itemBuilder: (BuildContext context, int index) {
                          final item = visitas[
                              index]; // Obtener elementos en orden inverso
                          final id = item['Id'];
                          final ubi = item['Ubicacion'];
                          //final descripcion = item['descripcion'];
                          final placa = item['Placa'];
                          final fechaVisitaEstimada =
                              item['FechaTimeVisitaEstimada'];
                          final nombreVisitante = item["NombresVisitante"] +" "+
                              item["ApellidosVisitante"];
                          DateFormat inputFormat =
                              DateFormat("E, dd MMM yyyy HH:mm:ss 'GMT'");
    
                          String fechaCreaFormateada = DateFormat(
                                  'MMMM dd , yyyy, HH:mm', 'es')
                              .format(inputFormat.parse(fechaVisitaEstimada));
                          return Card(
                            elevation: 4,
                            shadowColor: Colors.white,
                            color: Colors.blue[50],
                            child: Container(
                                width: 350,
                                padding: EdgeInsets.only(left: 20, right: 20),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Align(
                                        alignment: Alignment.bottomRight,
                                        child: Text(
                                          "$fechaCreaFormateada",
                                        )),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              width: 100,
                                              child: Text(
                                                "Visitante: $nombreVisitante",
                                                style: TextStyle(fontSize: 20),
                                                overflow: TextOverflow
                                                    .ellipsis, // Agrega puntos suspensivos cuando el texto es demasiado largo
                                                maxLines:
                                                    2, // Número máximo de líneas antes de cortar el texto
                                              ),
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Icon(Icons.car_crash_outlined),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Text(
                                                  " $placa",
                                                  style:
                                                      TextStyle(fontSize: 15),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Row(
                                              children: [
                                                Icon(
                                                    Icons.location_on_outlined),
                                                Text(
                                                  "$ubi",
                                                  style:
                                                      TextStyle(fontSize: 18),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                        Icon(
                                          Icons.directions_walk_sharp,
                                          size: 50,
                                        )
                                      ],
                                    )
                                  ],
                                )),
                          );
                        },
                      );
                    }
                  }),
            ),
          ),
        )
      ],
    );
  }
}
