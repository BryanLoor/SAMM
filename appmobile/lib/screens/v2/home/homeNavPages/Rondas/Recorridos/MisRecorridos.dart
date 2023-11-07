import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'package:provider/provider.dart';
import 'package:sammseguridad_apk/provider/mainprovider.dart';
import 'package:sammseguridad_apk/provider/rondasProvider.dart';
import 'package:sammseguridad_apk/screens/v2/home/homeNavPages/Rondas/Recorridos/PuntosDelRecorrido.dart';
import 'package:sammseguridad_apk/services/ApiService.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MisRecorridos extends StatefulWidget {
  @override
  State<MisRecorridos> createState() => _MisRecorridosState();
}

class _MisRecorridosState extends State<MisRecorridos> {
      TabMenu tabMenuView = TabMenu.MisRecorridos;

  @override
  Widget build(BuildContext context) {
    RondasProvider rondasProvider =
        Provider.of<RondasProvider>(context, listen: false);
    MainProvider mainProvider =
        Provider.of<MainProvider>(context, listen: false);

    return RefreshIndicator(
      onRefresh: () async {
                    setState(() {
                      //rondasProvider.getRondasList(apiService);
                    });
                  },
      child: Column(
        children: [
          Center(
              child: SegmentedButton<TabMenu>(
                style: ButtonStyle(
                          //backgroundColor: MaterialStateProperty.all(Colors.amber),
                          foregroundColor: MaterialStateProperty.resolveWith<Color>(
                            (Set<MaterialState> states) {
                              if (states.contains(MaterialState.selected)) {
                                return Colors.white; // Text color when selected
                              }
                              return Colors.black; // Text color when unselected
                            },
                          ),
                          backgroundColor: MaterialStateProperty.resolveWith<Color>(
                            (Set<MaterialState> states) {
                              if (states.contains(MaterialState.selected)) {
                                return const Color.fromRGBO(
                                    13, 71, 161, 1); // Background color when selected
                              }
                              return Colors
                                  .transparent; // Background color when unselected
                            },
                          ),
                        ),
                segments: const <ButtonSegment<TabMenu>>[
                            ButtonSegment<TabMenu>(
                                value: TabMenu.MisRecorridos,
                                label: Text('Mis Recorridos'),
                                icon: Icon(Icons.history)),
                            ButtonSegment<TabMenu>(
                                value: TabMenu.PorRecorrer,
                                label: Text('Por Recorrer'),
                                icon: Icon(Icons.pending_actions_outlined)),
                          ],
                          selected: <TabMenu>{tabMenuView},
                          selectedIcon: const Icon(Icons.shield),
                          onSelectionChanged: (Set<TabMenu> newSelection) {
                          setState(() {
                            // By default there is only a single segment that can be
                            // selected at one time, so its value is always the first
                            // item in the selected set.
                            tabMenuView = newSelection.first;
                          });
                        },),
                      
                          
            ),
          Expanded(
            child: ListView(
              scrollDirection: Axis.vertical,
              children: [FutureBuilder<List<RondaData>>(
                future: fetchMisRecorridos(context),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator()); // Muestra un indicador de carga mientras se obtienen los datos.
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    final data = snapshot.data!;
                    // Formato original
                    DateFormat originalFormat = DateFormat('E, d MMM yyyy HH:mm:ss zzz', 'en');
                    
                    // Formato de destino
                    DateFormat nuevoFormato = DateFormat('yyyy-MM-dd');
                    print(nuevoFormato.parse(DateTime.now().toString()));
                    return (tabMenuView == TabMenu.MisRecorridos)?ListView(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      children: [
                        for (var ronda in data)
            
                          if (originalFormat.parse(ronda.fechaRecorrido).toLocal().isBefore(nuevoFormato.parse(DateTime.now().toString())))
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20.0),
                              child: InkWell(
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => PuntosConcretosScreen(
                                        rondaNombre: ronda.nombreRonda,
                                        rondaConcretaId: ronda.idRondaBitacora,
                                      ),
                                    ),
                                  );
                                },
                                child: Card(
                                  
                                  margin: EdgeInsets.all(10.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Flexible(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                '${ronda.idRondaBitacora} ${ronda.nombreRonda}',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Text(
                                                  '${ronda.fechaRecorrido.substring(0, ronda.fechaRecorrido.length - 12)}'),
                                            ],
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10.0,
                                        height: 100,
                                      ),
                                      Text(
                                          '${ronda.nPuntosRecorridos} / ${ronda.nPuntosTotales}'),
                                      SizedBox(
                                        width: 10.0,
                                      ),
                                      ronda.nPuntosRecorridos==ronda.nPuntosTotales?
                                      Icon(Icons.check_circle_outline,color: Colors.green,):
                                      Icon(Icons.check_circle_outline,color: Colors.grey,)
                                      // SizedBox(width: 10.0,),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                      ],
                      // itemCount: data?.length,
                      // itemBuilder: (context, index) {
                      //   return Card(
                      // child: ListTile(
                      //   title: Text('Nombre Ronda: ${data?[index].nombreRonda}'),
                      //   subtitle: Column(
                      //     crossAxisAlignment: CrossAxisAlignment.start,
                      //     children: [
                      //       Text('Puntos Totales: ${data?[index].nPuntosTotales}'),
                      //       Text('Puntos Recorridos: ${data?[index].nPuntosRecorridos}'),
                      //     ],
                      //   ),
                      // ),
                      //   );
                      // },
                    ):ListView(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      children: [
                        Text("Aquí verás la ronda diaria y las próximas por hacer",textAlign: TextAlign.center,),
                        for (int i = data.length - 1; i >= 0; i--)
                          //ronda=data[i]
                        //for (var ronda in data)
                          if (originalFormat.parse(data[i].fechaRecorrido).isAfter(nuevoFormato.parse(DateTime.now().toString())) || (originalFormat.parse(data[i].fechaRecorrido).isAtSameMomentAs(nuevoFormato.parse(DateTime.now().toString())) ))
            
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20.0),
                              child: InkWell(
                                onTap: 1==3?() {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => PuntosConcretosScreen(
                                        rondaNombre: data[i].nombreRonda,
                                        rondaConcretaId: data[i].idRondaBitacora,
                                      ),
                                    ),
                                  );
                                }:null,
                                child: Card(
                                  
                                  margin: EdgeInsets.all(10.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Flexible(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                '${data[i].idRondaBitacora} ${data[i].nombreRonda}',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Text(
                                                  '${data[i].fechaRecorrido.substring(0, data[i].fechaRecorrido.length - 12)}'),
                                            ],
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10.0,
                                        height: 100,
                                      ),
                                      Text(
                                          '${data[i].nPuntosRecorridos} - ${data[i].nPuntosTotales}'),
                                      SizedBox(
                                        width: 10.0,
                                      ),
                                      data[i].nPuntosRecorridos==data[i].nPuntosTotales?
                                      Icon(Icons.check_circle_outline,color: Colors.green,):
                                      Icon(Icons.check_circle_outline,color: Colors.grey,)
                                      
                                      // SizedBox(width: 10.0,),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                      ],
                      // itemCount: data?.length,
                      // itemBuilder: (context, index) {
                      //   return Card(
                      // child: ListTile(
                      //   title: Text('Nombre Ronda: ${data?[index].nombreRonda}'),
                      //   subtitle: Column(
                      //     crossAxisAlignment: CrossAxisAlignment.start,
                      //     children: [
                      //       Text('Puntos Totales: ${data?[index].nPuntosTotales}'),
                      //       Text('Puntos Recorridos: ${data?[index].nPuntosRecorridos}'),
                      //     ],
                      //   ),
                      // ),
                      //   );
                      // },
                    );
                  }
                },
              )],
            ),
          ),
        ],
      ),
    );
  }

  Future<List<RondaData>> fetchMisRecorridos(context) async {
    try {
      var sharedPreferences = await SharedPreferences.getInstance();
      var jwtToken = sharedPreferences.getString("token") ?? "";
      int idAgente = sharedPreferences.getInt("Id") ?? 0;
      // int idAgente = 1;
      ApiService apiService = Provider.of<ApiService>(context, listen: false);

      Map<String, dynamic> data = {"idAgente": idAgente};

      Map<String, dynamic> responseRondas = await apiService.postData(
          "/rondas/getBitacoraRecorrido", data, jwtToken);
      if (responseRondas.containsKey("message")) {
        return [];
      }
      List<RondaData> rondas = [];
      for (var ronda in responseRondas['data']) {
        /*Map<String,dynamic> dataPuntos = {
        "idRonda": ronda['idRonda'],
        "idAgente": idAgente
      };*/
        Map<String, dynamic> dataPuntos = {
          "idRecorrido": ronda['idRondaBitacora'],
        };

        // print(dataPuntos);
        Map<String, dynamic> responsePuntos = await apiService.postData(
            "/rondas/getPuntosRecorridoxRonda", dataPuntos, jwtToken);

        if (!responseRondas.containsKey("message") &&
            responsePuntos['data'].length > 0) {
          int n_puntosRecorridos = 0;
          responsePuntos['data'].forEach((punto) {
            if (punto['Puntos']["EstadoPuntoConcreto"] == "RECORRIDO") {
              n_puntosRecorridos++;
            }
            // int n_puntosRecorridos = responsePuntos['data'].((punto) => punto['Puntos']["Estado"] == "R").length;
          });
          // Map<String,dynamic> puntos  = punto['Puntos'];
          String nombreronda =
              responsePuntos['data'][0]['RondaNombre'].toString();
          Map<String, dynamic> convertedRonda = {
            // "Puntos" : puntos,
            "IdRonda": ronda['idRonda'],
            "Nombreronda": nombreronda == "" ? "Sin nombre" : nombreronda,
            "n_puntosTotales": responsePuntos['total'],
            "n_puntosRecorridos": n_puntosRecorridos,
            "idRondaBitacora": ronda['idRondaBitacora'],
            "fechaRecorrido": ronda['fechaRecorrido'].toString()
          };
          rondas.add(RondaData.fromJson(convertedRonda));
        }
      }
      return rondas;
    } catch (e) {
      print(e);
      //throw Exception('Fallo al hacer post');
            return [];

    }
  }
}

class RondaData {
  // final Map<String,dynamic> puntos;
  final int id;
  final String nombreRonda;
  final int nPuntosTotales;
  final int nPuntosRecorridos;
  final int idRondaBitacora;
  final String fechaRecorrido;

  RondaData({
    required this.id,
    required this.nombreRonda,
    required this.nPuntosTotales,
    required this.nPuntosRecorridos,
    required this.idRondaBitacora,
    required this.fechaRecorrido,
  });

  factory RondaData.fromJson(Map<String, dynamic> json) {
    return RondaData(
      id: json['IdRonda'],
      idRondaBitacora: json['idRondaBitacora'],
      // puntos: json['Puntos'],
      nombreRonda: json['Nombreronda'],
      nPuntosTotales: json['n_puntosTotales'],
      nPuntosRecorridos: json['n_puntosRecorridos'],
      fechaRecorrido: json['fechaRecorrido'],
    );
  }
}

enum TabMenu { MisRecorridos, PorRecorrer }

// idRondaBitacora