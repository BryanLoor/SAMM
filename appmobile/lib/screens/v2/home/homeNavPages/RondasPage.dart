import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sammseguridad_apk/provider/rondasProvider.dart';
import 'package:sammseguridad_apk/screens/v2/generarVisita/maps/mapsview.dart';
import 'package:sammseguridad_apk/services/ApiService.dart';

class RondasPage extends StatelessWidget {
  const RondasPage({Key? key});

  @override
  Widget build(BuildContext context) {
    final RondasProvider rondasProvider = Provider.of<RondasProvider>(context);
    final ApiService apiService = Provider.of<ApiService>(context);

    return Column(
      children: [
        // ElevatedButton(
        //   onPressed: () {
        //     Navigator.push(
        //       context,
        //       MaterialPageRoute(builder: (context) => MapView()),
        //     );
        //   },
        //   child: Text('Iniciar mapa'),
        // ),
        FutureBuilder<List<Map<String, dynamic>>>(
          future: rondasProvider.getRondasList(apiService),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator(); // Mostrar un indicador de carga mientras se espera la respuesta.
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              final rondas = snapshot.data ?? [];

              return Expanded(
                child: ListView.builder(
                  itemCount: rondas.length,
                  itemBuilder: (context, index) {
                    final item = rondas[index];
                    final id = item['Id'];
                    final ubi = item['NameUbicacion'];
                    final descripcion = item['Descripcion'];
                    final fechaCrea = item['Ubicacion']['fecha_crea'];

                    return Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: ListTile(
                        title: Text('$id - $ubi'),
                        subtitle: Text('Fecha Creación: $fechaCrea'),
                        leading: Icon(Icons.location_on),
                      ),
                    );
                  },
                ),
              );
            }
          },
        ),
      ],
    );
  }
}
