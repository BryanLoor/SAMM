import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:sammseguridad_apk/provider/mainprovider.dart';
import 'package:sammseguridad_apk/services/ApiService.dart';

class VisitasProvider with ChangeNotifier {
  late Future<List<Map<String, dynamic>>> _visitaListFuture;
  bool _hasFetchedData = false;
  bool get hasFetchedData => _hasFetchedData;
  set hasFetchedData(bool newHasFetchedData) {
    _hasFetchedData = newHasFetchedData;
    // notifyListeners();
  }
  String token = "";

  Future<List<Map<String, dynamic>>> get visitaListFuture =>
      _visitaListFuture;
    
  set visitaListFuture(Future<List<Map<String, dynamic>>> newVisitaListFuture) {
    _visitaListFuture = newVisitaListFuture;
    // notifyListeners();
  }

    Future<List<Map<String, dynamic>>> refreshvisitas(context,visitasProvider){
    final mainProviderSave =
          Provider.of<MainProvider>(context, listen: false);
    final apiService = Provider.of<ApiService>(context, listen: false);
    // final visitasProvider = Provider.of<VisitasProvider>(context);

    visitasProvider.visitaListFuture =
        mainProviderSave.getPreferencesToken().then((dataToken) {
      token = dataToken.toString();
      mainProviderSave.updateToken(token);

      return getVisitaList(apiService);
    });
    // .whenComplete(() {
    //   // Marca que los datos han sido obtenidos
    //   setState(() {
    //     _hasFetchedData = true;
    //   });
    // });
    return visitasProvider.visitaListFuture;
  }

  Future<List<Map<String, dynamic>>> getVisitaList(
      ApiService apiService) async {
    var response = await apiService.getData('/visitas/getAllBitacoraVisitas', token);
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