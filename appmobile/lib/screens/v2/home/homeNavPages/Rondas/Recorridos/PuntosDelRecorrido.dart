import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sammseguridad_apk/provider/rondasProvider.dart';
import 'package:sammseguridad_apk/screens/v2/generarVisita/maps/mapsview.dart';
import 'package:sammseguridad_apk/screens/v2/generarVisita/maps/mapviewController.dart';
import 'package:sammseguridad_apk/services/ApiService.dart';
import 'package:sammseguridad_apk/widgets/Appbar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PuntosDelRecorrido extends StatefulWidget {
  final String rondaNombre;
  final int rondaConcretaId;
  const PuntosDelRecorrido({
    required this.rondaNombre,
    required this.rondaConcretaId,
    super.key
    
  });

  @override
  State<PuntosDelRecorrido> createState() => _PuntosDelRecorridoState();
}

class _PuntosDelRecorridoState extends State<PuntosDelRecorrido> {
  List<Map<String, dynamic>> puntos = [];
  bool isLoading = true;
  bool hasError = false;
  late MapviewController mapviewController;



  @override
  void initState() {
    super.initState();
    mapviewController = Provider.of<MapviewController>(context, listen: false);
    _fetchPuntos();
    // _iniciarActualizacionProximidad();
  }

  Future<void> _fetchPuntos() async {
    final RondasProvider rondasProvider = Provider.of<RondasProvider>(context, listen: false);
    final ApiService apiService = Provider.of<ApiService>(context, listen: false);

    try {
      final newPuntos = await getRondaConcretaPoints(apiService, widget.rondaConcretaId.toString());
      setState(() {
        puntos = newPuntos;
        isLoading = false;
      });
    } catch (e) {
      print('Error al cargar puntos: $e');
      // setState(() {
      //   hasError = true;
      //   isLoading = false;
      // });
    }
  }

  Future<List<Map<String, dynamic>>> getRondaConcretaPoints(
      ApiService apiService,String rondaConcretaId
  ) async {
    
    List<Map<String, dynamic>> puntos = [];
    
    try{
      var sharedPreferences = await SharedPreferences.getInstance();
      var jwtToken = sharedPreferences.getString("token") ?? "";
      int idAgente = sharedPreferences.getInt("Id") ?? 0;


      Map<String,dynamic> dataPuntos = {
        "idRecorrido": widget.rondaConcretaId,
        //"idAgente": idAgente
      };
      print('ronda concreta id es esta : ${widget.rondaConcretaId}');
      Map<String,dynamic> responsePuntos = await apiService.postData("/rondas/getPuntosRecorridoxRonda", dataPuntos, jwtToken);
      if (!responsePuntos.containsKey("message") && responsePuntos['data'].length > 0){
        
        responsePuntos['data'].forEach((punto) {

          Map<String, dynamic> convertedPunto = {
            "Id" : punto['Puntos']['IdPuntoConcreto'],
            "Descripcion" : punto['Puntos']['Descripcion'],
            "Coordenada" : punto['Puntos']['Coordenadas'],
            "Estado" : punto['Puntos']['EstadoPuntoConcreto'],
          };
          puntos.add(convertedPunto);
        });
      }

      final positionList = mapviewController.setMarkersByPositionList2(puntos);

      

    }catch(e){
      // Si no es una lista, lanza una excepción o maneja este caso de manera apropiada
      // print(e);
    }finally{
      return puntos;
    }
    // Future<SharedPreferences> prefs =SharedPreferences.getInstance();
  }



  @override
  Widget build(BuildContext context) {
    Widget result;
    if (isLoading) {
      result = CircularProgressIndicator();
    } else if (hasError) {
      result= Text('Error al cargar puntos');
    } else if (puntos.isEmpty) {
      result= Text('No hay puntos');
    } else {
      result= Column(
        children: puntos.map((punto) {
          print(punto["Id"]);
          return ListTile(
            title: Text(punto['Descripcion'].toString()),
            subtitle: Text(punto['Coordenada']),
            leading: 
              punto["Estado"] == "RECORRIDO"
              ? Icon(Icons.location_on,color: Colors.green,)
              : Icon(Icons.location_on,color: Colors.red,),
          );
        }).toList(),
      );
    }
    return RefreshIndicator(
      onRefresh: _fetchPuntos,
      child: SingleChildScrollView(
        child: result
      ),
    );
    // return RefreshIndicator(
    //   onRefresh: _fetchPuntos,
    //   child: result,
    // );
  }
}

class PuntosConcretosScreen extends StatelessWidget {
  final String rondaNombre;
  final int rondaConcretaId;
  const PuntosConcretosScreen({
    required this.rondaNombre,
    required this.rondaConcretaId,
    super.key
    
  });

  @override
  Widget build(BuildContext context) {
    RondasProvider rondasProvider = Provider.of<RondasProvider>(context, listen: false);
    ApiService apiService = Provider.of<ApiService>(context, listen: false);
    MapviewController mapviewController = Provider.of<MapviewController>(context, listen: false);
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: ()async {
          // TODO: rondaconcretaid creo que no es el id de la ronda hay que ver de donde se lo obtiene
          // var listarondas = await rondasProvider.getRondaPoints(apiService, rondaConcretaId.toString());
          // final positionList = mapviewController.setMarkersByPositionList(listarondas);
          mapviewController.menuselection = 1;
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MapView(
                idRonda: rondaConcretaId,
              ),
            ),
          );
        },
        label:  Row(
          children: [
            Text('ver en el mapa', style: TextStyle(color: Colors.white),),
            SizedBox(width: 10,),
            Icon(Icons.map, color: Colors.white,)
          ],
        ),
        backgroundColor: Colors.blue[900],
      ),
      appBar: CustomAppBar(),
      body: PuntosDelRecorrido(
        rondaNombre: rondaNombre,
        rondaConcretaId: rondaConcretaId,
      ),
    );
  }
}