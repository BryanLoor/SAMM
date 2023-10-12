import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sammseguridad_apk/services/ApiService.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RondasProvider with ChangeNotifier {
  // String token = "";
  // rondaSelected
  // int rondaselected = 0;
  Map<String, dynamic> _selectedItem = {};
  List<Map<String, dynamic>> _ItemPuntos = [];

  List<Map<String, dynamic>> get ItemPuntos => _ItemPuntos;

  set ItemPuntos(List<Map<String, dynamic>> item) {
    _ItemPuntos = item;
    notifyListeners();
  }

  Map<String, dynamic> get selectedItem => _selectedItem;
  set selectedItem(Map<String, dynamic> item) {
    _selectedItem = item;
    notifyListeners();
  }

  void cleanSelectedItem() {
    _selectedItem = {};
    notifyListeners();
  }

  bool get hasSelectedItem => _selectedItem.isNotEmpty;


  Future<List<Map<String, dynamic>>> getRondasList(
      ApiService apiService) async {
    // Future<SharedPreferences> prefs =SharedPreferences.getInstance();
    var sharedPreferences = await SharedPreferences.getInstance();
    var token = sharedPreferences.getString("token") ?? "";
    var response = await apiService.getData('/rondas/getAllRondas', token);
    // var response = await apiService.getData('/visitas/getAllBitacoraVisitasCondense', token);
    // print(response);
    // Verifica si la respuesta es una lista
    if (response["data"] is List) {
      // Asegúrate de que cada elemento de la lista es un Map<String, dynamic>
      // return response["data"].cast<Map<String, dynamic>>();
      var RondasMaps = response["data"].cast<Map<String, dynamic>>();
      return RondasMaps;
    }

    // Si no es una lista, lanza una excepción o maneja este caso de manera apropiada
    throw Exception("Invalid data format");
  }


  Future<List<Map<String, dynamic>>> getRondaPoints(
      ApiService apiService,String rondaID) async {
    // Future<SharedPreferences> prefs =SharedPreferences.getInstance();
    var sharedPreferences = await SharedPreferences.getInstance();
    var token = sharedPreferences.getString("token") ?? "";
    var response = await apiService.getData('/rondaPunto/getRondaPuntosxRonda/$rondaID', token);
    // var response = await apiService.getData('/visitas/getAllBitacoraVisitasCondense', token);

    // Verifica si la respuesta es una lista
    if (response["data"] is List) {
      // Asegúrate de que cada elemento de la lista es un Map<String, dynamic>
      // return response["data"].cast<Map<String, dynamic>>();
      var puntos = response["data"].cast<Map<String, dynamic>>();
      ItemPuntos = puntos;
      return puntos;
    }

    // Si no es una lista, lanza una excepción o maneja este caso de manera apropiada
    throw Exception("Invalid data format");
  }


  Future<void> enviarNuevoPunto(
    ApiService apiService,
    int IdRonda,
    int orden,
    String coordenada,
    String descripcion
  ) async {
    var sharedPreferences = await SharedPreferences.getInstance();
    var token = sharedPreferences.getString("token") ?? "";
    var data = {
      "IdRonda": IdRonda,
      "Coordenada": coordenada,
      "Descripcion": descripcion,
      "Orden": orden
    };
    var response = await apiService.postData('/rondaPunto/createRondaPuntoxRonda', data,token);
    // var response = await apiService.getData('/visitas/getAllBitacoraVisitasCondense', token);

  }
    //   rondaPunto.IdRonda = request.json['IdRonda']
    // rondaPunto.Orden = request.json['Orden']
    // rondaPunto.Coordenada = request.json['Coordenada']
    // rondaPunto.Descripcion = request.json['Descripcion']


  Future<int> enviarNuevaRonda(
    ApiService apiService,
    // int IdRonda,
    int idUsuarioSupervisor,
    int idUbicacion,
    String descripcion
  ) async {
    var sharedPreferences = await SharedPreferences.getInstance();
    var token = sharedPreferences.getString("token") ?? "";
    var data = {
      "IdUsuarioSupervisor": idUsuarioSupervisor,
      "IdUbicacion": idUbicacion,
      "Desripcion": descripcion
    };
    var response = await apiService.postData('/rondas/crearRonda', data,token);
    // var response = await apiService.getData('/visitas/getAllBitacoraVisitasCondense', token);
    int rondasId = response["IdRonda"]??0;
    return rondasId;
    
  }


  Future<void> GenerarYenviarNuevaRonda(
    ApiService apiService,
    // int IdRonda,
    int idUsuarioSupervisor,
    int idUbicacion,
    int orden,
    String descripcion,
    List<LatLng> coordenadas
  ) async {
     enviarNuevaRonda(
      apiService, 
      idUsuarioSupervisor, 
      idUbicacion, 
      descripcion
    ).then((idRonda){
      coordenadas.forEach((coordenada) {
        String coordString = coordenada.latitude.toString() + "," + coordenada.longitude.toString();
        enviarNuevoPunto(
          apiService, 
          idRonda,
          orden,
          coordString,
          descripcion
        );
      });
    });
    
  }

  Future<void> registrarPresencia(
    ApiService apiService,
    int idRonda,
    int idPuntoRonda,
    String codigo,
    String descripcion,
    String fotoURL

  ) async {
    var sharedPreferences = await SharedPreferences.getInstance();
    var token = sharedPreferences.getString("token") ?? "";
    var data = {
      "IdRonda": idRonda,
      "IdPuntoRonda": idPuntoRonda,
      "Codigo": codigo,
      "Descripcion": descripcion,
      "FotoURL": fotoURL
    };
    var response = await apiService.postData('/rondas/guardarPuntoRealizado', data,token);
  }
    //   ronda.Desripcion = request.json['Desripcion']
    // ronda.Estado = 0
    // ronda.IdUbicacion = request.json['IdUbicacion']
    // ronda.FechaCreacion = datetime.now()
    // ronda.UsuCreacion = idUsuario[0]
    // ronda.FechaModifica = datetime.now()
    // ronda.UsuModifica = idUsuario[0]
    // ronda.IdUsuarioSupervisor = request.json['IdUsuarioSupervisor']

}