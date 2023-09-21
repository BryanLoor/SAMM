import 'package:flutter/material.dart';

class NavBar extends StatefulWidget {
  int currentPageIndex = 0;
  NavBar(
    this.currentPageIndex,
    {
    super.key
  });

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  @override
  Widget build(BuildContext context) {
    return NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            widget.currentPageIndex = index;
          });
        },
        // indicatorColor: Colors.amber[800],
        selectedIndex: widget.currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.car_crash_outlined),
            label: 'Visitas',
          ),
          NavigationDestination(
            icon: Icon(Icons.change_circle_outlined),
            label: 'Rondas',
          ),
        ],
      );
  }
}