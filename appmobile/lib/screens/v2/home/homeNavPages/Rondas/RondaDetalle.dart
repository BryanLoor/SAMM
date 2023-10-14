import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
  TabMenu tabMenuView = TabMenu.Puntos;
  @override
  Widget build(BuildContext context) {
    RondasProvider rondasProvider = Provider.of<RondasProvider>(context);
    ApiService apiService = Provider.of<ApiService>(context);
    MapviewController mapviewController = Provider.of<MapviewController>(context);
    return Scaffold(
      appBar: CustomAppBar(),


      floatingActionButton:
      PopupMenuButton(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Container(
            height: 50,
            width: 50,
            margin: const EdgeInsets.only(top: 10),
            decoration: BoxDecoration(
              color: Colors.blue[900],
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 5,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: const Icon(Icons.keyboard_arrow_up, color: Colors.white,)
          ),
        ),
        itemBuilder: (context) => [
          // PopupMenuItem(
          //   child: Text("Rondas"),
          //   value: 0,
          // ),


          tabMenuView == TabMenu.Puntos?
          const PopupMenuItem(
            child: Row(
              children: [
                Icon(Icons.add_location_alt_outlined),
                Text("Editar Puntos"),
              ],
            ),
            value: 0,
          )


          :PopupMenuItem(
            child: Row(
              children: [
                Icon(Icons.add_circle_outline_outlined,),
                Text("Agregar guardia"),
              ],
            ),
            value: 1,
          ),
          
          PopupMenuItem(
            child: Row(
              children: [
                Icon(Icons.map_outlined),
                Text("Ver en el mapa"),
              ],
            ),
            value: 2,
          ),

        ],
        onSelected: (value) async{
            switch (value) {
              case 0:
                // tabMenuView = TabMenu.Puntos;
                print("Agregar punto");
                var listarondas = await rondasProvider.getRondaPoints(apiService, widget.idRonda.toString());
                final positionList = mapviewController.setMarkersByPositionList(listarondas);
                mapviewController.menuselection = 2;
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MapView(
                      idRonda: widget.idRonda,
                    ),
                  ),
                );
                break;
              case 1:
                print("Agregar guardia");
                showModalBottomSheet(
                  context: context,
                  builder: (context) => AgregarGuardiaFormulario(idRonda: widget.idRonda),
                );
                // tabMenuView = TabMenu.Guardias;
                break;
              case 2:
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
                break;
              default:
            }
          setState(() {
            
          });
        },
      ),




      body: Column(
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
            PuntosView(idRonda: widget.idRonda)
        ],
      ),
    );
  }
}


enum TabMenu { Puntos, Guardias}