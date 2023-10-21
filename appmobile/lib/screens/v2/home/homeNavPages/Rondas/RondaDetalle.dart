import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:sammseguridad_apk/provider/mainprovider.dart';
import 'package:sammseguridad_apk/provider/rondasProvider.dart';
import 'package:sammseguridad_apk/screens/v2/generarVisita/maps/mapsview.dart';
import 'package:sammseguridad_apk/screens/v2/generarVisita/maps/mapviewController.dart';
import 'package:sammseguridad_apk/screens/v2/home/homeNavPages/Rondas/AgregarGuardiaFormulario.dart';
import 'package:sammseguridad_apk/services/ApiService.dart';
import 'package:sammseguridad_apk/widgets/Appbar.dart';

import 'GuardiasVew.dart';
import 'PuntosView.dart';

class RondaDetalle extends StatefulWidget {
  final int idRonda;
  final String nombreRonda;
  final String descripcionRonda;
  const RondaDetalle({
    required this.idRonda,
    required this.nombreRonda,
    required this.descripcionRonda,
    super.key
  });

  @override
  State<RondaDetalle> createState() => _RondaDetalleState();
}

class _RondaDetalleState extends State<RondaDetalle> {
  bool canedit = false;

  @override
  void initState() {
    MainProvider mainProvider = Provider.of<MainProvider>(context, listen: false);
    mainProvider.canedit().then((value) => canedit = value);
    super.initState();
  }

  TabMenu tabMenuView = TabMenu.Puntos;
  @override
  Widget build(BuildContext context) {
    RondasProvider rondasProvider = Provider.of<RondasProvider>(context);
    ApiService apiService = Provider.of<ApiService>(context);
    MapviewController mapviewController = Provider.of<MapviewController>(context);
    return Scaffold(
      appBar: CustomAppBar(),


      floatingActionButton: FloatingActionButton.extended(
        onPressed: ()async {
          var listarondas = await rondasProvider.getRondaPoints(apiService, widget.idRonda.toString());
          final positionList = mapviewController.setMarkersByPositionList(listarondas);
          mapviewController.menuselection = 4;
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MapView(
                idRonda: widget.idRonda,
              ),
            ),
          );
        },
        label:  Row(
          children: [
            Text('ver en el mapa', style: TextStyle(color: Colors.white),),
            SizedBox(width: 10,),
            Icon(Icons.map, color: Colors.white,)
          ],
        ),
        backgroundColor: Colors.blue[900],
      ),
      // PopupMenuButton(
      //   child: Padding(
      //     padding: const EdgeInsets.all(10.0),
      //     child: Container(
      //       height: 50,
      //       width: 50,
      //       margin: const EdgeInsets.only(top: 10),
      //       decoration: BoxDecoration(
      //         color: Colors.blue[900],
      //         borderRadius: BorderRadius.circular(20),
      //         boxShadow: const [
      //           BoxShadow(
      //             color: Colors.black12,
      //             blurRadius: 5,
      //             offset: Offset(0, 5),
      //           ),
      //         ],
      //       ),
      //       child: const Icon(Icons.keyboard_arrow_up, color: Colors.white,)
      //     ),
      //   ),
      //   itemBuilder: (context) => [
      //     // PopupMenuItem(
      //     //   child: Text("Rondas"),
      //     //   value: 0,
      //     // ),


      //     // tabMenuView == TabMenu.Puntos?
      //     // const PopupMenuItem(
      //     //   child: Row(
      //     //     children: [
      //     //       Icon(Icons.add_location_alt_outlined),
      //     //       Text("Editar Puntos"),
      //     //     ],
      //     //   ),
      //     //   value: 0,
      //     // )


      //     // :PopupMenuItem(
      //     //   child: Row(
      //     //     children: [
      //     //       Icon(Icons.add_circle_outline_outlined,),
      //     //       Text("Agregar guardia"),
      //     //     ],
      //     //   ),
      //     //   value: 1,
      //     // ),
          
      //     PopupMenuItem(
      //       child: Row(
      //         children: [
      //           Icon(Icons.map_outlined),
      //           Text("Ver en el mapa"),
      //         ],
      //       ),
      //       value: 2,
      //     ),

