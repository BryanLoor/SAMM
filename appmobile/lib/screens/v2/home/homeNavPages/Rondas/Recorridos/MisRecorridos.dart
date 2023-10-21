import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:sammseguridad_apk/provider/mainprovider.dart';
import 'package:sammseguridad_apk/provider/rondasProvider.dart';
import 'package:sammseguridad_apk/screens/logins/LoginResponse.dart';
import 'package:sammseguridad_apk/screens/v2/home/homeNavPages/Rondas/Recorridos/PuntosDelRecorrido.dart';
import 'package:sammseguridad_apk/services/ApiService.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MisRecorridos extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    RondasProvider rondasProvider = Provider.of<RondasProvider>(context, listen: false);
    MainProvider mainProvider = Provider.of<MainProvider>(context, listen: false);
    
    return FutureBuilder<List<RondaData>>(
      future: fetchMisRecorridos(context),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            child: CircularProgressIndicator(),
            height: 10,
          ); // Muestra un indicador de carga mientras se obtienen los datos.
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          final data = snapshot.data;
          return ListView(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            children: [
              for (var ronda in data!)
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
                              child: Text(
                                '${ronda.idRondaBitacora} ${ronda.nombreRonda}',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  
                                )
                              ),
                            ),
                          ),
                          SizedBox(width: 10.0,height:100,),
                          Text('${ronda.fechaRecorrido}'),
                          Text('${ronda.nPuntosRecorridos} - ${ronda.nPuntosTotales}'),
                          SizedBox(width: 10.0,),
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
    );
  }



  Future<List<RondaData>> fetchMisRecorridos(context) async {

    var sharedPreferences = await SharedPreferences.getInstance();
    var jwtToken = sharedPreferences.getString("token") ?? "";
    int idAgente = sharedPreferences.getInt("Id") ?? 0;
    // int idAgente = 1;
    ApiService apiService = Provider.of<ApiService>(context, listen: false);
    
    Map<String, dynamic> data = {
      "idAgente": idAgente
    };
    print(data);

    Map<String,dynamic> responseRondas = await apiService.postData("/rondas/getBitacoraRecorrido", data, jwtToken);
    if (responseRondas.containsKey("message")){
      return [];
    }
    List<RondaData> rondas = [];
    for (var ronda in responseRondas['data']) {
      Map<String,dynamic> dataPuntos = {
        "idRonda": ronda['idRonda'],
        "idAgente": idAgente
      };
      // print(dataPuntos);
      Map<String,dynamic> responsePuntos = await apiService.postData("/rondas/getPuntosRecorridoxRonda", dataPuntos, jwtToken);
      if (!responseRondas.containsKey("message") && responsePuntos['data'].length > 0){
        int n_puntosRecorridos = 0;
        responsePuntos['data'].forEach((punto) {
          if(punto['Puntos']["Estado"] == "P"){
            n_puntosRecorridos++;
          }
          // int n_puntosRecorridos = responsePuntos['data'].((punto) => punto['Puntos']["Estado"] == "R").length;
        });
        // Map<String,dynamic> puntos  = punto['Puntos'];
        String nombreronda = responsePuntos['data'][0]['RondaNombre'].toString();
        Map<String, dynamic> convertedRonda = {
          // "Puntos" : puntos,
          "IdRonda" : ronda['idRonda'],
          "Nombreronda" : nombreronda == "" ? "Sin nombre" : nombreronda,
          "n_puntosTotales" : responsePuntos['total'],
          "n_puntosRecorridos" : n_puntosRecorridos,
          "idRondaBitacora" : ronda['idRondaBitacora'],
          "fechaRecorrido" : ronda['fechaRecorrido'].toString()
        };
        rondas.add(RondaData.fromJson(convertedRonda));
        
      }
    }
    return rondas;
  }

  // //TODO: Cambiar la url por la del endpoint o usar el apiservice
  // Future<List<RondaData>> fetchPuntosDeRonda(context,idRonda,idAgente) async {
  //   var sharedPreferences = await SharedPreferences.getInstance();
  //   var jwtToken = sharedPreferences.getString("token") ?? "";
  //   ApiService apiService = Provider.of<ApiService>(context, listen: false);
    
  //   Map<String, dynamic> data = {
  //     "idRonda": idRonda,
  //     "idAgente": idAgente
  //   };

  //   Map<String,dynamic> response = await apiService.postData("/rondas/getPuntosRecorridoxRonda", data, jwtToken);
  //   List<RondaData> rondas = [];
  //   for (var ronda in response['data']) {
  //     // recorrer ronda['Puntos'] y contar en una variable los que tengan "Estado": "R"
  //     int n_puntosRecorridos =  ronda['Puntos'].where((punto) => punto['Estado'] == "R").length;

  //     Map<String, dynamic> converted = {
  //       "Puntos" : ronda['Puntos'],
  //       "Nombreronda" : ronda['IdRonda'],
  //       "n_puntosTotales" : ronda['Puntos'].length,
  //       "n_puntosRecorridos" : n_puntosRecorridos
  //     };
  //     rondas.add(RondaData.fromJson(ronda));
  //   }
  //   return rondas;
  // }
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


// idRondaBitacora