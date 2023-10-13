import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sammseguridad_apk/provider/rondasProvider.dart';
import 'package:sammseguridad_apk/services/ApiService.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NuevaRondaFormulario extends StatelessWidget {
  const NuevaRondaFormulario({super.key});

  @override
  Widget build(BuildContext context) {
    
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Center(
              child: Text(
                'Crear nueva ronda',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[900]
                ),
              ),
            
            ),
            Formulario_crea_Ronda(),
          ],
        ),
      ),
    );

  }
}




class Formulario_crea_Ronda extends StatefulWidget {
  @override
  _Formulario_crea_RondaState createState() => _Formulario_crea_RondaState();
}

class _Formulario_crea_RondaState extends State<Formulario_crea_Ronda> {
  int selectedLocation = 1;
  TextEditingController descriptionController = TextEditingController();
  List<Map<String, dynamic>> locations = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (locations.isEmpty) {
      // Realiza la llamada a getRondaUbicaciones solo si la lista está vacía.
      RondasProvider rondasProvider = Provider.of<RondasProvider>(context);
      ApiService apiService = Provider.of<ApiService>(context);

      rondasProvider.getRondaUbicaciones(apiService).then((ubicaciones) {
        setState(() {
          locations = ubicaciones;
        });
      });
    }
  }


  @override
  Widget build(BuildContext context) {
     RondasProvider rondasProvider = Provider.of<RondasProvider>(context);
    ApiService apiService = Provider.of<ApiService>(context);
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: <Widget>[
          TextField(
            controller: descriptionController,
            decoration: InputDecoration(labelText: 'Descripción'),
          ),
          SizedBox(height: 20),
          DropdownButtonFormField(
            value: selectedLocation,
            items: locations.map((location) {
              return DropdownMenuItem(
                value: location['id'], 
                child: Text(location['descripcion']), 
              );
            }).toList(),
            hint: Text('Selecciona una ubicación'),
            onChanged: (value) {
              setState(() {
                selectedLocation = value as int;
              });
            },
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              String description = descriptionController.text;
              if (selectedLocation != null && description.isNotEmpty) {
                print('Descripción: $description');
                print('Ubicación seleccionada: $selectedLocation');

                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) => CircularProgressIndicator(),
                );

                SharedPreferences prefs = await SharedPreferences.getInstance();
                // int userId = prefs.getInt('userId');
                await rondasProvider.enviarNuevaRonda(
                  apiService, 
                  prefs.getInt('Id')??0,
                  selectedLocation, 
                  description, 
                );
                Navigator.pop(context);
                Navigator.pop(context);
                // show snackbar
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Ronda creada correctamente'),
                    backgroundColor: Colors.green,
                  ),
                );
              } else {
                // print('Por favor, completa todos los campos.');
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Por favor, completa todos los campos.'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            child: Text('Enviar'),
          ),
        ],
      ),
    );
  }
}