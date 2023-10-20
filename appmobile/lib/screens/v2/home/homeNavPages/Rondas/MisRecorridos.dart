import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:sammseguridad_apk/provider/rondasProvider.dart';

class MisRecorridos extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // RondasProvider rondasProvider = Provider.of<RondasProvider>(context, listen: false);
    return FutureBuilder<List<RondaData>>(
      future: fetchMisRecorridos(),
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
                  child: Card(
                    margin: EdgeInsets.all(10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Flexible(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              '${ronda.nombreRonda}',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                
                              )
                            ),
                          ),
                        ),
                        SizedBox(width: 10.0,height:100,),
                        Text('${ronda.nPuntosRecorridos} - ${ronda.nPuntosTotales}'),
                        SizedBox(width: 10.0,),
                        // SizedBox(width: 10.0,),
                      ],
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

  Future<Map<String,dynamic>> getTestData() async {
    var response = {
      "data" : [
        {
          "Nombreronda" : "ronda1",
          "n_puntosTotales" : 3,
          "n_puntosRecorridos" : 0

        },
        {
          "Nombreronda" : "ronda2",
          "n_puntosTotales" : 5,
          "n_puntosRecorridos" : 5

        },
        {
          "Nombreronda" : "ronda3",
          "n_puntosTotales" : 8,
          "n_puntosRecorridos" : 1

        },
      ]
    };
    // un delay de un segundo y retornar response
    await Future.delayed(Duration(seconds: 1));
    return response;
  }
  //TODO: Cambiar la url por la del endpoint o usar el apiservice
  Future<List<RondaData>> fetchMisRecorridos() async {
    Map<String,dynamic> response = await getTestData();
    List<RondaData> rondas = [];
    for (var ronda in response['data']) {
      rondas.add(RondaData.fromJson(ronda));
    }
    return rondas;
  }
}

class RondaData {
  final String nombreRonda;
  final int nPuntosTotales;
  final int nPuntosRecorridos;

  RondaData({
    required this.nombreRonda,
    required this.nPuntosTotales,
    required this.nPuntosRecorridos,
  });

  factory RondaData.fromJson(Map<String, dynamic> json) {
    return RondaData(
      nombreRonda: json['Nombreronda'],
      nPuntosTotales: json['n_puntosTotales'],
      nPuntosRecorridos: json['n_puntosRecorridos'],
    );
  }
}
