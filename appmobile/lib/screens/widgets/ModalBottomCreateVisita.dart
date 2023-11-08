import 'package:flutter/material.dart';
import 'package:sammseguridad_apk/screens/v2/generarVisita/ScreenGenerarVisita.dart';


class ModalBottomCreateVisita extends StatefulWidget {
  String cedula;
  String nombre;
  String apellido;
  String idVisitante;
  
  ModalBottomCreateVisita({
    required this.cedula, 
    required this.nombre,
    required this.apellido,
    required this.idVisitante

  });
  
  @override
  _ModalBottomCreateVisita createState() => _ModalBottomCreateVisita();
}

class _ModalBottomCreateVisita extends State<ModalBottomCreateVisita> {
  static const _fontSize = 20.0;
  static const _paddingSize = 15.0;
  static const _buttonFontSize = 18.0;
  static const _sizedBoxHeight = 10.0;


  TextStyle estiloAzul = TextStyle(
    fontSize: 20, 
    fontWeight: FontWeight.bold,
    color: Colors.blue[900]
  );

  bool _obscureText = true;

  TextEditingController cedulaController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ScreenGenerarVisita(
            widgetCedula: widget.cedula,
            widgetNombre: widget.nombre,
            widgetApellido: widget.apellido,
            widgetIdVisitante:widget.idVisitante
          );
    // return SingleChildScrollView(
    //   child: Padding(
    //     padding: EdgeInsets.only(
    //                     bottom: MediaQuery.of(context).viewInsets.bottom),
    //     child: Padding(
    //       padding: EdgeInsets.all(25.0),
    //       child: Column(
    //         crossAxisAlignment: CrossAxisAlignment.start,
    //         children: <Widget>[
    //           Center(
    //             child: Icon(Icons.shield),
    //           ),

              // Center(
              //   child: Text(
              //     'Invitar a un visitante',
              //     style: estiloAzul,
              //   ),
              // ),
              // SizedBox(height: 16.0),

              // Container(
              //   decoration: BoxDecoration(
              //     borderRadius: BorderRadius.circular(10.0), // Ajusta el valor para redondear más o menos
              //     color: Colors.white, // Color de fondo opcional
              //   ),
              //   child: Padding(
              //     padding: const EdgeInsets.only(left: 8.0),
              //     child: TextFormField(
              //       keyboardType: TextInputType.number,
              //       controller: cedulaController,
              //       decoration: InputDecoration(
              //         hintText: 'Cedula *',
              //         border: InputBorder.none,
              //       ),validator: (value) {
              //         if (value == null || value.isEmpty) {
              //           return 'Por favor, coloque su Cedula';
              //         }
              //         return null;
              //       },
              //     ),
              //   ),
              // ),

              // SizedBox(height: 16.0),


              
              // // _buildTextField('Nombre', nombreController),
              // // _buildTextField('Apellido', apellidoController),
              
              // Container(
              //   width: double.infinity,
              //   child: ElevatedButton(
              //     style: ElevatedButton.styleFrom(
              //       primary: Colors.blue[900],
              //       onPrimary: Colors.white,
              //       shape: RoundedRectangleBorder(
              //         borderRadius: BorderRadius.circular(8.0),
              //       ),
              //     ),
              //     onPressed: () {
              //       String cedula = cedulaController.text;

              //       // Validar la cédula
              //       if (cedula.length != 10 || !RegExp(r'^[0-9]+$').hasMatch(cedula)) {
              //         // Si la cédula no tiene 10 dígitos o no son todos números, muestra un mensaje de error
              //         showDialog(
              //           context: context,
              //           builder: (context) {
              //             return AlertDialog(
              //               title: Text('Error de Cédula'),
              //               content: Text('La cédula debe tener 10 dígitos y contener solo números.'),
              //               actions: <Widget>[
              //                 TextButton(
              //                   onPressed: () {
              //                     Navigator.of(context).pop();
              //                   },
              //                   child: Text('OK'),
              //                 ),
              //               ],
              //             );
              //           },
              //         );
              //       } else {
              //         // Si la cédula es válida, puedes realizar la acción de invitar al usuario
              //         // print('Invitar a: $nombre $apellido (Cédula: $cedula)');
              //         // close the modal
              //         Navigator.of(context).pop();
              //         Navigator.of(context).push(
              //           MaterialPageRoute(
              //             builder: (context) => ScreenGenerarVisita(
              //               cedula: cedula,
              //               nombre: "",
              //             ),
              //           ),
              //         );
              //       }
              //     },

              //     child: Text(
              //       'verificar',
              //       style: TextStyle(fontSize: 18.0),
              //     ),
              //   ),
    //           ),
    //           // SizedBox(height: 160.0),
            
    //         ],
    //       ),
    //     ),
    //   ),
    // );
  }
}

