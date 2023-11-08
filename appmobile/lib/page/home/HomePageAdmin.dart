import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sammseguridad_apk/provider/MainNavigationIndexProvider.dart';
import 'package:sammseguridad_apk/provider/mainprovider.dart';
import 'package:sammseguridad_apk/provider/rondasProvider.dart';
import 'package:sammseguridad_apk/services/ApiService.dart';

class HomePageAdmin extends StatefulWidget {
  const HomePageAdmin({Key? key}) : super(key: key);
  @override
  State<HomePageAdmin> createState() => _HomePageAdminState();
}

class _HomePageAdminState extends State<HomePageAdmin> {
  static const routeName = 'HomePageAdmin';
  String nombreUsuario = MainProvider.prefs.getString("Nombres") ?? "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final RondasProvider rondasProvider = Provider.of<RondasProvider>(context);
    final MainNavigationIndexProvider indexProvider =
        Provider.of<MainNavigationIndexProvider>(context);

    return Column(
      //mainAxisAlignment: MainAxisAlignment.spaceBetween,

      children: [
        Container(
            margin: EdgeInsets.only(top: 100),
            child: Text(
              'Bienvenido $nombreUsuario',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
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
            padding: EdgeInsets.all(10),
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
                color: Colors.blue[900],
                border:
                    Border.all(color: const Color.fromRGBO(13, 71, 161, 1))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    "Tus últimas 5 rondas creadas",
                    style: TextStyle(color: Colors.white, fontSize: 15),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Ir a Rondas",
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                    IconButton(
                        onPressed: () {
                          indexProvider.current = 1;
                        },
                        icon: Icon(
                          Icons.arrow_forward_outlined,
                          color: Colors.white,
                        ))
                  ],
                )
              ],
            )),
        Container(
          decoration: BoxDecoration(color: Colors.blue[900]),
          height: 200,
          padding: EdgeInsets.only(
            top: 10,
          ),
          child: FutureBuilder(
              future: rondasProvider.getRondasList(ApiService()),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                      child:
                          CircularProgressIndicator()); // Mostrar un indicador de carga mientras se espera la respuesta.
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  List<Map<String, dynamic>> rondas = snapshot.data ?? [];
                  //rondas=rondas.reversed.toList();
                  if (rondas.length > 5) rondas = rondas.take(5).toList();

                  if (rondas.isEmpty) {
                    rondasProvider.getRondasList(ApiService());
                    return Center(
                      child: Text('No hay rondas'),
                    );
                  }

                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: rondas.length,
                    itemBuilder: (BuildContext context, int index) {
                      final item =
                          rondas[index]; // Obtener elementos en orden inverso
                      final id = item['Id'];
                      final ubi = item['NameUbicacion'];
                      final descripcion = item['descripcion'];
                      final fechaCrea = item['FechaCreacion'];
                      DateFormat inputFormat =
                          DateFormat("E, dd MMM yyyy HH:mm:ss 'GMT'");

                      String fechaCreaFormateada =
                          DateFormat('MMMM dd , yyyy  HH:mm:ss', 'es')
                              .format(inputFormat.parse(fechaCrea));
                      return Card(
                        elevation: 4,
                        shadowColor: Colors.white,
                        color: Colors.blue[50],
                        child: Container(
                            width: 350,
                            height: 300,
                            padding: EdgeInsets.only(left: 20, right: 20),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.5,
                                          child: Text(
                                            "$descripcion",
                                            style: TextStyle(fontSize: 20),
                                            overflow: TextOverflow
                                                .ellipsis, // Agrega puntos suspensivos cuando el texto es demasiado largo
                                            maxLines:
                                                2, // Número máximo de líneas antes de cortar el texto
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          children: [
                                            Icon(Icons.location_on_outlined),
                                            Text(
                                              "$ubi",
                                              style: TextStyle(fontSize: 18),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                    Icon(
                                      Icons.directions_run_outlined,
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
        Expanded(
          child: Container(
            decoration: BoxDecoration(color: Colors.blue[900]),
          ),
        )
      ],
    );
  }
}
