
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sammseguridad_apk/provider/rondasProvider.dart';
import 'package:sammseguridad_apk/screens/v2/generarVisita/maps/mapviewController.dart';
import 'package:sammseguridad_apk/services/ApiService.dart';

class RealizarRecorrido extends StatefulWidget {
  MapviewController mapviewController;
  Completer<GoogleMapController> controller;
  RealizarRecorrido({
    required this.mapviewController,
    required this.controller,
    super.key
  });

  @override
  State<RealizarRecorrido> createState() => _RealizarRecorridoState();
}

class _RealizarRecorridoState extends State<RealizarRecorrido> {
  @override
  Widget build(BuildContext context) {
    RondasProvider rondasProvider = Provider.of<RondasProvider>(context);
    ApiService apiService = Provider.of<ApiService>(context);
    TextEditingController rondanombre = TextEditingController();
    // widget.mapviewController.cleanMarkers();
    
    // MapviewController mapviewController = Provider.of<MapviewController>(context);
    return DraggableScrollableSheet(
      initialChildSize: 0.3,
      minChildSize: 0.1,
      maxChildSize: 0.3,
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
                icon: const Icon(Icons.location_on),
                label: const Text("Comprovar ubicacion"),
                onPressed: () async {
                  LatLng ubication = 
                  await widget.mapviewController
                  .getCurrentLocation()
                  .then(
                    (value) => value.target
                  );
                  Set<Marker> markers = widget.mapviewController.markers;
                  
                  

                  bool estaCerca = widget.mapviewController.estaCercaDeUnMarcador(
                    ubication,
                    markers,
                    10
                  );
                  if (estaCerca) {
                    // La ubicación está cerca de un marcador
                    if (widget.mapviewController.markers.isEmpty){
                      //  mostrar snackbar que diga ronda finalizada
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          backgroundColor: Colors.green,
                          content: Text("Recorrido finalizado"),
                        )
                      );
                    }
                  } else {
                    // La ubicación no está cerca de ningún marcador
                  }

                }
              ),
              ElevatedButton.icon(
                icon: const Icon(Icons.save),
                label: const Text("Terminar recorrido"),
                onPressed: () {
                  widget.mapviewController.menuselection = 0;
                  //  mostrar snackbar que diga ronda finalizada
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      backgroundColor: Colors.green,
                      content: Text("Finalizado"),
                    )
                  );

                }
              ),
            ],
          )
        ),
      ),
    );
  }
}