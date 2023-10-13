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
      ApiService apiService
  ) async {
    List<Map<String, dynamic>> RondasMaps = [];

    try{
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
        RondasMaps = response["data"].cast<Map<String, dynamic>>();
      }

    }catch(e){
      // Si no es una lista, lanza una excepción o maneja este caso de manera apropiada
      print(e);
    }finally{
      return RondasMaps;
    }

  }


  Future<List<Map<String, dynamic>>> getRondaPoints(
      ApiService apiService,String rondaID
  ) async {
    
    List<Map<String, dynamic>> puntos = [];
    
    try{
      var sharedPreferences = await SharedPreferences.getInstance();
      var token = sharedPreferences.getString("token") ?? "";
      var response = await apiService.getData('/rondaPunto/getRondaPuntosxRonda/$rondaID', token);
      // var response = await apiService.getData('/visitas/getAllBitacoraVisitasCondense', token);

      // Verifica si la respuesta es una lista
      if (response["data"] is List) {
        // Asegúrate de que cada elemento de la lista es un Map<String, dynamic>
        // return response["data"].cast<Map<String, dynamic>>();
        puntos = response["data"].cast<Map<String, dynamic>>();
        ItemPuntos = puntos;
      }

      

    }catch(e){
      // Si no es una lista, lanza una excepción o maneja este caso de manera apropiada
      print(e);
    }finally{
      return puntos;
    }
    // Future<SharedPreferences> prefs =SharedPreferences.getInstance();
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
    await apiService.postData('/rondaPunto/createRondaPuntoxRonda', data,token);
    // var response = await apiService.getData('/visitas/getAllBitacoraVisitasCondense', token);

  }
    //   rondaPunto.IdRonda = request.json['IdRonda']
    // rondaPunto.Orden = request.json['Orden']
    // rondaPunto.Coordenada = request.json['Coordenada']
    // rondaPunto.Descripcion = request.json['Descripcion']


  Future<List<Map<String, dynamic>>> getRondaUbicaciones(
      ApiService apiService
  ) async {
    
    List<Map<String, dynamic>> ubicaciones = [];
    
    try{
      var sharedPreferences = await SharedPreferences.getInstance();
      var token = sharedPreferences.getString("token") ?? "";
      var response = await apiService.getData('/rondas/getUbicaciones', token);
      // var response = await apiService.getData('/visitas/getAllBitacoraVisitasCondense', token);

      // Verifica si la respuesta es una lista
      if (response is List) {
        // Asegúrate de que cada elemento de la lista es un Map<String, dynamic>
        // return response["data"].cast<Map<String, dynamic>>();
        ubicaciones = response.cast<Map<String, dynamic>>();
        // ItemPuntos = puntos;
      }

      

    }catch(e){
      // Si no es una lista, lanza una excepción o maneja este caso de manera apropiada
      print(e);
    }finally{
      return ubicaciones;
    }
    // Future<SharedPreferences> prefs =SharedPreferences.getInstance();
  }
  // {
  //   "codigo": "09855504",
  //   "codigo_usuario_crea": "admin",
  //   "codigo_usuario_modifica": "admin",
  //   "descripcion": "Urb. Pacho Salas",
  //   "estado": "A",
  //   "fecha_crea": "06-07-2023",
  //   "fecha_modifica": "06-07-2023",
  //   "hora_crea": "08:31:39",
  //   "hora_modifica": "08:31:39",
  //   "id": 1,
  //   "tipo": "URBANIZACION"
  // },

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
      idUsuarioSupervisor, // es el usuario logeado por que el supervisor crea rondas
      idUbicacion, // se selecciona las ubicaciones 
      descripcion // se escribe
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
    await apiService.postData('/rondas/guardarPuntoRealizado', data,token);
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