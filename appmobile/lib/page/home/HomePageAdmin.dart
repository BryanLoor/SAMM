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
    final MainNavigationIndexProvider indexProvider = Provider.of<MainNavigationIndexProvider>(context);

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
            padding: EdgeInsets.all(8),
            alignment: Alignment.centerLeft,
            color: Colors.blue[900],
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Tus últimas 5 rondas creadas",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Ir a Rondas",
                                      style: TextStyle(color: Colors.white, fontSize: 15),

                    ),
                    IconButton(onPressed: () {
                      indexProvider.current=1;
                    }, icon:Icon(Icons.arrow_forward_outlined, color: Colors.white,))
                  ],
                )
              ],
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
                          final item = rondas[
                              index]; // Obtener elementos en orden inverso
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
                                padding: EdgeInsets.only(left: 20,right: 20),
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
                                          Text(
                                            "$descripcion",
                                            style: TextStyle(fontSize: 20),
                                          ),
                                          SizedBox(height: 10,),
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
          ),
        )
      ],
    );
  }
}
