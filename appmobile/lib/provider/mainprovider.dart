
import 'package:flutter/material.dart';
import 'package:sammseguridad_apk/screens/logins/LoginResponse.dart';
import 'package:sammseguridad_apk/services/ApiService.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainProvider extends ChangeNotifier {
  static late SharedPreferences prefs;
  String _token = "";

  Map<String, dynamic> _userinfo = {};

  Map<String, dynamic> get userinfo => _userinfo;

  set userinfo(Map<String, dynamic> newuserinfo) {
    _userinfo = newuserinfo;
    notifyListeners();
  }

  String get token => _token;

  bool get isAuth => _token.isNotEmpty;


  Map<String,dynamic> _response = {};

  Map<String,dynamic> get response => _response;

  set response(Map<String,dynamic> newResponse) {
    _response = newResponse;
    // save_response(_response.toString());
    notifyListeners();
  }

  set token(String newToken) {
    _token = newToken;
    updateToken(_token);
    notifyListeners();
  }

  // Future<void> save_response(String response) async{
  //   // prefs = await SharedPreferences.getInstance();
  //   // await prefs.setString("response", response);

  // }
  Future<void> updateUserInfo(LoginResponse loginResponse) async {
    // print(userinfo.toString());
    prefs = await SharedPreferences.getInstance();
    await prefs.setString("Apellidos", loginResponse.apellidos);
    await prefs.setString("Codigo", loginResponse.codigo);
    await prefs.setString("Descripcion", loginResponse.descripcion);
    await prefs.setString("Estado", loginResponse.estado);
    await prefs.setInt("Id", loginResponse.id);
    await prefs.setString("Nombres", loginResponse.nombres);
    await prefs.setString("access_token", loginResponse.accessToken);

  }

  Future<bool> canedit()async{
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final descripcion = prefs.getString("Descripcion");

    return (descripcion == "Administrador" || descripcion == "Supervisor");


  }

  Future<LoginResponse> getUserInfo() async {
    prefs = await SharedPreferences.getInstance();
    final apellidos = prefs.getString("Apellidos");
    final codigo = prefs.getString("Codigo");
    final descripcion = prefs.getString("Descripcion");
    final estado = prefs.getString("Estado");
    final id = prefs.getInt("Id");
    final nombres = prefs.getString("Nombres");
    final accessToken = prefs.getString("access_token");
    // print(userInfoString);
    if (accessToken != null) {
      final usInfo = LoginResponse(
        apellidos: apellidos ?? "",
        codigo: codigo ?? "",
        descripcion: descripcion ?? "",
        estado: estado ?? "",
        id: id ?? 0,
        nombres: nombres ?? "",
        accessToken: accessToken ?? "",
      );
      return usInfo;
      // return <String, dynamic>{};
    } else {
      // Manejo de caso en el que no se encuentra la información del usuario en las preferencias
      return LoginResponse(
        apellidos: "",
        codigo: "",
        descripcion: "",
        estado: "",
        id: 0,
        nombres: "",
        accessToken: "",
      );
    }
  }


  Future<void> updateToken(String token) async {
    prefs = await SharedPreferences.getInstance();
    await prefs.setString("token", token);
  }


  Future<String> getPreferencesToken() async {
    try {
      prefs = await SharedPreferences.getInstance();
      _token = prefs.getString("token") ?? "";
      return _token;
    } catch (e) {
      return "";
    }
  }




// {
//     "apellidos": "Choez Velez",
//     "codigo": "admin",
//     "codigo_usuario_crea": "admin",
//     "codigo_usuario_modifica": "admin",
//     "estado": "A",
//     "fechaCrea:": "28-06-2023",
//     "fechaModifica:": "16-08-2023",
//     "horaCrea": "21:07:59",
//     "horaModifica": "11:56:53",
//     "id": 1,
//     "nombres": "Richard Michael"
//   },
  Future<List<Map<String, dynamic>>> getUsuarios(
      ApiService apiService
  ) async {
    List<Map<String, dynamic>> usuarios = [];

    try{
      // Future<SharedPreferences> prefs =SharedPreferences.getInstance();
      var sharedPreferences = await SharedPreferences.getInstance();
      var token = sharedPreferences.getString("token") ?? "";
      var response = await apiService.getData('/rutas/usuarios', token);
      usuarios = response.cast<Map<String, dynamic>>();

    }catch(e){
      // Si no es una lista, lanza una excepción o maneja este caso de manera apropiada
      // print(e);
    }finally{
      return usuarios;
    }

  }

  Future<List<Map<String, dynamic>>> getMenu(
      ApiService apiService
  ) async {
    List<Map<String, dynamic>> opciones = [];

    try{
      var sharedPreferences = await SharedPreferences.getInstance();
      var token = sharedPreferences.getString("token") ?? "";
      var response = await apiService.getData('/menu/getMenu/MOBILE', token);
      opciones = response.cast<Map<String, dynamic>>();

    }catch(e){
      // Si no es una lista, lanza una excepción o maneja este caso de manera apropiada
      // print(e);
    }finally{
      return opciones;
    }

  }

  // usuariosxrol



  Future<void> logout() async {
    _token = "";
    await prefs.setString("token", "");
    notifyListeners();
  }

  Future<void> init() async {
    _token = await getPreferencesToken();
    notifyListeners();
  }
}



// {
//   "Apellidos": "Choez Velez",
//   "Codigo": "admin",
//   "Descripcion": "Administrador",
//   "Estado": "A",
//   "Id": 1,
//   "Nombres": "Richard Michael",
//   "access_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJmcmVzaCI6ZmFsc2UsImlhdCI6MTY5NzA2MTk4MCwianRpIjoiYmM4N2VmMGUtNzdhMS00ZjUzLWJmNDYtNDQ4ZjAzNzQyYTJhIiwidHlwZSI6ImFjY2VzcyIsInN1YiI6ImFkbWluIiwibmJmIjoxNjk3MDYxOTgwLCJleHAiOjE2OTcwOTc5ODB9.PzC9NKMTq7qmKv53gVToNRx4rmt3QwkecEYytcEJjxU"
// }
