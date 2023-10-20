import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sammseguridad_apk/provider/rondasProvider.dart';
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

  @override
  void initState() {
    super.initState();
    _fetchPuntos();
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
        "idRonda": widget.rondaConcretaId,
        "idAgente": idAgente
      };
      Map<String,dynamic> responsePuntos = await apiService.postData("/rondas/getPuntosRecorridoxRonda", dataPuntos, jwtToken);
      if (!responsePuntos.containsKey("message") && responsePuntos['data'].length > 0){
        
        responsePuntos['data'].forEach((punto) {

          Map<String, dynamic> convertedPunto = {
            "Descripcion" : punto['Puntos']['Descripcion'],
            "Coordenada" : punto['Puntos']['Coordenadas'],
          };
          puntos.add(convertedPunto);
        });
      }

      

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
          return Dismissible(
            key: Key(punto['Id'].toString()),
            onDismissed: (direction) {
              setState(() {
                puntos.remove(punto);
              });
              _fetchPuntos();
            },
            background: Container(color: Colors.red),

            child: ListTile(
              title: Text(punto['Descripcion'].toString()),
              subtitle: Text(punto['Coordenada']),
              leading: Icon(Icons.location_on),
              // Otros elementos de ListTile según tus datos
            ),
          );
        }).toList(),
      );
    }
    return RefreshIndicator(
      onRefresh: _fetchPuntos,
      child: SingleChildScrollView(
        child: result,
      ),
    );
    // return RefreshIndicator(
    //   onRefresh: _fetchPuntos,
    //   child: result,
    // );
  }
}

