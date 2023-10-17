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


class HomeRondas extends StatefulWidget {
  static const routeName = 'HomeRondas';
  const HomeRondas({super.key});

  @override
  State<HomeRondas> createState() => _HomeRondasState();
}

class _HomeRondasState extends State<HomeRondas> {
  late int _selectedIndex;
  late final PageController _pageController;
  late final List<Widget> _pages;
  late List<Map<String, dynamic>> menu;
  late bool canedit = false;

  @override
  void initState() {
    super.initState();
    final apiservices = Provider.of<ApiService>(context, listen: false);
    final mainProvider = Provider.of<MainProvider>(context, listen: false);
    mainProvider.canedit().then((value) => canedit = value);
    _selectedIndex = 0;
    _pageController = PageController(initialPage: 0);
    // fetchMenu(apiservices, mainProvider);
    _pages = [
      // HomePage(),
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
    final mainProvider = Provider.of<MainProvider>(context, listen: false);
    return Scaffold(
      appBar: CustomAppBar(),
      // bottomNavigationBar: NavigationBar(
      //   // backgroundColor: Colors.blue[900],
      //   //indicatorColor: Colors.white,
        
      //   onDestinationSelected: (int index) {
      //     setIndex(index);
      //   },
      //   selectedIndex: _selectedIndex,
        
      //   destinations:[

      //     // NavigationDestination(
          
      //     //   icon: Icon(Icons.home_outlined,),
      //     //   selectedIcon: Icon(Icons.home_outlined),
      //     //   label: 'Home',
            
            
            
      //     // ),
      //     NavigationDestination(
      //       icon: Icon(Icons.change_circle_outlined),
      //       selectedIcon: Icon(Icons.change_circle_outlined),
      //       label: 'Rondas',
      //     ),
      //   ],
      // ),
      floatingActionButton: 

        // _selectedIndex == 0?
        //   null


        _selectedIndex == 0 && canedit?
          FloatingRondas()
        : null,
        
        body: RondasPage(),
      //   body: PageView(
      //   onPageChanged: (value) {
      //     setIndex(value);
      //   },
      //   controller: _pageController,
      //   children: _pages,

      // ),
    );
  }
}


