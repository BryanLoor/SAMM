import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sammseguridad_apk/provider/rondasProvider.dart';
import 'package:sammseguridad_apk/services/ApiService.dart';

class PuntosView extends StatefulWidget {
  final int idRonda;

  PuntosView({
    required this.idRonda,
  });

  @override
  _PuntosViewState createState() => _PuntosViewState();
}

class _PuntosViewState extends State<PuntosView> {
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
      final newPuntos = await rondasProvider.getRondaPoints(apiService, widget.idRonda.toString());
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


  Future<void> _removePunto(int puntoID) async {
    final RondasProvider rondasProvider = Provider.of<RondasProvider>(context, listen: false);
    final ApiService apiService = Provider.of<ApiService>(context, listen: false);

    try {
      // TODO: aqui se tiene que remover el punto
      // final newPuntos = await rondasProvider.removePoint(apiService, puntoID);
      setState(() {
        // puntos = newPuntos;
        isLoading = false;
      });
    } catch (e) {
      print('Error al cargar puntos: $e');
      setState(() {
        hasError = true;
        isLoading = false;
      });
    }
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



    // {
    //   "Coordenada": "-2.1203267,-79.9120667",
    //   "Descripcion": "",
    //   "Estado": "0",
    //   "FechaCreacion": "Thu, 28 Sep 2023 16:52:00 GMT",
    //   "FechaModificacion": "Thu, 28 Sep 2023 16:52:00 GMT",
    //   "Id": 26,
    //   "IdRonda": 96,
    //   "NameEstado": "activo",
    //   "NameUsuModifica": "Richard Michael Choez Velez",
    //   "Orden": 1,
    //   "UsuCreacion": 1,
    //   "UsuModifica": 1
    // },