import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sammseguridad_apk/page/Perfil.dart';
import 'package:sammseguridad_apk/provider/MainNavigationIndexProvider.dart';
import 'package:sammseguridad_apk/provider/mainprovider.dart';
import 'package:sammseguridad_apk/services/ApiService.dart';

List opciones = [];

class NavBar extends StatefulWidget {
  int currentPageIndex = 0;
  NavBar(
      //this.currentPageIndex,
      {super.key});

  @override
  State<NavBar> createState() => _NavBarState();
}

Map<String, IconData> icons = {
  "Bitácora Digital": Icons.menu_book_outlined,
  "Visitas": Icons.car_crash_outlined,
  "Rondas": Icons.change_circle_outlined,
  "Recorridos": Icons.home_outlined,
  "Perfil": Icons.person,
  "Home":Icons.home_outlined
};

class _NavBarState extends State<NavBar> {
  late Future<List> opcionesFuture;

  Future<List> getOpciones() async {
    List data = [
      {
        "Codigo": "RONDMOB",
        "Descripcion": "Rondas",
        "Estado": "A",
        "FechaCrea": "Wed, 05 Jul 2023 04:28:55 GMT",
        "FechaModifica": "Wed, 05 Jul 2023 04:28:55 GMT",
        "FechaUltimoLogin": "Wed, 05 Jul 2023 04:28:55 GMT",
        "Icon": null,
        "Id": 1007,
        "UsuarioCrea": 1,
        "UsuarioModifica": 1,
        "path": "rondas"
      },
      {
        "Codigo": "VISMOB",
        "Descripcion": "Visitas",
        "Estado": "A",
        "FechaCrea": "Fri, 01 Sep 2023 00:00:00 GMT",
        "FechaModifica": "Fri, 01 Sep 2023 00:00:00 GMT",
        "FechaUltimoLogin": null,
        "Icon": "FcPlanner",
        "Id": 1006,
        "UsuarioCrea": 1,
        "UsuarioModifica": 1,
        "path": "visitas"
      }
    ];
    const url = '/menu/getMenu/MOBILE';
    var jwtToken = MainProvider.prefs.getString("token");
    //var jwtToken = sharedPreferences.getString("token") ?? "";

    //var curretUser = MainProvider.prefs.getString("currentUser");
    return await ApiService().getData(url, jwtToken!);
    //return data;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("INICIOOOOOOOOOOOOOOOOOOOOOOO");
    opcionesFuture = getOpciones();
  }

  @override
  Widget build(BuildContext context) {
    final mainNavigationIndexProvider =
        Provider.of<MainNavigationIndexProvider>(context);

    return FutureBuilder(
      future: opcionesFuture,
      initialData: [],
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Muestra un indicador de carga mientras se obtienen los datos
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          // Manejo de errores si la solicitud falla
          return const Text('Error al traer las opciones');
        } else if (!snapshot.hasData) {
          // Si no hay datos disponibles
          return const Text('No hay datos disponibles.');
        } else {
          final listaOpt = snapshot.data;
          print(mainNavigationIndexProvider.pages);
          print(listaOpt);

          return NavigationBar(
            height: 60,
            backgroundColor: Colors.blue[900],
            indicatorColor: Colors.blue[800],
            onDestinationSelected: (int index) {
              //setState(() {
             
              mainNavigationIndexProvider.current = index;
              
              //});
            },
            selectedIndex: mainNavigationIndexProvider.current,
            labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
            indicatorShape: ShapeBorder.lerp(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              1,
            ),
            destinations: [
              ...List.generate(
                listaOpt.length,
                (index) {
                  final opcion = listaOpt[index];
                  final nombreOpcion = opcion["Descripcion"].toString();
                  final icono = icons[nombreOpcion] ?? Icons.star;
                  return NavigationDestination(
                    icon: Icon(
                      icono,
                      color: Colors.white,
                    ),
                    selectedIcon: Icon(
                      icono,
                      color: Colors.white,
                    ),
                    label: nombreOpcion,
                  );
                },
              ),
              NavigationDestination(
                icon: Icon(
                  Icons.person,
                  color: Colors.white,
                ),
                selectedIcon: Icon(
                  Icons.person,
                  color: Colors.white,
                ),
                label: 'Usuario',
              ),
            ],
          );
        }
      },
    );
  }
}
