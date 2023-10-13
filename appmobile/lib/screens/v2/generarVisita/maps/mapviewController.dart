import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapviewController with ChangeNotifier{
  Map<MarkerId,Marker> _markers = {};

  Marker _markerSelected = Marker(
    markerId: MarkerId(''),
    position: LatLng(0, 0),
    icon: BitmapDescriptor.defaultMarkerWithHue(200),
    infoWindow: InfoWindow(
      title: '',
      snippet: '',
    ),
  );

  Completer<GoogleMapController> _controller = Completer<GoogleMapController>();

  Completer<GoogleMapController> get completerController => _controller;

  set completerController(Completer<GoogleMapController> newCompleterController){
    _controller = newCompleterController;
    notifyListeners();
  }

  List<LatLng> _positionList = [];

  List<LatLng> get positionList => _positionList;

  set positionList(List<LatLng> newPositionList){
    _positionList = newPositionList;
    notifyListeners();
  }

  Marker get markerSelected => _markerSelected;
  set markerSelected(Marker newMarkerSelected){
    _markerSelected = newMarkerSelected;
    notifyListeners();
  }

  bool _cercaDeunPunto = false;

  bool get cercaDeunPunto => _cercaDeunPunto;

  set cercaDeunPunto(bool newCercaDeunPunto){
    _cercaDeunPunto = newCercaDeunPunto;
    notifyListeners();
  }
  
  CameraPosition _CameraPosition = CameraPosition(
    target: LatLng(-2.0187734,-78.886048), // Coordenadas iniciales en (0, 0)
    zoom: 7.3, // Zoom inicial
  );

  int _menuselection = 0;

  int get menuselection => _menuselection;
  set menuselection(int newmenuselection){
    _menuselection = newmenuselection;
    notifyListeners();
  }


  CameraPosition get cameraPosition => _CameraPosition;
  set cameraPosition(CameraPosition newCameraPosition){
    _CameraPosition = newCameraPosition;
    notifyListeners();
  }

  void completarcompleter(GoogleMapController cont){
    if(!_controller.isCompleted){
      _controller.complete(cont);
    }
  }

  Future<void> goTo(GoogleMapController controller,LatLng coordenada) async {
    menuselection = 4;
    _CameraPosition = CameraPosition(
      target: coordenada,
      zoom: 17.0,
    );
    await controller.animateCamera(
      CameraUpdate.newCameraPosition(
        // await _getCurrentLocation()
        _CameraPosition,
      )
    );
  }
  Future<void> goToFirst(GoogleMapController controller) async {
    if (positionList.isEmpty) {
      return;
    }
    menuselection = 4;
    _CameraPosition = CameraPosition(
      target: positionList[0],
      zoom: 17.0,
    );
    await controller.animateCamera(
      CameraUpdate.newCameraPosition(
        // await _getCurrentLocation()
        _CameraPosition,
      )
    );
  }

  Set<Marker> get markers => _markers.values.toSet();
  // set markers(Map<MarkerId,Marker> newMarkers){
  //   _markers = newMarkers;
  //   notifyListeners();
  // }

  void addMarker(Marker marker){
    _markers[marker.markerId] = marker;
    notifyListeners();
  }
  void removeMarker(MarkerId markerId){
    _markers.remove(markerId);
    notifyListeners();
  }

  void replaceMarker(MarkerId markerId,Marker newMarker){
    _markers.remove(markerId);
    addMarker(newMarker);
    // _markers[markerId] = newMarker;
    // notifyListeners();
  }

  List<LatLng> getMarkersPositionList(){
    // List<LatLng> positionList = [];
    // _markers.forEach((key, value) {
    //   positionList.add(value.position);
    // });
    return _markers.values.toSet().map(
      (marker) => marker.position
    ).toList();
  }

  Future<void> addPositionMarkerWithId(LatLng position,String id) async {
    final markerId = MarkerId(id);
    final marker = Marker(
      markerId: markerId,
      position: position,
      // icon: await BitmapDescriptor.fromAssetImage(
      //   ImageConfiguration(),
      //   'assets/images/marker.png',
      // ),
      icon:BitmapDescriptor.defaultMarkerWithHue(200),
      infoWindow: InfoWindow(
        title: markerId.value,
        snippet: '*',
      ),
    );
    addMarker(marker);
  }


  Future<void> addPositionMarker(LatLng position) async {
    final markerId = MarkerId(position.toString());
    final marker = Marker(
      markerId: markerId,
      position: position,
      // icon: await BitmapDescriptor.fromAssetImage(
      //   ImageConfiguration(),
      //   'assets/images/marker.png',
      // ),
      icon:BitmapDescriptor.defaultMarkerWithHue(200),
      infoWindow: InfoWindow(
        title: markerId.value,
        snippet: '*',
      ),
    );
    addMarker(marker);
  }

  void cleanMarkers(){
    _markers.clear();
    notifyListeners();
  }

  // void setMarkersByPositionList(List<LatLng> positionList) {
  List<LatLng> setMarkersByPositionList(List<Map<String, dynamic>> listarondas) {
    cleanMarkers();
    List<LatLng> latLngList = [];
    final data = listarondas;

    data.forEach((e) {
      final coordenadaSplit = e["Coordenada"].split(',');
      if (coordenadaSplit.length == 2) {
        final lat = double.tryParse(coordenadaSplit[0]);
        final lng = double.tryParse(coordenadaSplit[1]);
        final markid = e["Id"];
        if (lat != null && lng != null) {
          latLngList.add(LatLng(lat, lng));
          addPositionMarkerWithId(LatLng(lat, lng), markid.toString());
        }
      }
    });
    positionList = latLngList;
    return latLngList;
    // latLngList.forEach((position) {
    //   addPositionMarker(position);
    // });
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

  Future<CameraPosition> getCurrentLocation() async {
    try {
      Position position = await determinePosition();
      _CameraPosition = CameraPosition(
        target: LatLng(position.latitude, position.longitude),
        zoom: 18.0,
      );
      return _CameraPosition;
    } catch (e) {
      return _CameraPosition;
    }
  }

  Future<LatLng> getCurrentLatLng() async {
    
    Position position = await determinePosition();
    LatLng nrewpos = LatLng(position.latitude, position.longitude);
    return nrewpos;
  }

  Future<LatLng> addMyPosition()async{
    LatLng nrewpos = await getCurrentLatLng();
    addPositionMarker(await nrewpos);
    return nrewpos;
  }

  Future<LatLng> removeLastPosition() async {
    if (_markers.isNotEmpty) {
      final lastMarkerId = _markers.keys.last;
      final mark = _markers.remove(lastMarkerId);
      notifyListeners();
      return LatLng(mark!.position.latitude, mark.position.latitude);
    }
    return LatLng(0, 0);
  }

  Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.');
    } 

    return await Geolocator.getCurrentPosition();
  }

  double calcularDistanciaHaversine(LatLng punto1, LatLng punto2) {
    const double radioTierra = 6371000; // Radio de la Tierra en metros
    double latitud1 = punto1.latitude;
    double longitud1 = punto1.longitude;
    double latitud2 = punto2.latitude;
    double longitud2 = punto2.longitude;

    double dLat = (latitud2 - latitud1) * (pi / 180);
    double dLon = (longitud2 - longitud1) * (pi / 180);

    double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(latitud1 * (pi / 180)) *
            cos(latitud2 * (pi / 180)) *
            sin(dLon / 2) *
            sin(dLon / 2);

    double c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return radioTierra * c;
  }

  bool estaCercaDeUnMarcador(LatLng ubicacion,Set<Marker> markers, double distanciaMinima) {
    _cercaDeunPunto = false;
    final BitmapDescriptor azul = BitmapDescriptor.defaultMarkerWithHue(200);
    final BitmapDescriptor rojo = BitmapDescriptor.defaultMarkerWithHue(0);
    final BitmapDescriptor amarillo = BitmapDescriptor.defaultMarkerWithHue(50);
    final BitmapDescriptor verde = BitmapDescriptor.defaultMarkerWithHue(100);

    for (Marker marker in markers) {
      double distancia = calcularDistanciaHaversine(
        ubicacion,
        marker.position,
      );
      // print("aun sin comprovacion");
      // print(marker.icon.toJson().toString());
      // print(verde.toJson().toString());
      // print(marker.icon.toString() == azul.toString());
      
      
      if (marker.icon.toJson().toString() == verde.toJson().toString()) {
        // print("Caso cuando el icono es verde (Hue = 100)");
        // Caso cuando el icono es verde (Hue = 100)
      } else if (marker.icon.toString() == amarillo.toString()) {
        if (distancia < distanciaMinima) {
          _cercaDeunPunto = true;
          _markerSelected = marker;
          // Caso cuando el icono es amarillo (Hue = 50) y la distancia es menor que la distancia mínima
        } else {
          // Caso cuando el icono es amarillo (Hue = 50) pero la distancia es mayor o igual a la distancia mínima
          replaceMarker(
            marker.markerId,
            marker.copyWith(
              iconParam: BitmapDescriptor.defaultMarkerWithHue(0), // Cambiar a Rojo (Hue = 0)
            ),
          );
        }
      } 
      if (marker.icon.toJson().toString() == rojo.toJson().toString()) {
        // print("solo rojo");
        if (distancia < distanciaMinima) {
          // print("Caso cuando el icono es rojo (Hue = 0) y la distancia es menor que la distancia mínima");
          // Caso cuando el icono es rojo (Hue = 0) y la distancia es menor que la distancia mínima
          _cercaDeunPunto = true;
          _markerSelected = marker;
          replaceMarker(
            marker.markerId,
            marker.copyWith(
              iconParam: BitmapDescriptor.defaultMarkerWithHue(50), // Cambiar a Amarillo (Hue = 50)
            ),
          );
        }
        
      }
      if(marker.icon.toJson().toString() == azul.toJson().toString()){
        // print("Caso cuando el icono es azul (Hue = 200)");
          // Caso cuando el icono es azul (Hue = 200)
        replaceMarker(
          marker.markerId,
          marker.copyWith(
            iconParam: BitmapDescriptor.defaultMarkerWithHue(0), // Cambiar a Amarillo (Hue = 50)
          ),
        );
      }


    }
    
    notifyListeners();
    return _cercaDeunPunto;
  }



  void repintarMarkers(){
    _markers.forEach((key, value) {
      replaceMarker(
        key,
        value.copyWith(
          iconParam: BitmapDescriptor.defaultMarkerWithHue(0),
        ),
      );
    });
  }

  void registrarMarkerComoVisitado() {
    replaceMarker(
      _markerSelected.markerId,
      _markerSelected.copyWith(
        iconParam: BitmapDescriptor.defaultMarkerWithHue(100),//verde
      ),
    );
  }
}