import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sammseguridad_apk/provider/rondasProvider.dart';
import 'package:sammseguridad_apk/screens/v2/generarVisita/maps/mapviewController.dart';
import 'package:sammseguridad_apk/services/ApiService.dart';

class CrearRonda extends StatefulWidget {
  MapviewController mapviewController;
  Completer<GoogleMapController> controller;
  CrearRonda({
    required this.mapviewController,
    required this.controller,
    super.key,
  });

  @override
  State<CrearRonda> createState() => _CrearRondaState();
}

class _CrearRondaState extends State<CrearRonda> {
  int selectedIndex = -1;
  // List<LatLng> latLngList = [];


  @override
  Widget build(BuildContext context) {
    RondasProvider rondasProvider = Provider.of<RondasProvider>(context);
    ApiService apiService = Provider.of<ApiService>(context);
    TextEditingController rondanombre = TextEditingController();
    // widget.mapviewController.cleanMarkers();
    
    // MapviewController mapviewController = Provider.of<MapviewController>(context);
    return DraggableScrollableSheet(
      initialChildSize: 0.4,
      minChildSize: 0.1,
      maxChildSize: 0.4,
      builder: (context, scrollController) => Container(

        decoration: BoxDecoration(
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              offset: Offset(0, -5),
            ),
          ],
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25.0),
            topRight: Radius.circular(25.0),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            controller: scrollController,
            children: [
              ElevatedButton.icon(
                icon: const Icon(Icons.add),
                label: const Text("Agregar Punto"),
                onPressed: () {
                  widget.mapviewController.addMyPosition();
                  // .then(
                  //   (value) => latLngList.add(value)
                  // );
                }
              ),
              ElevatedButton.icon(
                icon: const Icon(Icons.backspace_outlined),
                label: const Text("Eliminar punto"),
                onPressed: () {
                  widget.mapviewController.removeLastPosition();
                }
              ),
              ElevatedButton.icon(
                icon: const Icon(Icons.save),
                label: const Text("Guardar Ronda"),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                      title: const Text('Guardar Ronda'),
                      // escribir el texxto de la ronda y enviar
                      content: TextField(
                        controller: rondanombre,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Descripcion de la Ronda',
                        ),
                      ),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () => Navigator.pop(context, 'Cancel'),
                          child: const Text('Cancelar'),
                        ),
                        TextButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (context) => CircularProgressIndicator(),
                            );
                            
                            // final List<LatLng> posiciones = widget.mapviewController.markers.map(
                            //   (marker) => marker.position
                            // ).toList();
                            //TODO: esos 1 s se llenan con algo no se con que
                            rondasProvider.GenerarYenviarNuevaRonda(
                              apiService,
                              1,
                              1,
                              1,
                              rondanombre.text,
                              widget.mapviewController.getMarkersPositionList(),
                            ).then(
                              (value) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    backgroundColor: Colors.green,
                                    content: Text('Ronda creada'),
                                  ),
                                );
                                widget.mapviewController.cleanMarkers();
                                widget.mapviewController.menuselection = 0;
                                // setState(() {
                                  
                                // });
                                Navigator.pop(context, 'OK');
                              }
                            );
                            Navigator.pop(context, 'OK');
                          },
                          child: const Text('Guardar'),
                        ),
                      ],
                    ),
                  );
                  // rondasProvider.enviarNuevaRonda(
                  //   apiService,
                  //   1,
                  //   1,
                  //   "Ronda de prueba",
                  
                  // );
                }
              ),
            ],
          )
        ),
      ),
    );
  }

// Future<List<LatLng>> setRondasPoint(List<Map<String, dynamic>> listarondas) async {
//   final data = await listarondas;
//   List<LatLng> latLngList = [];

//   data.forEach((e) {
//     final coordenadaSplit = e["Coordenada"].split(',');
//     if (coordenadaSplit.length == 2) {
//       final lat = double.tryParse(coordenadaSplit[0]);
//       final lng = double.tryParse(coordenadaSplit[1]);
//       if (lat != null && lng != null) {
//         latLngList.add(LatLng(lat, lng));
//       }
//     }
//   });

//   return latLngList;
// }

  // PopupMenuButton acciones() {
  //   return PopupMenuButton(
  //     child: const Icon(Icons.more_vert),
  //     itemBuilder: (context) => [
  //       PopupMenuItem(
  //         child: Text("Realizar Ronda"),
  //         value: 1,
  //       ),
  //       PopupMenuItem(
  //         child: Text("Editar Ronda"),
  //         value: 2,
  //       ),
  //     ],
  //   );
  // }
}
