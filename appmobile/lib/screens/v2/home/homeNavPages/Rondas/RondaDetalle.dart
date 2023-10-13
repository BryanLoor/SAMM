import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sammseguridad_apk/provider/rondasProvider.dart';
import 'package:sammseguridad_apk/screens/v2/generarVisita/maps/mapsview.dart';
import 'package:sammseguridad_apk/screens/v2/generarVisita/maps/mapviewController.dart';
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
      floatingActionButton: FlotingActionMenu(
        idRonda: widget.idRonda,
        tabMenuView: tabMenuView,
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
            GuardiasView()
          else if (tabMenuView == TabMenu.Puntos) 
            PuntosView(idRonda: widget.idRonda)
        ],
      ),
    );
  }
}

class FlotingActionMenu extends StatelessWidget {
  int idRonda;
  TabMenu tabMenuView;
  FlotingActionMenu({
    required this.idRonda,
    required this.tabMenuView,
    super.key,
  });


  @override
  Widget build(BuildContext context) {
    RondasProvider rondasProvider = Provider.of<RondasProvider>(context);
    ApiService apiService = Provider.of<ApiService>(context);
    MapviewController mapviewController = Provider.of<MapviewController>(context);
    
    if (tabMenuView == TabMenu.Puntos){
      return Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [


          tabMenuView == TabMenu.Puntos?
            FloatingActionButton.extended(
              onPressed: (){

              }, 
              label: Text('Agregar punto'),
              icon: Icon(Icons.add_location_alt_outlined),
            )

          :tabMenuView == TabMenu.Guardias?
            
            FloatingActionButton.extended(
              onPressed: (){

              }, 
              label: Text('Agregar guardia'),
              icon: Icon(Icons.add_circle_outline_outlined),
            )
          :Container(),
          

          
          SizedBox(height: 16), // Espacio entre los botones flotantes
          
          
          FloatingActionButton.extended(
            onPressed: () async{

              var listarondas = await rondasProvider.getRondaPoints(apiService, idRonda.toString());
              final positionList = mapviewController.setMarkersByPositionList(listarondas);


              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MapView(
                    idRonda: idRonda,
                  ),
                ),
              );
            },
            label: Text('Ver en el mapa'),
            // icono de tres puntos
            icon: Icon(Icons.map_outlined),
          ),
        ],
      );

    }else if (tabMenuView == TabMenu.Guardias){
      return Column();

    }
    
    
    
    return FloatingActionButton.extended(
      onPressed: () async{

        var listarondas = await rondasProvider.getRondaPoints(apiService, idRonda.toString());
        final positionList = mapviewController.setMarkersByPositionList(listarondas);


        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MapView(
              idRonda: idRonda,
            ),
          ),
        );
      },
      label: Text('Ver en el mapa'),
      // icono de tres puntos
      icon: Icon(Icons.map_outlined),
    );
  }
}

enum TabMenu { Puntos, Guardias}