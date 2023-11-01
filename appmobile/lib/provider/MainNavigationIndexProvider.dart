
import 'package:flutter/material.dart';
import 'package:sammseguridad_apk/screens/v2/home/homeNavPages/RondasPage.dart';
import 'package:sammseguridad_apk/screens/v2/home/homeNavPages/homePage.dart';
import 'package:sammseguridad_apk/screens/v2/home/homeNavPages/visitasPage.dart';



class MainNavigationIndexProvider with ChangeNotifier {
  int _current = 0;

  int get current => _current;
  

  set current(int newIndex) {
    _current = newIndex;
    notifyListeners();
  }

  List<Widget> _pages =  [
      HomePage(),
      RondasPage(),
      VisitasPage(),
  ];



  List<Widget> get pages => _pages;


  set pages(List<Widget> newPages) {
    _pages = newPages;
    notifyListeners();
  }

}
