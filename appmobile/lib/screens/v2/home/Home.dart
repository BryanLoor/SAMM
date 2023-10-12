import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sammseguridad_apk/provider/visitasProvider.dart';
import 'package:sammseguridad_apk/screens/v2/generarVisita/maps/mapsview.dart';
import 'package:sammseguridad_apk/screens/v2/home/homeNavPages/RondasPage.dart';
import 'package:sammseguridad_apk/screens/v2/home/homeNavPages/homePage.dart';
import 'package:sammseguridad_apk/screens/v2/home/homeNavPages/visitasPage.dart';
import 'package:sammseguridad_apk/screens/widgets/ModalBottomCreateVisita.dart';
import 'package:sammseguridad_apk/widgets/Appbar.dart';
import 'package:sammseguridad_apk/widgets/navbar.dart';


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

  @override
  void initState() {
    super.initState();
    _selectedIndex = 0;
    _pageController = PageController(initialPage: _selectedIndex);
    _pages = [
      HomePage(setIndex: setIndex),
      VisitasPage(),
      // RondasPage(),
      MapView(),
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
    // final visitasProvider = Provider.of<VisitasProvider>(context);
    // if (!visitasProvider.hasFetchedData) {
    //   visitasProvider.refreshvisitas(context,visitasProvider);
    //   visitasProvider.hasFetchedData = true;
    // }
    return Scaffold(
      appBar: CustomAppBar(),
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setIndex(index);
        },
        selectedIndex: _selectedIndex,
        destinations: const <Widget>[
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.car_crash_outlined),
            selectedIcon: Icon(Icons.car_crash_outlined),
            label: 'Visitas',
          ),
          NavigationDestination(
            icon: Icon(Icons.change_circle_outlined),
            selectedIcon: Icon(Icons.change_circle_outlined),
            label: 'Rondas',
          ),
        ],
      ),
      floatingActionButton: _selectedIndex == 1?
        FloatingActionButton(
          onPressed: () {
            showModalBottomSheet(
              isScrollControlled: true,
              context: context,
              builder: (BuildContext context) {
                return FractionallySizedBox(
                  heightFactor: 0.75, // Ajusta este valor según tus necesidades.
                  child: ModalBottomCreateVisita(
                    cedula: '',
                    nombre: '',
                  ),
                );
              },
              // builder: (context) => ModalBottomCreateVisita(
              //   cedula: '',
              //   nombre: '',
              // ),
            );
          },
          child: Icon(Icons.add), // Icono del botón principal
        )
        : null,
        // : _selectedIndex == 2?
        // FloatingActionButton(
        //   onPressed: () {
        //     Navigator.push(
        //       context,
        //       MaterialPageRoute(builder: (context) => MapView(
        //         // initialMenuselection: 0,
        //         // initialMarkersPositionList: [],
        //       )),
        //     );
        //   },
        //   child: Icon(Icons.map), // Icono del botón principal
        // )
        // : null,
      // floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
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



// destinations: const <Widget>[
//           NavigationDestination(
//             icon: Icon(Icons.home_outlined),
//             selectedIcon: Icon(Icons.shield_outlined),
//             label: 'Home',
//           ),
//           NavigationDestination(
//             icon: Icon(Icons.car_crash_outlined),
//             selectedIcon: Icon(Icons.shield_outlined),
//             label: 'Visitas',
//           ),
//           NavigationDestination(
//             icon: Icon(Icons.change_circle_outlined),
//             selectedIcon: Icon(Icons.shield_outlined),
//             label: 'Rondas',
//           ),
//         ],