
// import 'dart:async';

import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sammseguridad_apk/provider/rondasProvider.dart';
import 'package:sammseguridad_apk/screens/v2/generarVisita/maps/mapviewController.dart';
// import 'package:sammseguridad_apk/services/ApiService.dart';

class RondaSeleccionada extends StatefulWidget {
  // RondasProvider rondasprovider;
  // ApiService apiService;
  // List<Map<String, dynamic>> listarondas;
  RondaSeleccionada({
    // required this.rondasprovider,
    // required this.apiService,
    super.key
  });

  @override
  State<RondaSeleccionada> createState() => _RondaSeleccionadaState();
}

class _RondaSeleccionadaState extends State<RondaSeleccionada> {

  // @override
  // void initState() {
  //   // RondasProvider rondasprovider = Provider.of<RondasProvider>(context);
  //   // ApiService apiService = Provider.of<ApiService>(context);

  //   //   var listarondas = await widget.rondasprovider.getRondaPoints(widget.apiService, widget.rondasprovider.selectedItem["Id"].toString());

  //   //   final positionList = widget.mapviewController.setMarkersByPositionList(listarondas);

  //   //   if(positionList.isNotEmpty){
  //   //     widget.mapviewController.goTo(
  //   //       await widget.controller.future,
  //   //       positionList[0]
  //   //     );

  //   //   }else {
  //   //     // rondasProvider.cleanSelectedItem();
  //   //   }
  //   // super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    RondasProvider rondasProvider = Provider.of<RondasProvider>(context);
    // ApiService apiService = Provider.of<ApiService>(context);
    MapviewController mapviewController = Provider.of<MapviewController>(context);
    var item = rondasProvider.selectedItem;
    return DraggableScrollableSheet(
      initialChildSize: 0.1,
      minChildSize: 0.1,
      maxChildSize: 0.1,
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
          child: GestureDetector(
            onTap: (){
              mapviewController.menuselection = 0;
            },
            child: ListView(
              controller: scrollController,
              children: [
                ListTile(
                  title: Text('${item["Id"]} - ${item["NameUbicacion"]}'),
                  subtitle: Text('Fecha Creación: ${item['Ubicacion']['fecha_crea']}'),
                  leading: Icon(Icons.location_on),
                ),
              ],
            ),
          )
        ),
      ),
    );
  }
}