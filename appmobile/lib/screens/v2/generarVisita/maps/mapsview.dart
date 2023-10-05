import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:sammseguridad_apk/provider/mainprovider.dart';
import 'package:sammseguridad_apk/provider/rondasProvider.dart';
import 'package:sammseguridad_apk/screens/v2/generarVisita/maps/MasOptions/CrearRonda.dart';
import 'package:sammseguridad_apk/screens/v2/generarVisita/maps/MasOptions/RealizarRecorrido.dart';
import 'package:sammseguridad_apk/screens/v2/generarVisita/maps/MasOptions/RondaSeleccionada.dart';
import 'package:sammseguridad_apk/screens/v2/generarVisita/maps/MasOptions/RondasList.dart';
import 'package:sammseguridad_apk/screens/v2/generarVisita/maps/mapstyle.dart';
import 'package:sammseguridad_apk/screens/v2/generarVisita/maps/mapviewController.dart';
// import 'package:sammseguridad_apk/screens/v2/home/homeNavPages/Rondas/crearRonda.dart';
import 'package:sammseguridad_apk/services/ApiService.dart';
import 'package:sammseguridad_apk/widgets/Appbar.dart';

class MapView extends StatefulWidget {
  const MapView({super.key});

  @override
  State<MapView> createState() => MapViewState();
}

// String token = '';
class MapViewState extends State<MapView> {
  final Completer<GoogleMapController> _controller = Completer<GoogleMapController>();
  
  final mapviewcontroller = MapviewController();
  // int selection = 0;

  @override
  void initState() {
    super.initState();
    mapviewcontroller.getCurrentLocation();
  }

  @override
  void dispose() {
    // mapviewcontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    RondasProvider rondasprovider = Provider.of<RondasProvider>(context);
    // return Scaffold(
    //   appBar: CustomAppBar(),
    //   body: ChangeNotifierProvider(
      return ChangeNotifierProvider(
        create: (context) => mapviewcontroller,
        child: Consumer<MapviewController>(
          builder: (context, mapviewcontroller, _) => Stack(

            children:[
              _buildGoogleMap(context),
              // acciones(),
              if (mapviewcontroller.menuselection == 0)
              RondasList(
                controller: _controller,
                mapviewController: mapviewcontroller,
              ),
              if (mapviewcontroller.menuselection == 3 || mapviewcontroller.menuselection == 2)
              CrearRonda(
                controller: _controller,
                mapviewController: mapviewcontroller,
              ),
              if (mapviewcontroller.menuselection == 1)
              RealizarRecorrido(
                controller: _controller,
                mapviewController: mapviewcontroller,
              ),
              if (mapviewcontroller.menuselection == 4)
              RondaSeleccionada(
                controller: _controller,
                mapviewController: mapviewcontroller,
              ),
              Positioned(
                right: 0,   // Para alinear a la derecha
                bottom: 0,
                // bottom: MediaQuery.of(context).size.height / 2, // Para alinear en el centro verticalmente
                child: acciones(rondasprovider),
              ),
            ], 
          ),
        )
      );
      // ),
      // bottomNavigationBar: _buildNavBar(),
    // );
  }

  PopupMenuButton acciones(rondasprovider) {
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
        PopupMenuItem(
          child: Text("Rondas"),
          value: 0,
        ),


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
          print("value: $value");
          if (value == 0 || value == 3) {
            rondasprovider.cleanSelectedItem();
            mapviewcontroller.cleanMarkers();
          }
            mapviewcontroller.menuselection = value;
          
        });
      },
    );
  }

  // ChangeNotifierProvider<MapviewController> _buildGoogleMap(BuildContext context) {
  //   return ChangeNotifierProvider(
  //       create: (context) => mapviewcontroller,
  //       child: Consumer<MapviewController>(
  //         builder: (context, mapviewcontroller, _) => 
  //         GoogleMap(
  //           zoomControlsEnabled: false,
  //           mapType: MapType.normal,
  //           initialCameraPosition: mapviewcontroller.cameraPosition,
  //           markers: mapviewcontroller.markers,
  //           myLocationEnabled: true,
  //           // onTap: (argument) => mapviewcontroller.addPositionMarker(argument),
  //           onMapCreated: (GoogleMapController controller) {
  //             controller.setMapStyle(MapStyle.style);
  //             _controller.complete(controller);
  //           },
              
  //         ),
  //       ),
  //     );
  // }
  Widget _buildGoogleMap(BuildContext context) {
    return Consumer<MapviewController>(
      builder: (context, mapviewcontroller, _) => GoogleMap(
        zoomControlsEnabled: false,
        mapType: MapType.normal,
        initialCameraPosition: mapviewcontroller.cameraPosition,
        markers: mapviewcontroller.markers,
        // circles: Set<Circle>.of([
        //   Circle(
        //     circleId: CircleId('radius_circle'), // ID único para el círculo
        //     center: LatLng(-2.1196965,-79.9110527), // Coordenadas del centro del círculo
        //     radius: 20, // Radio en metros (ejemplo: 1000 metros = 1 km)
        //     fillColor: Colors.blue.withOpacity(0.2), // Color del relleno
        //     strokeColor: Colors.blue, // Color del borde
        //     strokeWidth: 2, // Ancho del borde
        //   ),
        // ]),
        myLocationEnabled: true,
        onMapCreated: (GoogleMapController controller) {
          controller.setMapStyle(MapStyle.style);
          _controller.complete(controller);
        },
      ),
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

  // Future<void> _goTo() async {
  //   final GoogleMapController controller = await _controller.future;
  //   await controller.animateCamera(
  //     CameraUpdate.newCameraPosition(
  //       // await _getCurrentLocation()
  //       mapviewcontroller.cameraPosition,
  //     )
  //   );
  // }
}

