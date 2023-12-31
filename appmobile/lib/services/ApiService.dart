import 'dart:developer';

import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:http/http.dart';

class ApiService {
  //final String _baseUrl = 'http://10.0.2.2:5000'; //local
  //final String _baseUrl = 'http://192.168.100.5:5000'; //local
  //final String _baseUrl = 'http://198.38.89.240:6051'; //produccionGrowthly
  final String _baseUrl = 'https://l43fwjf1-5000.use2.devtunnels.ms'; //produccionGrowthly

  //ip para tlf http://10.0.2.2:5000

  String getServiceUrl(String serviceUrl) {
    return "$_baseUrl/$serviceUrl";
  }

  Future<String> getAccessToken(String username, String password) async {
    final url = Uri.parse('${_baseUrl}generate_token');
    final headers = {
      'Content-Type': 'application/json',
    };
    final body = jsonEncode({
      'username': username,
      'password': password,
    });
    final response = await http.post(url, headers: headers, body: body);
    if (response.statusCode == 200) {
      return jsonDecode(response.body)['access_token'];
    } else {
      throw Exception('Could not get token');
    }
  }

  Future<dynamic> getData(String endpoint, String jwtToken) async {
    try {
      var url = Uri.parse(_baseUrl + endpoint);
      http.Response response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $jwtToken",
        },
      );

      if (response.statusCode == 200) {
        // log(response.body.toString());+
        return jsonDecode(response.body);
      } else {
        throw Exception('Fallo al cargar datos: ${response.statusCode}');
      }
    } on ClientException catch (e) {
      // Manejar el error de conexión cerrada inesperadamente
      print('Error de conexión: $e');
      throw Exception('Error de conexión: $e');
      return {};
      // throw Exception('Fallo de conexión: $e');
    } catch (e) {
      // Manejar otros errores
      print('Error desconocido: $e');
      // lanzar sbackbar

      throw Exception('Error desconocido: $e');
    }
  }

  Future<String> getDataJson(String endpoint, String jwtToken) async {
    var url = Uri.parse(_baseUrl + endpoint);
    http.Response response = await http.get(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $jwtToken",
      },
    );

    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Fallo al cargar datos');
    }
  }

  Future<Map<String, dynamic>> postData(
      String endpoint, Map<String, dynamic> data, String jwtToken) async {
    var url = Uri.parse(_baseUrl + endpoint);
    // print("url: $url");
    var headers = {
      "Content-Type": "application/json",
    };
    if (jwtToken.isNotEmpty) {
      headers["Authorization"] = "Bearer $jwtToken";
    }
    // print("headers: $headers");

    //colocar try catch
    try {
      http.Response response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(data),
      );
      // print(response.body.toString());
      if (response.statusCode == 200 ||
          response.statusCode == 201 ||
          response.statusCode == 400) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Fallo al enviar datos');
      }
    } catch (e) {
      print(e);
      throw Exception('Fallo al hacer post');
    }
  }

  Future<List<dynamic>> postDataReturnList(
      String endpoint, Map<String, dynamic> data, String jwtToken) async {
    var url = Uri.parse(_baseUrl + endpoint);
    var headers = {
      "Content-Type": "application/json",
    };

    if (jwtToken.isNotEmpty) {
      headers["Authorization"] = "Bearer $jwtToken";
    }
    http.Response response = await http.post(
      url,
      headers: headers,
      body: jsonEncode(data),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to post data: Error de parámetros');
    }
  }

  Future<void> putData(
      String endpoint, Map<String, dynamic> data, String jwtToken) async {
    var url = Uri.parse(_baseUrl + endpoint);
    http.Response response = await http.put(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $jwtToken",
      },
      body: jsonEncode(data),
    );

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Fallo al actualizar datos');
    }
  }

  Future<void> deleteData(String endpoint, String jwtToken) async {
    var url = Uri.parse(_baseUrl + endpoint);
    http.Response response = await http.delete(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $jwtToken",
      },
    );

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Fallo al eliminar datos');
    }
  }
}
