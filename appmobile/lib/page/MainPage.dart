import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sammseguridad_apk/provider/MainNavigationIndexProvider.dart';
import 'package:sammseguridad_apk/widgets/Appbar.dart';
import 'package:sammseguridad_apk/widgets/navbar.dart';
class MainPage extends StatelessWidget {
  static const routeName = '/main';

  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mainnavigationindexprovider =
        Provider.of<MainNavigationIndexProvider>(context);
    return WillPopScope(
      onWillPop: () async {
        // Retorna 'false' para inhabilitar el botón de retroceso para la navegaton del appbar
        return false;
      },
      
      child: Scaffold(
        appBar:
            CustomAppBar(),
        body: mainnavigationindexprovider
            .pages[mainnavigationindexprovider.current],
        bottomNavigationBar:  NavBar(),
      ),
    );
  }
}