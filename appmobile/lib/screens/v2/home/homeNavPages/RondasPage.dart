import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sammseguridad_apk/provider/rondasProvider.dart';
import 'package:sammseguridad_apk/screens/v2/generarVisita/maps/mapsview.dart';
import 'package:sammseguridad_apk/services/ApiService.dart';

class RondasPage extends StatefulWidget {
  const RondasPage({Key? key});

  @override
  State<RondasPage> createState() => _RondasPageState();
}

class _RondasPageState extends State<RondasPage> {
  TabMenu tabMenuView = TabMenu.Personas;
  @override
  Widget build(BuildContext context) {
    final RondasProvider rondasProvider = Provider.of<RondasProvider>(context);
    final ApiService apiService = Provider.of<ApiService>(context);

    return Column(
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
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
          ),
          width: double.infinity,
          child: Center(
            child: SegmentedButton<TabMenu>(
              segments: const <ButtonSegment<TabMenu>>[
                ButtonSegment<TabMenu>(
                  value: TabMenu.Historial,
                  label: Text('Historial'),
                  icon: Icon(Icons.history)
                ),
                ButtonSegment<TabMenu>(
                  value: TabMenu.Personas,
                  label: Text('Personas'),
                  icon: Icon(Icons.person)
                ),
              ],
              selected: <TabMenu>{tabMenuView},
              selectedIcon: Icon(Icons.shield),
              onSelectionChanged: (Set<TabMenu> newSelection) {
                setState(() {
                  // By default there is only a single segment that can be
                  // selected at one time, so its value is always the first
                  // item in the selected set.
                  tabMenuView = newSelection.first;
                });
                
              },
            ),
          )
        ),
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
                        // leading: Icon(Icons.location_on),
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

enum TabMenu { Historial, Personas}