      //   ],
      //   onSelected: (value) async{
      //       switch (value) {
      //         case 0:
      //           // tabMenuView = TabMenu.Puntos;
      //           print("Agregar punto");
      //           var listarondas = await rondasProvider.getRondaPoints(apiService, widget.idRonda.toString());
      //           final positionList = mapviewController.setMarkersByPositionList(listarondas);
      //           mapviewController.menuselection = 2;
      //           Navigator.push(
      //             context,
      //             MaterialPageRoute(
      //               builder: (context) => MapView(
      //                 idRonda: widget.idRonda,
      //               ),
      //             ),
      //           );
      //           break;
      //         case 1:
      //           print("Agregar guardia");
      //           showModalBottomSheet(
      //             context: context,
      //             builder: (context) => AgregarGuardiaFormulario(idRonda: widget.idRonda),
      //           );
      //           // tabMenuView = TabMenu.Guardias;
      //           break;
      //         case 2:
                // var listarondas = await rondasProvider.getRondaPoints(apiService, widget.idRonda.toString());
                // final positionList = mapviewController.setMarkersByPositionList(listarondas);
                // mapviewController.menuselection = 4;
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) => MapView(
                //       idRonda: widget.idRonda,
                //     ),
                //   ),
                // );
      //           break;
      //         default:
      //       }
      //     setState(() {
            
      //     });
      //   },
      // ),




      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
              ),
               width: double.infinity,
              child: Center(
                child: Text(
                  '${widget.descripcionRonda} ',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
              ),
               width: double.infinity,
              child: Center(
                child: Text(
                  '${widget.nombreRonda} ',
                  style: TextStyle(
                    fontSize: 12.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              width: double.infinity,
              child: Center(
                child: SegmentedButton<TabMenu>(
                  segments: const <ButtonSegment<TabMenu>>[
                    ButtonSegment<TabMenu>(
                      value: TabMenu.Puntos,
                      label: Text('Puntos'),
                      icon: Icon(Icons.location_on_outlined)
                    ),
                    ButtonSegment<TabMenu>(
                      value: TabMenu.Guardias,
                      label: Text('Guardias'),
                      icon: Icon(Icons.shield_outlined)
                    ),
                  ],
                  selected: <TabMenu>{tabMenuView},
                  selectedIcon: tabMenuView == TabMenu.Puntos 
                    ? Icon(Icons.location_on) 
                    : Icon(Icons.shield),
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
          
            if (tabMenuView == TabMenu.Guardias) 
              GuardiasView(idRonda: widget.idRonda)
            else if (tabMenuView == TabMenu.Puntos) 
              PuntosView(idRonda: widget.idRonda),
      
      
            if (tabMenuView == TabMenu.Puntos && canedit)
            BotonAgregarPunto(
              apiService: apiService, 
              widget: widget
            ),

            if (tabMenuView == TabMenu.Guardias  && canedit)
            BotonAgregarGuardia(
              apiService: apiService, 
              widget: widget
            ),
          ],
        ),
      ),
    );
  }
}

class BotonAgregarPunto extends StatelessWidget {
  const BotonAgregarPunto({
    super.key,
    required this.apiService,
    required this.widget,
  });

  final ApiService apiService;
  final RondaDetalle widget;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () { 
        showDialog(
          context: context,
          builder: (context) {
            TextEditingController puntoController = TextEditingController();

            return AlertDialog(
              title: const Text('Agregar punto'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Se agregará un punto en su ubicación actual'),
                  TextField(
                    controller: puntoController,
                    decoration: InputDecoration(labelText: 'Nombre del punto'),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, 'Cancel'),
                  child: const Text('Cancelar'),
                ),
                TextButton(
                  onPressed: () async {
                    Navigator.pop(context, 'Aceptar');
                    MapviewController mapviewcontroller = Provider.of<MapviewController>(context, listen: false);
                    RondasProvider rondasProvider = Provider.of<RondasProvider>(context, listen: false);

                    try {
                      var pos = await mapviewcontroller.determinePosition();
                      String puntoNombre = puntoController.text; // Obtener el nombre del punto desde el TextField

                      await rondasProvider.enviarNuevoPunto(
                        apiService,
                        widget.idRonda,
                        0,
                        "${pos.latitude.toString()},${pos.longitude.toString()}",
                        puntoNombre,
                      );
                    } catch (error) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('ha ocurrido un error'),
                          backgroundColor: Colors.red,
                        ),
                      );
                      // Manejar errores aquí
                      print("Error: $error");
                    }
                    // show snakbar color verde
                    // ScaffoldMessenger.of(context).showSnackBar(
                    //   const SnackBar(
                    //     content: Text('Punto agregado'),
                    //     backgroundColor: Colors.green,
                    //   ),
                    // );

                    // Navigator.pop(context, 'Aceptar');
                  },
                  child: const Text('Aceptar'),
                ),
              ],
            );
          },
        );

      },
      child: const Text('agregar punto'),
    );
  }
}


class BotonAgregarGuardia extends StatelessWidget {
  const BotonAgregarGuardia({
    super.key,
    required this.apiService,
    required this.widget,
  });

  final ApiService apiService;
  final RondaDetalle widget;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () { 
        showModalBottomSheet(
          context: context,
          builder: (context) => AgregarGuardiaFormulario(idRonda: widget.idRonda),
        );

      },
      child: const Text('Asignar un Guardia'),
    );
  }
}




enum TabMenu { Puntos, Guardias}


