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


class HomeVisitas extends StatefulWidget {
  static const routeName = 'HomeVisitas';
  const HomeVisitas({super.key});

  @override
  State<HomeVisitas> createState() => _HomeVisitasState();
}

class _HomeVisitasState extends State<HomeVisitas> {
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
    return Scaffold(
      appBar: CustomAppBar(),
      bottomNavigationBar: NavigationBar(
        // backgroundColor: Colors.blue[900],
        //indicatorColor: Colors.white,
        
        onDestinationSelected: (int index) {
          setIndex(index);
        },
        selectedIndex: _selectedIndex,
        
        destinations:[

          NavigationDestination(
          
            icon: Icon(Icons.home_outlined,),
            selectedIcon: Icon(Icons.home_outlined),
            label: 'Home',
            
            
            
          ),
          NavigationDestination(
            icon: Icon(Icons.car_crash_outlined),
            selectedIcon: Icon(Icons.car_crash_outlined),
            label: 'Visitas',
          ),
        ],
      ),
      floatingActionButton: 

        _selectedIndex == 0?
          null


        :_selectedIndex == 1?
          FloatingVisitas()

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


