import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sammseguridad_apk/provider/visitasProvider.dart';
import 'package:sammseguridad_apk/screens/v2/home/floatings/FloatingVisitas.dart';
import 'package:sammseguridad_apk/screens/widgets/ModalBottomCreateVisita.dart';
import 'package:sammseguridad_apk/services/ApiService.dart';
// import 'package:sammseguridad_apk/widgets/Drawer.dart';
import 'package:sammseguridad_apk/widgets/TwoColumnsWidget.dart';

class VisitasPage extends StatefulWidget {
  const VisitasPage({Key? key}) : super(key: key);

  @override
  State<VisitasPage> createState() => _VisitasPage();
}

class _VisitasPage extends State<VisitasPage>
    with AutomaticKeepAliveClientMixin<VisitasPage> {
  // Agrega AutomaticKeepAliveClientMixin

  @override
  bool get wantKeepAlive => true; // Anula wantKeepAlive y devuelve true

  _VisitasPage() {
    // print("VisitasPage constructor called");
  }
  TabMenu tabMenuView = TabMenu.Personas;

  @override
  void initState() {
    super.initState();
    print("estoy en visitas page");

    
  }

  List<Map<String, dynamic>> removeDuplicateVisits(
      List<Map<String, dynamic>> visits) {
    final uniqueIdentifications = <String>{};
    final uniqueVisits = <Map<String, dynamic>>[];

    for (final visit in visits) {
      final identificationVisitante = visit["IdentificacionVisitante"] ?? '';

      if (!uniqueIdentifications.contains(identificationVisitante)) {
        uniqueIdentifications.add(identificationVisitante);
        uniqueVisits.add(visit);
      }
    }

    return uniqueVisits;
  }

  Widget _buildTable(List<Map<String, dynamic>> visitas, bool trailing) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: visitas.length,
        itemBuilder: (BuildContext context, int index) {
          final reversedIndex = visitas!.length - 1 - index;
          final visita = visitas[reversedIndex];
          DateFormat inputFormat = DateFormat("E, dd MMM yyyy HH:mm:ss 'GMT'");

          String fechaVisitaFormateada = DateFormat('yyyy-MM-dd').format(inputFormat.parse(visita['FechaTimeVisitaEstimada']));
          String fechaSalidaFormateada = DateFormat('yyyy-MM-dd').format(inputFormat.parse(visita['FechaTimeSalidaEstimada']));
          DateTime fechaVisita = inputFormat.parse(visita['FechaTimeVisitaEstimada']);
          DateTime fechaSalida = inputFormat.parse(visita['FechaTimeSalidaEstimada']);

          Duration duracionVisita = fechaSalida.difference(fechaVisita);
          //Duration duracionVisita = fechaSalidaFormateada.difference(fechaVisitaFormateada);
          // print("La duración de la visita es: ${duracionVisita.inDays} días, ${duracionVisita.inHours % 24} horas y ${duracionVisita.inMinutes % 60} minutos.");

          return Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: ListTile(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              tileColor: Colors.blue[50],
              leading: (tabMenuView == TabMenu.Historial)
                  ? const Icon(Icons.no_crash_outlined)
                  : const Icon(Icons.person),
              // title: Text(visita['Codigo']?.toString() ?? 'N/A'),
              title: Text(
                  '${visita['ApellidosVisitante']?.toString() ?? 'N/A'} ${visita['NombresVisitante']?.toString() ?? 'N/A'}'),
              subtitle: (tabMenuView == TabMenu.Historial)
                  ? TwoColumnsWidget(listaDeWidgets: [
                      // Text('Apellido: ${visita['ApellidosVisitante']?.toString() ?? 'N/A'}'),
                      Text(
                          'ID: ${visita['IdentificacionVisitante']?.toString() ?? 'N/A'}'),
                      //Text('Duracion: ${visita['Duracion']?.toString() ?? 'N/A'}'),
                      
                      // Text('Estado: ${visita['Estado']?.toString() ?? 'N/A'}'),
                      // Text('FechaCrea: ${visita['FechaCrea']?.toString() ?? 'N/A'}'),
                      //Text(                          'FechaVisita: ${fechaVisitaFormateada.toString()??"N/A"}'),
                      Text('Placa: ${visita['Placa']?.toString() ?? 'N/A'}'),

                      //Text(                          'FechaSalida: ${fechaSalidaFormateada.toString()??"N/A"}'),
                     
                      //Text('Hora: ${visita['Hora']?.toString() ?? 'N/A'}'),
                      Text('Ubicacion:${visita["Ubicacion"]?.toString() ?? 'N/A'}'),
                      //Text('Duracion: ${duracionVisita.inDays} días, ${duracionVisita.inHours % 24} horas y ${duracionVisita.inMinutes % 60} minutos.'),

                    ])
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Text('Apellido: ${visita['ApellidosVisitante']?.toString() ?? 'N/A'}'),
                        Text(
                            'ID: ${visita['IdentificacionVisitante']?.toString() ?? 'N/A'}'),
                      ],
                    ),
              trailing: trailing
                  ? PopupMenuButton(
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
                                heightFactor:
                                    0.75, // Ajusta este valor según tus necesidades.
                                child: ModalBottomCreateVisita(
                                  cedula: visita['IdentificacionVisitante'],
                                  nombre: visita['NombresVisitante'],
                                  apellido: visita['ApellidosVisitante'],
                                ));
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
                      icon: const Icon(Icons.restore_outlined),
                      itemBuilder: (BuildContext context) {
                        return [
                          const PopupMenuItem(
                            value: "Reenviar invitacion",
                            child: Text('Reenviar invitacion'),
                          ),
                        ];
                      },
                    )
                  : const SizedBox(),
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
    Future<void> _refreshData() async {
    // Simula la carga de nuevos datos o una operación de actualización
    await Future.delayed(Duration(seconds: 1));

    setState(() {
      // Agrega nuevos elementos o actualiza la lista
      //visitasProvider.visitaListFuture= visitasProvider.getVisitaList(ApiService());
    });
  }
    return Column(
      children: [
        Container(
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
            width: double.infinity,
            child: Center(
              child: SegmentedButton<TabMenu>(
                style: ButtonStyle(
                  //backgroundColor: MaterialStateProperty.all(Colors.amber),
                  foregroundColor: MaterialStateProperty.resolveWith<Color>(
                    (Set<MaterialState> states) {
                      if (states.contains(MaterialState.selected)) {
                        return Colors.white; // Text color when selected
                      }
                      return Colors.black; // Text color when unselected
                    },
                  ),
                  backgroundColor: MaterialStateProperty.resolveWith<Color>(
                    (Set<MaterialState> states) {
                      if (states.contains(MaterialState.selected)) {
                        return const Color.fromRGBO(
                            13, 71, 161, 1); // Background color when selected
                      }
                      return Colors
                          .transparent; // Background color when unselected
                    },
                  ),
                ),
                segments: const <ButtonSegment<TabMenu>>[
                  ButtonSegment<TabMenu>(
                      value: TabMenu.Historial,
                      label: Text('Historial'),
                      icon: Icon(Icons.history)),
                  ButtonSegment<TabMenu>(
                      value: TabMenu.Personas,
                      label: Text('Frecuentes'),
                      icon: Icon(Icons.person)),
                ],
                selected: <TabMenu>{tabMenuView},
                selectedIcon: const Icon(Icons.shield),
                onSelectionChanged: (Set<TabMenu> newSelection) {
                  setState(() {
                    // By default there is only a single segment that can be
                    // selected at one time, so its value is always the first
                    // item in the selected set.
                    tabMenuView = newSelection.first;
                  });
                },
              ),
            )),
        // SizedBox(height: 20.0),
        Expanded(
          child: RefreshIndicator(
            onRefresh: _refreshData,
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: visitasProvider.visitaListFuture,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  if (tabMenuView == TabMenu.Historial) {
                    return _buildTable(snapshot.data, false);
                  } else if (tabMenuView == TabMenu.Personas) {
                    return _buildTable(
                        removeDuplicateVisits(snapshot.data), true);
                  }
        
                  return _buildTable(removeDuplicateVisits(snapshot.data), true);
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.all(20),
          alignment: Alignment.centerRight,
          child: FloatingVisitas())
      ],
    );
    
  }
  
}



enum TabMenu { Historial, Personas }
