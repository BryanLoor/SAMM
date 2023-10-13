import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sammseguridad_apk/provider/rondasProvider.dart';
import 'package:sammseguridad_apk/screens/v2/generarVisita/maps/mapviewController.dart';
import 'package:sammseguridad_apk/services/ApiService.dart';

class RondasList extends StatefulWidget {
  final MapviewController mapviewController;
  final Completer<GoogleMapController> controller;
  RondasList({
    required this.mapviewController,
    required this.controller,
    super.key,
  });

  @override
  State<RondasList> createState() => _RondasListState();
}

class _RondasListState extends State<RondasList> {
  int selectedIndex = -1;


  @override
  Widget build(BuildContext context) {
    RondasProvider rondasProvider = Provider.of<RondasProvider>(context);
    ApiService apiService = Provider.of<ApiService>(context);
    // MapviewController mapviewController = Provider.of<MapviewController>(context);
    return DraggableScrollableSheet(
      initialChildSize: 1,
      minChildSize: 0.1,
      maxChildSize: 1,
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
          child: FutureBuilder<List<Map<String, dynamic>>>(
            future: rondasProvider.getRondasList(apiService), // Llama a la función para obtener los nuevos elementos
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                // Mientras se carga el Future, puedes mostrar un indicador de carga
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                // Si hay un error al cargar los nuevos elementos, muestra un mensaje de error
                return Text('Error: ${snapshot.error}');
              } else if (snapshot.hasData) {
                // Si el Future se completó exitosamente, combina los elementos y muestra el ListView
                final todosLosElementos = snapshot.data;
                return ListView.builder(
                  controller: scrollController,
                  itemCount: todosLosElementos?.length ?? 0,
                  itemBuilder: (context, index) {
                    final reversedIndex = todosLosElementos!.length - 1 - index;
                    final item = todosLosElementos[reversedIndex];
                    final id = item?['Id'];
                    final ubi = item?['NameUbicacion'];
                    // final descripcion = item?['Descripcion'];
                    final fechaCrea = item['Ubicacion']['fecha_crea'];

                    return GestureDetector(
                      onTap: () async{
                        // Cambia el índice seleccionado cuando se toca un elemento
                        setState(() {
                          selectedIndex = index;
                        });
                        rondasProvider.selectedItem = item!;
                        var listarondas = await rondasProvider.getRondaPoints(apiService, id.toString());
                        // final positionList = await setRondasPoint(listarondas);
                        // widget.mapviewController.setMarkersByPositionList(positionList);
                        final positionList = widget.mapviewController.setMarkersByPositionList(listarondas);
                        // widget.mapviewController.menuselection = 4;
                        // mover la camara hacia el punto seleccionado
                        // widget.mapviewController.cameraPosition = CameraPosition(
                        //   target: positionList[0],
                        //   zoom: 18.0,
                        // );
                        // si la lista de posiciones no esta vacia
                        if(positionList.isNotEmpty){
                          widget.mapviewController.goTo(
                            await widget.controller.future,
                            positionList[0]
                          );

                        }else {
                          // rondasProvider.cleanSelectedItem();
                        }
                          
                      },
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        decoration: BoxDecoration(
                          color: selectedIndex == index ? Colors.blue[100] : Colors.white,
                          borderRadius: BorderRadius.circular(25),
                          // boxShadow: const [
                          //   BoxShadow(
                          //     color: Colors.black12,
                          //     blurRadius: 5,
                          //     offset: Offset(0, 5),
                          //   ),
                          // ],
                        ),
                        child: ListTile(
                          title: Text('$id - $ubi'),
                          subtitle: Text('Fecha Creación: $fechaCrea'),
                          leading: Icon(Icons.location_on),
                          // trailing: acciones(),
                          // onTap: () async {
                          //   // carga en el mapa los puntos de la ronda
                          //   var listarondas = await rondasProvider.getRondaPoints(apiService, id.toString());
                          //   final positionList = await setRondasPoint(listarondas);
                          //   widget.mapviewController.setMarkersByPositionList(positionList);
                          
                          // },
                        ),
                      ),
                    );
                  },
                );
              } else {
                // Si no hay datos ni errores, muestra un indicador de carga por defecto
                return Center(
                  child: Container(
                    height: 100,
                    width: 100,
                    child: CircularProgressIndicator()
                    )
                );
              }
            },
          )
        ),
      ),
    );
  }

Future<List<LatLng>> setRondasPoint(List<Map<String, dynamic>> listarondas) async {
  final data = await listarondas;
  List<LatLng> latLngList = [];

  data.forEach((e) {
    final coordenadaSplit = e["Coordenada"].split(',');
    if (coordenadaSplit.length == 2) {
      final lat = double.tryParse(coordenadaSplit[0]);
      final lng = double.tryParse(coordenadaSplit[1]);
      if (lat != null && lng != null) {
        latLngList.add(LatLng(lat, lng));
      }
    }
  });

  return latLngList;
}

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
