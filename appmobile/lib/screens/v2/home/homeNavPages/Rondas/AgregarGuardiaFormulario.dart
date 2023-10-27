import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sammseguridad_apk/provider/mainprovider.dart';
import 'package:sammseguridad_apk/provider/rondasProvider.dart';
import 'package:sammseguridad_apk/services/ApiService.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AgregarGuardiaFormulario extends StatelessWidget {
  final int idRonda;
  const AgregarGuardiaFormulario({
    required this.idRonda,
    super.key
  });

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
                'Agregar Guardia',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[900]
                ),
              ),
            
            ),
            Formulario_AsignarGuardia(idRonda: idRonda),
          ],
        ),
      ),
    );

  }
}


class Formulario_AsignarGuardia extends StatefulWidget {
  final int idRonda;

  Formulario_AsignarGuardia({
    required this.idRonda,
  });


  @override
  State<Formulario_AsignarGuardia> createState() => _Formulario_AsignarGuardiaState();
}

class _Formulario_AsignarGuardiaState extends State<Formulario_AsignarGuardia> {
  List<Map<String, dynamic>> guardias = [];
  bool isLoading = true;
  bool hasError = false;

  @override
  void initState() {
    super.initState();
    _fetchPuntos();
  }

  Future<void> _fetchPuntos() async {
    final ApiService apiService = Provider.of<ApiService>(context, listen: false);
    // final MainProvider mainProvider = Provider.of<MainProvider>(context, listen: false);
    final RondasProvider rondasProvider = Provider.of<RondasProvider>(context, listen: false);
    int idubicacion = rondasProvider.selectedItem["IdUbicacion"];
    print("*******************************");
    print(idubicacion);
    // sacar el id de la ubicacion
    try {
      final newGuardias = await rondasProvider.getGuardiasValidos(apiService, idubicacion.toString());
      setState(() {
        guardias = newGuardias;
        isLoading = false;
      });
    } catch (e) {
      print('Error al cargar guardias: $e');
      setState(() {
        hasError = true;
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final RondasProvider rondasProvider = Provider.of<RondasProvider>(context, listen: false);
    final ApiService apiService = Provider.of<ApiService>(context, listen: false);
    if (isLoading) {
      return CircularProgressIndicator();
    } else if (hasError) {
      return Text('Error al cargar guardias');
    } else if (guardias.isEmpty) {
      return Text('No hay guardias asignados');
    } else {
      // print(guardias);
      return SingleChildScrollView(
        child: Column(
          children: guardias.map((guardia) {
            return ListTile(
              // title: Text("data"),
              title: Text(guardia['Nombres']??'N/A'),
              // subtitle: Text(guardia['apellidos']??'N/A'),
              leading: Icon(Icons.shield),
              onTap: () async{
                // print(guardia['id']);
                await rondasProvider.enviarAsignarGuardiaARonda(
                  apiService,
                  widget.idRonda,
                  guardia['IdUsuario'],
                  rondasProvider.ItemPuntos
                ).catchError((onError){
                 print(rondasProvider.ItemPuntos);
                  ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          duration: Duration(seconds: 2),
                          content: Text('Ha ocurrido un error, recuerde no asignar al mismo guardia dos veces'),
                          backgroundColor: Colors.red,
                        ),
                      );
                });
                Navigator.pop(context);
              },
            );
          }).toList(),
        ),
      );
    }
  }
}


// class Formulario_AsignarGuardia extends StatefulWidget {
//   final int idRonda;
//   const Formulario_AsignarGuardia({
//     required this.idRonda,
//     super.key
//   });

//   @override
//   _Formulario_AsignarGuardiaState createState() => _Formulario_AsignarGuardiaState();
// }

// class _Formulario_AsignarGuardiaState extends State<Formulario_AsignarGuardia> {
//   int selectedLocation = 1;
//   // TextEditingController descriptionController = TextEditingController();
//   List<Map<String, dynamic>> guardias = [];

//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//     if (guardias.isEmpty) {
//       // Realiza la llamada a getRondaUbicaciones solo si la lista está vacía.
//       RondasProvider rondasProvider = Provider.of<RondasProvider>(context);
//       ApiService apiService = Provider.of<ApiService>(context);

//       rondasProvider.getRondaGuardias(apiService, widget.idRonda.toString()).then((guard) {
//         setState(() {
//           guardias = guard;
//         });
//       });
//     }
//   }


//   @override
//   Widget build(BuildContext context) {
//      RondasProvider rondasProvider = Provider.of<RondasProvider>(context);
//     ApiService apiService = Provider.of<ApiService>(context);
//     // List<Map<String, dynamic>> guardias = rondasProvider.getRondaGuardias(apiService, widget.idRonda.toString());
//     return Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: ListView.builder(
//         shrinkWrap: true,
//         itemCount: guardias.length,
//         itemBuilder: (context, index) {
//           return Card(
//             child: ListTile(
//               title: Text("data"),
//               // title: Text(rondasProvider.usuarios[index]["nombres"]),
//               // subtitle: Text(rondasProvider.usuarios[index]["apellidos"]),
//               onTap: () async {
//                 // await rondasProvider.enviarAsignarGuardiaARonda(
//                 //   apiService,
//                 //   widget.idRonda,
//                 //   rondasProvider.usuarios[index]["id"],
//                 // );
//                 // Navigator.pop(context);
//               },
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
