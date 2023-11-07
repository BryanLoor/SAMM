import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sammseguridad_apk/provider/MainNavigationIndexProvider.dart';
import 'package:sammseguridad_apk/provider/mainprovider.dart';
import 'package:sammseguridad_apk/provider/rondasProvider.dart';
import 'package:sammseguridad_apk/screens/v2/home/homeNavPages/Rondas/Recorridos/MisRecorridos.dart';
import 'package:sammseguridad_apk/screens/v2/home/homeNavPages/Rondas/Recorridos/PuntosDelRecorrido.dart';
import 'package:sammseguridad_apk/services/ApiService.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePageAgente extends StatefulWidget {
  const HomePageAgente({Key? key}) : super(key: key);

  @override
  State<HomePageAgente> createState() => _HomePageAgenteState();
}

class _HomePageAgenteState extends State<HomePageAgente> {
  static const routeName = 'HomePageAgente';
  String nombreUsuario = MainProvider.prefs.getString("Nombres") ?? "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Future<Map<String, dynamic>> getData() async {
    try {
      var sharedPreferences = await SharedPreferences.getInstance();
      var jwtToken = sharedPreferences.getString("token") ?? "";
      int idAgente = sharedPreferences.getInt("Id") ?? 0;
      // int idAgente = 1;
      ApiService apiService = Provider.of<ApiService>(context, listen: false);

      Map<String, dynamic> responseRondas = await apiService.getData(
          "/rondas/getRecorridoDiario/$idAgente", jwtToken);
      return responseRondas;
    } catch (e) {
      print(e);
    }
    return {};
  }

  @override
  Widget build(BuildContext context) {
    final RondasProvider recorridoDiario = Provider.of<RondasProvider>(context);
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
            padding: EdgeInsets.all(16),
            alignment: Alignment.centerLeft,
            color: Colors.blue[900],
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Recorrido de hoy",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Ir a Recorridos",
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
                  future: getData(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                          child:
                              CircularProgressIndicator()); // Mostrar un indicador de carga mientras se espera la respuesta.
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      Map<String, dynamic> recorrido = snapshot.data!;

                      if (recorrido.isEmpty) {
                        return Center(
                          child: Text('No hay rondas'),
                        );
                      }
                      recorrido = recorrido["data"];
                      final id = recorrido['idRonda'];
                      final ubi = recorrido['NameUbicacion'];
                      final descripcion = recorrido['descripcion'];
                      final fechaCrea = recorrido['fechaRecorrido'];
                      DateFormat inputFormat =
                          DateFormat("E, dd MMM yyyy HH:mm:ss 'GMT'");

                      String fechaCreaFormateada =
                          DateFormat('MMMM dd , yyyy  ', 'es')
                              .format(inputFormat.parse(fechaCrea));
                      return InkWell(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => PuntosConcretosScreen(
                                rondaNombre: recorrido["descripcion"],
                                rondaConcretaId: recorrido["idRondaBitacora"],
                              ),
                            ),
                          );
                        },
                        child: Card(
                          elevation: 4,
                          shadowColor: Colors.white,
                          color: Colors.blue[50],
                          child: Container(
                              //width: 350,
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
                        ),
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
