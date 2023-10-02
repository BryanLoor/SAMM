import 'dart:math';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapviewController with ChangeNotifier{
  final Map<MarkerId,Marker> _markers = {};
  
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

  List<LatLng> getMarkersPositionList(){
    // List<LatLng> positionList = [];
    // _markers.forEach((key, value) {
    //   positionList.add(value.position);
    // });
    return _markers.values.toSet().map(
      (marker) => marker.position
    ).toList();
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

  void setMarkersByPositionList(List<LatLng> positionList) {
    cleanMarkers();
    positionList.forEach((position) {
      addPositionMarker(position);
    });
  }

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

  bool estaCercaDeUnMarcador(LatLng  ubicacion, Set<Marker> markers,double distanciaMinima) {
    for (Marker marker in markers) {
      double distancia = calcularDistanciaHaversine(
        ubicacion,
        marker.position,
      );

      if (distancia < distanciaMinima) {
        removeMarker(marker.markerId);
        return true;
      }
    }
    return false;
  }
}