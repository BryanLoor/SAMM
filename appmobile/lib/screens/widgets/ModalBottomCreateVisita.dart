import 'package:flutter/material.dart';
import 'package:sammseguridad_apk/screens/generarVisita/ScreenGenerarVisita.dart';

// class ModalBottomCreateVisita extends StatelessWidget {
//   const ModalBottomCreateVisita({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Container();
//   }
// }


class ModalBottomCreateVisita extends StatefulWidget {
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
  TextEditingController nombreController = TextEditingController();
  TextEditingController apellidoController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Padding(
          padding: EdgeInsets.all(25.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[

              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0), // Ajusta el valor para redondear más o menos
                  color: Colors.white, // Color de fondo opcional
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    controller: cedulaController,
                    decoration: InputDecoration(
                      hintText: 'Cedula *',
                      border: InputBorder.none,
                    ),validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, coloque su Cedula';
                      }
                      return null;
                    },
                  ),
                ),
              ),

              SizedBox(height: 16.0),


              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0), // Ajusta el valor para redondear más o menos
                  color: Colors.white, // Color de fondo opcional
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: TextFormField(
                        controller: nombreController,
                        decoration: InputDecoration(
                          hintText: 'Nombre *',
                          border: InputBorder.none,
                        ),validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, coloque su Nombre';
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: TextFormField(
                        controller: apellidoController,
                        decoration: InputDecoration(
                          hintText: 'Apellido *',
                          border: InputBorder.none,
                        ),validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, coloque su Apellido';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
              ),


              SizedBox(height: 16.0),
              // _buildTextField('Nombre', nombreController),
              // _buildTextField('Apellido', apellidoController),
              
              Container(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blue[900],
                    onPrimary: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  onPressed: () {
                    // Aquí puedes implementar la lógica de invitar al usuario
                    String cedula = cedulaController.text;
                    String nombre = nombreController.text;
                    String apellido = apellidoController.text;
                
                    // Puedes realizar acciones como enviar la invitación
                    // o mostrar un mensaje de confirmación
                    print('Invitar a: $nombre $apellido (Cédula: $cedula)');
                    // Navigator.pop(context);
                    // Navigator.popAndPushNamed(context, routeName)
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ScreenGenerarVisita(),
                      ),
                    );
                  },
                  child: Text(
                    'Invitar',
                    style: TextStyle(fontSize: 18.0),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

