import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sammseguridad_apk/provider/rondasProvider.dart';
import 'package:sammseguridad_apk/services/ApiService.dart';

class GuardiasView extends StatefulWidget {
  final int idRonda;

  GuardiasView({
    required this.idRonda,
  });


  @override
  State<GuardiasView> createState() => _GuardiasViewState();
}

class _GuardiasViewState extends State<GuardiasView> {
  List<Map<String, dynamic>> guardias = [];
  bool isLoading = true;
  bool hasError = false;

  @override
  void initState() {
    super.initState();
    _fetchPuntos();
  }

  Future<void> _fetchPuntos() async {
    final RondasProvider rondasProvider = Provider.of<RondasProvider>(context, listen: false);
    final ApiService apiService = Provider.of<ApiService>(context, listen: false);

    try {
      final newGuardias = await rondasProvider.getRondaGuardias(apiService, widget.idRonda.toString());
      setState(() {
        guardias = newGuardias;
        isLoading = false;
      });
    } catch (e) {
      print('Error al cargar puntos: $e');
      setState(() {
        hasError = true;
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return CircularProgressIndicator();
    } else if (hasError) {
      return Text('Error al cargar puntos');
    } else if (guardias.isEmpty) {
      return Text('No hay guardias asignados');
    } else {
      return SingleChildScrollView(
        child: Column(
          children: guardias.map((guardia) {
            return ListTile(
              title: Text(guardia['Apellidos'].toString() + " " + guardia['Nombres'].toString()),
              // title: Text(guardia['Descripcion'].toString()),
              // subtitle: Text(guardia['Coordenada']),
              leading: Icon(Icons.shield),
              // Otros elementos de ListTile según tus datos
            );
          }).toList(),
        ),
      );
    }
  }
}


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