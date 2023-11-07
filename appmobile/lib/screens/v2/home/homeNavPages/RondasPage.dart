import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sammseguridad_apk/provider/rondasProvider.dart';
import 'package:sammseguridad_apk/screens/v2/generarVisita/maps/mapsview.dart';
import 'package:sammseguridad_apk/screens/v2/home/floatings/FloatingRondas.dart';
import 'package:sammseguridad_apk/screens/v2/home/homeNavPages/Rondas/Recorridos/PuntosDelRecorrido.dart';
import 'package:sammseguridad_apk/screens/v2/home/homeNavPages/Rondas/RondaDetalle.dart';
import 'package:sammseguridad_apk/services/ApiService.dart';

class RondasPage extends StatefulWidget {
  const RondasPage({Key? key});

  @override
  State<RondasPage> createState() => _RondasPageState();
}

class _RondasPageState extends State<RondasPage> {
  @override
  Widget build(BuildContext context) {
    final RondasProvider rondasProvider = Provider.of<RondasProvider>(context);
    final ApiService apiService = Provider.of<ApiService>(context);

    return RefreshIndicator(
      onRefresh: () async {
                    setState(() {
                      //rondasProvider.getRondasList(apiService);
                    });
                  },
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            width: double.infinity,
            child: Center(
              child: Text(
                'Rondas',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
    
          RondasListView(
              rondasProvider: rondasProvider, apiService: apiService),
          // PuntosDelRecorrido(
          //   rondaNombre: "rondaNombre",
          //   rondaConcretaId: 1,
          // ),
          Container(
              margin: EdgeInsets.all(20),
              alignment: Alignment.bottomRight,
              child: FloatingRondas())
        ],
      ),
    );
  }
}

class RondasListView extends StatelessWidget {
  const RondasListView({
    super.key,
    required this.rondasProvider,
    required this.apiService,
  });

  final RondasProvider rondasProvider;
  final ApiService apiService;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: FutureBuilder<List<Map<String, dynamic>>>(
        future: rondasProvider.getRondasList(apiService),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator()); // Mostrar un indicador de carga mientras se espera la respuesta.
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            final rondas = snapshot.data ?? [];
    
            if (rondas.isEmpty) {
              rondasProvider.getRondasList(apiService);
              return Center(
                child: Text('No hay rondas'),
              );
            }
    
            return ListView.builder(
              // reverse: true,
              itemCount: rondas.length,
              itemBuilder: (context, index) {
                final item = rondas[index]; // Obtener elementos en orden inverso
                final id = item['Id'];
                final ubi = item['NameUbicacion'];
                final descripcion = item['descripcion'];
                final fechaCrea = item['FechaCreacion'];
    
                return GestureDetector(
                  onTap: () {
                    rondasProvider.selectedItem = item!;
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RondaDetalle(
                          idRonda: id,
                          descripcionRonda: descripcion,
                          nombreRonda: ubi,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    margin:
                        const EdgeInsets.only(bottom: 10, left: 10, right: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: ListTile(
                      // title: Text('$id - $ubi'),
                      title: Text('$id - $descripcion'),
                      subtitle: Text('Fecha Creación: $fechaCrea'),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      tileColor: Colors.blue[50],
                      trailing: Icon(Icons.arrow_forward_ios),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
