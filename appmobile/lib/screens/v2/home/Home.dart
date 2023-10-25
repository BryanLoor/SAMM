import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sammseguridad_apk/provider/mainprovider.dart';
import 'package:sammseguridad_apk/provider/visitasProvider.dart';
import 'package:sammseguridad_apk/screens/v2/generarVisita/maps/mapsview.dart';
import 'package:sammseguridad_apk/screens/v2/home/floatings/FloatingRondas.dart';
import 'package:sammseguridad_apk/screens/v2/home/floatings/FloatingVisitas.dart';
import 'package:sammseguridad_apk/screens/v2/home/homeNavPages/Rondas/NuevaRondaFormulario.dart';
import 'package:sammseguridad_apk/screens/v2/home/homeNavPages/RondasPage.dart';
import 'package:sammseguridad_apk/screens/v2/home/homeNavPages/homePage.dart';
import 'package:sammseguridad_apk/screens/v2/home/homeNavPages/visitasPage.dart';
import 'package:sammseguridad_apk/screens/widgets/ModalBottomCreateVisita.dart';
import 'package:sammseguridad_apk/services/ApiService.dart';
import 'package:sammseguridad_apk/widgets/Appbar.dart';
import 'package:sammseguridad_apk/widgets/navbar.dart';
import 'package:shared_preferences/shared_preferences.dart';


class Home extends StatefulWidget {
  static const routeName = 'Home';
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late int _selectedIndex;
  late final PageController _pageController;
  late final List<Widget> _pages;
  late List<Map<String, dynamic>> menu;


  @override
  void initState() {
    super.initState();
    final apiservices = Provider.of<ApiService>(context, listen: false);
    final mainProvider = Provider.of<MainProvider>(context, listen: false);
    _selectedIndex = 0;
    _pageController = PageController(initialPage: 0);
    // fetchMenu(apiservices, mainProvider);
    _pages = [
      HomePage(),
      VisitasPage(),
      RondasPage(),
      // MapView(),
   
   
    ];
  }

  void setIndex(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _pageController.jumpToPage(index); // Cambia la página utilizando el controlador
  }



  @override
  Widget build(BuildContext context) {
    Future<List> getOpciones() async {
    List data= [
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
    var jwtToken=MainProvider.prefs.getString("token");
    //var jwtToken = sharedPreferences.getString("token") ?? "";

    //var curretUser = MainProvider.prefs.getString("currentUser");
    //return await  ApiService().getData(url,jwtToken!); 
    return data;
  }
    return Scaffold(
      
      appBar: CustomAppBar(),
      bottomNavigationBar: NavigationBar(
        height: 60,
        backgroundColor: Colors.blue[900],
        indicatorColor: Colors.blue[800],
        onDestinationSelected: (int index) {
          setIndex(index);
        },
        selectedIndex: _selectedIndex,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
        indicatorShape:ShapeBorder.lerp(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          1,
        ),
        destinations: [
          NavigationDestination(
            icon: Icon(
              Icons.home_outlined,
              color: Colors.white, // Color blanco para el ícono
            ),
            selectedIcon: Icon(
              Icons.home_outlined,
              color: Colors.white, // Color blanco para el ícono seleccionado
            ),
            label: 'Home',

          ),
          NavigationDestination(
            icon: Icon(
              Icons.car_crash_outlined,
              color: Colors.white, // Color blanco para el ícono
            ),
            selectedIcon: Icon(
              Icons.car_crash_outlined,
              color: Colors.white, // Color blanco para el ícono seleccionado
            ),
            label: 'Visitas',
          ),
          NavigationDestination(
            icon: Icon(
              Icons.change_circle_outlined,
              color: Colors.white, // Color blanco para el ícono
            ),
            selectedIcon: Icon(
              Icons.change_circle_outlined,
              color: Colors.white, // Color blanco para el ícono seleccionado
            ),
            label: 'Rondas',
          ),
          ElevatedButton(onPressed: () {
             print("-------------------------------------");

        getOpciones().then((value) => print(value));
          }, child: Icon(Icons.abc))
        ],
      ),

      floatingActionButton: 

        _selectedIndex == 0?
          null


        :_selectedIndex == 1?
          FloatingVisitas()



        :_selectedIndex == 2?
          FloatingRondas()
        : null,
        
        
        body: PageView(
        onPageChanged: (value) {
          setIndex(value);
         
        },
        controller: _pageController,
        children: _pages,

      ),
    );
  }
}


