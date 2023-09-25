import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sammseguridad_apk/provider/mainprovider.dart';
import 'package:sammseguridad_apk/provider/visitasProvider.dart';
import 'package:sammseguridad_apk/screens/v2/generarVisita/ScreenGenerarVisita.dart';
import 'package:sammseguridad_apk/screens/widgets/ModalBottomCreateVisita.dart';
import 'package:sammseguridad_apk/services/ApiService.dart';
import 'package:sammseguridad_apk/widgets/Appbar.dart';
import 'package:sammseguridad_apk/widgets/Drawer.dart';
import 'package:sammseguridad_apk/widgets/TwoColumnsWidget.dart';

class VisitasPage extends StatefulWidget {
  const VisitasPage({Key? key}) : super(key: key);

  @override
  State<VisitasPage> createState() => _VisitasPage();
}



class _VisitasPage extends State<VisitasPage>
  with AutomaticKeepAliveClientMixin<VisitasPage> { // Agrega AutomaticKeepAliveClientMixin

  @override
  bool get wantKeepAlive => true; // Anula wantKeepAlive y devuelve true

  _VisitasPage() {
  print("VisitasPage constructor called");
}
  // late Future<List<Map<String, dynamic>>> _visitaListFuture;
  TabMenu tabMenuView = TabMenu.Personas;
  // bool _hasFetchedData = false; // Variable para controlar si los datos ya se han obtenido

  @override
  void initState() {
    super.initState();

    // if (!_hasFetchedData) {
    //   refreshvisitas(Provider.of<VisitasProvider>(context, listen: false));
    // }
  }

  // Future<List<Map<String, dynamic>>> refreshvisitas(visitasProvider){
  //   final mainProviderSave =
  //         Provider.of<MainProvider>(context, listen: false);
  //   final apiService = Provider.of<ApiService>(context, listen: false);
  //   // final visitasProvider = Provider.of<VisitasProvider>(context);

  //   visitasProvider.visitaListFuture =
  //       mainProviderSave.getPreferencesToken().then((dataToken) {
  //     token = dataToken.toString();
  //     mainProviderSave.updateToken(token);

  //     return getVisitaList(apiService);
  //   }).whenComplete(() {
  //     // Marca que los datos han sido obtenidos
  //     setState(() {
  //       _hasFetchedData = true;
  //     });
  //   });
  //   return visitasProvider.visitaListFuture;
  // }

  // Future<List<Map<String, dynamic>>> getVisitaList(
  //     ApiService apiService) async {
  //   var response = await apiService.getData('/visitas/getAllBitacoraVisitas', token);
  //   // var response = await apiService.getData('/visitas/getAllBitacoraVisitasCondense', token);

  //   // Verifica si la respuesta es una lista
  //   if (response["data"] is List) {
  //     // Asegúrate de que cada elemento de la lista es un Map<String, dynamic>
  //     return response["data"].cast<Map<String, dynamic>>();
  //   }

  //   // Si no es una lista, lanza una excepción o maneja este caso de manera apropiada
  //   throw Exception("Invalid data format");
  // }



  List<Map<String, dynamic>> removeDuplicateVisits(
    List<Map<String, dynamic>> visits)  {
    final uniqueIdentifications = <String>{};
    final uniqueVisits = <Map<String, dynamic>>[];

    for (final visit in visits) {
      final identificationVisitante = visit["IdentificacionVisitante"]??'';

      if (!uniqueIdentifications.contains(identificationVisitante)) {
        uniqueIdentifications.add(identificationVisitante);
        uniqueVisits.add(visit);
      }
    }

    return uniqueVisits;
  }


  Widget _buildTable(List<Map<String, dynamic>> visitas) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: visitas.length,
        itemBuilder: (BuildContext context, int index) {
          final visita = visitas[index];
    
          return Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: ListTile(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              tileColor: Colors.blue[50],
              leading: (tabMenuView == TabMenu.Historial)?Icon(Icons.no_crash_outlined):Icon(Icons.person),
              // title: Text(visita['Codigo']?.toString() ?? 'N/A'),
              title: Text('${visita['ApellidosVisitante']?.toString() ?? 'N/A'} ${visita['NombresVisitante']?.toString() ?? 'N/A'}'),
              subtitle: 
                (tabMenuView == TabMenu.Historial)?
                TwoColumnsWidget(listaDeWidgets: [
                  // Text('Apellido: ${visita['ApellidosVisitante']?.toString() ?? 'N/A'}'),
                      Text('ID: ${visita['IdentificacionVisitante']?.toString() ?? 'N/A'}'),
                      Text('Duracion: ${visita['Duracion']?.toString() ?? 'N/A'}'),
                      // Text('Estado: ${visita['Estado']?.toString() ?? 'N/A'}'),
                      // Text('FechaCrea: ${visita['FechaCrea']?.toString() ?? 'N/A'}'),
                      Text('FechaVisita: ${visita['FechaVisita']?.toString() ?? 'N/A'}'),
                      Text('Hora: ${visita['Hora']?.toString() ?? 'N/A'}'),
                      Text('Placa: ${visita['Placa']?.toString() ?? 'N/A'}'),
                ])
                :
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                      // Text('Apellido: ${visita['ApellidosVisitante']?.toString() ?? 'N/A'}'),
                      Text('ID: ${visita['IdentificacionVisitante']?.toString() ?? 'N/A'}'),
                      
                    ],
                ),
              trailing: PopupMenuButton(
                onSelected: (value) {
                  // Navigator.of(context).push(
                  //   MaterialPageRoute(
                  //     builder: (context) => ScreenGenerarVisita(
                  //       cedula: visita['IdentificacionVisitante'],
                  //       nombre: '${visita['NombresVisitante']} ${visita['ApellidosVisitante']}',
                  //     ),
                  //   ),
                  // );
                  // showModalBottomSheet(
                  //   context: context,
                  //   builder: (context) => ModalBottomCreateVisita(
                  //     cedula: visita['IdentificacionVisitante'],
                  //     nombre: '${visita['NombresVisitante']} ${visita['ApellidosVisitante']}',
                  //   ),
                  // );
                  showModalBottomSheet(
                    isScrollControlled: true,
                    context: context,
                    builder: (BuildContext context) {
                      return FractionallySizedBox(
                        heightFactor: 0.75, // Ajusta este valor según tus necesidades.
                        child: ModalBottomCreateVisita(
                          cedula: visita['IdentificacionVisitante'],
                          nombre: '${visita['NombresVisitante']} ${visita['ApellidosVisitante']}',
                        )
                      );
                    },
                    // builder: (context) => ModalBottomCreateVisita(
                    //   cedula: '',
                    //   nombre: '',
                    // ),
                  );
                  // ScreenGenerarVisita()
                  // print(value);
        
                  // showModalBottomSheet(
                  //   context: context,
                  //   builder: (context) => ModalBottomCreateVisita(),
                  // );
                },
                icon: Icon(Icons.add),
                itemBuilder: (BuildContext context) {
                  return [
                    PopupMenuItem(
                      value: "Crear invitacion",
                      child: Text('Crear invitacion'),
                    ),
                  ];
                },
        
              ),
                
                
            ),
          );
        },
      ),
    );

  }

  @override
  Widget build(BuildContext context) {
    final visitasProvider = Provider.of<VisitasProvider>(context);
    // if (!_hasFetchedData) {
      // visitasProvider.refreshvisitas(context,visitasProvider);
    // }
    // TabMenu tabMenuView = TabMenu.Personas;
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
          ),
          width: double.infinity,
          child: Center(
            child: SegmentedButton<TabMenu>(
              segments: const <ButtonSegment<TabMenu>>[
                ButtonSegment<TabMenu>(
                  value: TabMenu.Historial,
                  label: Text('Historial'),
                  icon: Icon(Icons.history)
                ),
                ButtonSegment<TabMenu>(
                  value: TabMenu.Personas,
                  label: Text('Personas'),
                  icon: Icon(Icons.person)
                ),
              ],
              selected: <TabMenu>{tabMenuView},
              selectedIcon: Icon(Icons.shield),
              onSelectionChanged: (Set<TabMenu> newSelection) {
                setState(() {
                  // By default there is only a single segment that can be
                  // selected at one time, so its value is always the first
                  // item in the selected set.
                  tabMenuView = newSelection.first;
                });
                
              },
            ),
          )
        ),
        // SizedBox(height: 20.0),
        Expanded(
          child: FutureBuilder<List<Map<String, dynamic>>>(
            future: visitasProvider.visitaListFuture,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                if (tabMenuView == TabMenu.Historial) {
                  return _buildTable(snapshot.data);
                } else if (tabMenuView == TabMenu.Personas) {
                  return _buildTable( removeDuplicateVisits(snapshot.data));
                }

                return _buildTable( removeDuplicateVisits(snapshot.data));
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                return Center(child: CircularProgressIndicator());
              }
            },
          ),
        ),
      ],
    );
  }
}

enum TabMenu { Historial, Personas}