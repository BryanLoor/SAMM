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
      setState(() {
        hasError = true;
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return CircularProgressIndicator();
    } else if (hasError) {
      return Text('Error al cargar puntos');
    } else if (puntos.isEmpty) {
      return Text('No hay puntos');
    } else {
      return SingleChildScrollView(
        child: Column(
          children: puntos.map((punto) {
            return ListTile(
              title: Text(punto['Descripcion'].toString()),
              subtitle: Text(punto['Coordenada']),
              leading: Icon(Icons.location_on),
              // Otros elementos de ListTile según tus datos
            );
          }).toList(),
        ),
      );
    }
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