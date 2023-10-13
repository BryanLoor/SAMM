// import 'dart:async';
// import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
// import 'package:sammseguridad_apk/provider/mainprovider.dart';
import 'package:sammseguridad_apk/provider/rondasProvider.dart';
import 'package:sammseguridad_apk/screens/v2/generarVisita/maps/MasOptions/CrearRonda.dart';
import 'package:sammseguridad_apk/screens/v2/generarVisita/maps/MasOptions/RealizarRecorrido.dart';
import 'package:sammseguridad_apk/screens/v2/generarVisita/maps/MasOptions/RondaSeleccionada.dart';
// import 'package:sammseguridad_apk/screens/v2/generarVisita/maps/MasOptions/RondasList.dart';
import 'package:sammseguridad_apk/screens/v2/generarVisita/maps/mapstyle.dart';
import 'package:sammseguridad_apk/screens/v2/generarVisita/maps/mapviewController.dart';
// import 'package:sammseguridad_apk/screens/v2/home/homeNavPages/Rondas/crearRonda.dart';
// import 'package:sammseguridad_apk/services/ApiService.dart';
import 'package:sammseguridad_apk/widgets/Appbar.dart';

class MapView extends StatefulWidget {
  final int idRonda;
  MapView({
    required this.idRonda,
    super.key
  });

  @override
  State<MapView> createState() => MapViewState();
}

// String token = '';
class MapViewState extends State<MapView> {
  // final Completer<GoogleMapController> _controller = Completer<GoogleMapController>();
  
  // final mapviewcontroller = MapviewController();
  // int selection = 0;

  // @override
  // void initState() {
  //   super.initState();
    
  // }

  // @override
  // void dispose() {
  //   // mapviewcontroller.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    RondasProvider rondasprovider = Provider.of<RondasProvider>(context);
    // ApiService apiService = Provider.of<ApiService>(context);
    MapviewController mapviewcontroller = Provider.of<MapviewController>(context);
    mapviewcontroller.getCurrentLocation();
    return Scaffold(
      appBar: CustomAppBar(),
      floatingActionButton: acciones(rondasprovider,mapviewcontroller),
      body: Stack(
    
        children:[
          // _buildGoogleMap(context),
          MapaGoogle(
            id: widget.idRonda,
          ),
          if (mapviewcontroller.menuselection == 0)
          RondaSeleccionada(
          ),
          if (mapviewcontroller.menuselection == 3 || mapviewcontroller.menuselection == 2)
          CrearRonda(
          ),
          if (mapviewcontroller.menuselection == 1)
          RealizarRecorrido(
            mapviewController: mapviewcontroller,
          ),
          if (mapviewcontroller.menuselection == 4)
          RondaSeleccionada(
          ),
        ], 
      ),
    );
    //   ),
    //   bottomNavigationBar: _buildNavBar(),
    // );
  }

  PopupMenuButton acciones(rondasprovider,mapviewcontroller) {
    return PopupMenuButton(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(
          height: 50,
          width: 50,
          margin: const EdgeInsets.only(top: 10),
          decoration: BoxDecoration(
            color: Colors.blue[900],
            borderRadius: BorderRadius.circular(25),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 5,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: const Icon(Icons.keyboard_arrow_up, color: Colors.white,)
        ),
      ),
      itemBuilder: (context) => [
        // PopupMenuItem(
        //   child: Text("Rondas"),
        //   value: 0,
        // ),


        if(rondasprovider.hasSelectedItem)
        const PopupMenuItem(
          child: Text("Realizar Recorrido"),
          value: 1,
        ),


        if(rondasprovider.hasSelectedItem)
        PopupMenuItem(
          child: Text("Editar Ronda"),
          value: 2,
        ),


        PopupMenuItem(
          child: Text("Crear Ronda"),
          value: 3,
        ),
      ],
      onSelected: (value) {
        setState(() {
          // print("value: $value");
          if (value == 0 || value == 3) {
            rondasprovider.cleanSelectedItem();
            mapviewcontroller.cleanMarkers();
          }
            mapviewcontroller.menuselection = value;
          
        });
      },
    );
  }



  BottomNavigationBar _buildNavBar() {
    return BottomNavigationBar(items: [
      BottomNavigationBarItem(
        icon: Icon(Icons.home),
        label: 'Inicio',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.person),
        label: 'Perfil',
      ),
    ]);
  }

}

class MapaGoogle  extends StatelessWidget {
  final id;
  const MapaGoogle ({
    required this.id,
    super.key
  });

  @override
  Widget build(BuildContext context) {

    // RondasProvider rondasProvider = Provider.of<RondasProvider>(context);
    // ApiService apiService = Provider.of<ApiService>(context);
    MapviewController mapviewcontroller = Provider.of<MapviewController>(context);
    return GoogleMap(
      zoomControlsEnabled: false,
      mapType: MapType.normal,
      initialCameraPosition: mapviewcontroller.cameraPosition,
      markers: mapviewcontroller.markers,
      myLocationEnabled: true,
      onMapCreated: (GoogleMapController controller) {
        controller.setMapStyle(MapStyle.style);
        // mapviewcontroller.completerController = controller;
        mapviewcontroller.completarcompleter(controller);
        // mapviewcontroller.completerController.complete(controller);
        mapviewcontroller.goToFirst(controller);
      },
    );
  }
}
