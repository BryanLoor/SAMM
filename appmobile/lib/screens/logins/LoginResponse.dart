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
    final String identificacion;
    final String telefono;
    final String correo;
    

    LoginResponse({
        required this.apellidos,
        required this.codigo,
        required this.descripcion,
        required this.estado,
        required this.id,
        required this.nombres,
        required this.accessToken,
        required this.identificacion,
        required this.telefono,
        required this.correo,
        
    });

    LoginResponse copyWith({
        String? apellidos,
        String? codigo,
        String? descripcion,
        String? estado,
        int? id,
        String? nombres,
        String? accessToken,
        String? identificacion,
        String? telefono,
        String? correo,
        
    }) => 
        LoginResponse(
            apellidos: apellidos ?? this.apellidos,
            codigo: codigo ?? this.codigo,
            descripcion: descripcion ?? this.descripcion,
            estado: estado ?? this.estado,
            id: id ?? this.id,
            nombres: nombres ?? this.nombres,
            accessToken: accessToken ?? this.accessToken,
            identificacion: identificacion ?? this.identificacion,
            telefono: telefono ?? this.telefono,
            correo: correo ?? this.correo,
            
            
        );

    factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
        apellidos: json["Apellidos"],
        codigo: json["Codigo"],
        descripcion: json["Descripcion"],
        estado: json["Estado"],
        id: json["Id"],
        nombres: json["Nombres"],
        accessToken: json["access_token"],
        identificacion: json["Identificacion"],
        telefono: json["Telefono"],
        correo: json["Correo"],
        
    );

    Map<String, dynamic> toJson() => {
        "Apellidos": apellidos,
        "Codigo": codigo,
        "Descripcion": descripcion,
        "Estado": estado,
        "Id": id,
        "Nombres": nombres,
        "access_token": accessToken,
        "Identificacion": identificacion,
        "Telefono": telefono,
        "Correo": correo,
        
    };
}
