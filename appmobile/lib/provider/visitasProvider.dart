import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:sammseguridad_apk/provider/mainprovider.dart';
import 'package:sammseguridad_apk/services/ApiService.dart';

class VisitasProvider with ChangeNotifier {
  late Future<List<Map<String, dynamic>>> _visitaListFuture = Future.value([]);
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
    
    visitasProvider.visitaListFuture =
        mainProviderSave.getPreferencesToken().then((dataToken) {
      token = dataToken.toString();
            mainProviderSave.updateToken(token);

      return getVisitaList(apiService);
    });
    return visitasProvider.visitaListFuture;
  }

  Future<List<Map<String, dynamic>>> getVisitaList(
      ApiService apiService
  ) async {
    List<Map<String, dynamic>> res = [];
    try{
      var response = await apiService.getData('/visitas/getAllBitacoraVisitas', token);
      if (response["data"] is List) {
        res =  response["data"].cast<Map<String, dynamic>>();
       
        
      }
       print(res);
        print("object");


    }catch(e){
      print(e);
    }finally{
      return res;
    }
  }



}