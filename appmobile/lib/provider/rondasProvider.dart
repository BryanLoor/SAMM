import 'package:flutter/widgets.dart';
import 'package:sammseguridad_apk/services/ApiService.dart';

class RondasProvider with ChangeNotifier {
  String token = "";

  Future<List<Map<String, dynamic>>> getVisitaList(
      ApiService apiService) async {
    var response = await apiService.getData('/rondas/getAllRondas', token);
    // var response = await apiService.getData('/visitas/getAllBitacoraVisitasCondense', token);

    // Verifica si la respuesta es una lista
    if (response["data"] is List) {
      // Asegúrate de que cada elemento de la lista es un Map<String, dynamic>
      return response["data"].cast<Map<String, dynamic>>();
    }

    // Si no es una lista, lanza una excepción o maneja este caso de manera apropiada
    throw Exception("Invalid data format");
  }

}