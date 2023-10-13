// To parse this JSON data, do
//
//     final loginResponse = loginResponseFromJson(jsonString);

// import 'package:meta/meta.dart';
import 'dart:convert';

LoginResponse loginResponseFromJson(String str) => LoginResponse.fromJson(json.decode(str));

String loginResponseToJson(LoginResponse data) => json.encode(data.toJson());

class LoginResponse {
    final String apellidos;
    final String codigo;
    final String descripcion;
    final String estado;
    final int id;
    final String nombres;
    final String accessToken;

    LoginResponse({
        required this.apellidos,
        required this.codigo,
        required this.descripcion,
        required this.estado,
        required this.id,
        required this.nombres,
        required this.accessToken,
    });

    LoginResponse copyWith({
        String? apellidos,
        String? codigo,
        String? descripcion,
        String? estado,
        int? id,
        String? nombres,
        String? accessToken,
    }) => 
        LoginResponse(
            apellidos: apellidos ?? this.apellidos,
            codigo: codigo ?? this.codigo,
            descripcion: descripcion ?? this.descripcion,
            estado: estado ?? this.estado,
            id: id ?? this.id,
            nombres: nombres ?? this.nombres,
            accessToken: accessToken ?? this.accessToken,
        );

    factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
        apellidos: json["Apellidos"],
        codigo: json["Codigo"],
        descripcion: json["Descripcion"],
        estado: json["Estado"],
        id: json["Id"],
        nombres: json["Nombres"],
        accessToken: json["access_token"],
    );

    Map<String, dynamic> toJson() => {
        "Apellidos": apellidos,
        "Codigo": codigo,
        "Descripcion": descripcion,
        "Estado": estado,
        "Id": id,
        "Nombres": nombres,
        "access_token": accessToken,
    };
}
