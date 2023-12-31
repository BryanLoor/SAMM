import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sammseguridad_apk/page/MainPage.dart';
import 'package:sammseguridad_apk/provider/MainNavigationIndexProvider.dart';
import 'package:sammseguridad_apk/provider/mainprovider.dart';
import 'package:sammseguridad_apk/provider/rondasProvider.dart';
import 'package:sammseguridad_apk/provider/visitasProvider.dart';
import 'package:sammseguridad_apk/screens/ScreanMenu.dart';
import 'package:sammseguridad_apk/screens/ScreenHistorialVisitas.dart';
import 'package:sammseguridad_apk/screens/ScreenPerfil.dart';
import 'package:sammseguridad_apk/screens/logins/ScreenFaceID_Huella.dart';
import 'package:sammseguridad_apk/screens/logins/ScreenLogin.dart';
import 'package:sammseguridad_apk/screens/crear/ScreenCreascuenta.dart';
import 'package:sammseguridad_apk/screens/v2/generarVisita/maps/mapviewController.dart';
import 'package:sammseguridad_apk/screens/v2/home/Home.dart';
import 'package:sammseguridad_apk/screens/v2/home/HomeRondas.dart';
import 'package:sammseguridad_apk/screens/v2/home/HomeVisitas.dart';

import 'screens/logins/ScreenLoginPin.dart';
import 'screens/ScreenSplash.dart';
import 'services/ApiService.dart';

import 'package:intl/date_symbol_data_local.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting();

  runApp(
    MultiProvider(
      providers: [
        Provider<ApiService>(
          create: (_) => ApiService(),
        ),
        ChangeNotifierProvider(
          create: (_) => MainProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => VisitasProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => RondasProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => MapviewController(),
        ),
        ChangeNotifierProvider(
          create: (_) => MainNavigationIndexProvider(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue[900]!,
          
        // ).copyWith(
        //   secondary: Colors.blue,
        ),

        // appBarTheme: AppBarTheme(
        //   backgroundColor: Color(0xFF0040AE),
        //   foregroundColor: Colors.white,
        // ),
        
      ),
      debugShowCheckedModeBanner: false,
      title: 'SAM',
      initialRoute: ScreenSplash.routeName,
      routes: {
        LoginPage.routeName: (context) => const LoginPage(),
        Home.routeName: (context) => const Home(),
        HomeRondas.routeName: (context) => const HomeRondas(),
        HomeVisitas.routeName: (context) => const HomeVisitas(),
        MainPage.routeName:(context) => const MainPage(), 
        
        ScreenPerfil.routeName: (context) => const ScreenPerfil(),
        // ScreenHome.routeName: (context) => ScreenHome(),
        ScreenLoginPin.routeName: (context) => const ScreenLoginPin(),
        ScreenFaceID_Huella.routeName: (context) => const ScreenFaceID_Huella(),
        ScreenSplash.routeName: (context) => const ScreenSplash(),
        ScreanMenu.routeName: (context) => const ScreanMenu(),
        ScreenHistorialVisitas.routeName: (context) =>
            ChangeNotifierProvider<MainProvider>(
              create: (_) => MainProvider(),
              child: const ScreenHistorialVisitas(),
            ),
        'register': (context) => ScreenCreascuenta(), // Agrega esta línea
      },
    );
  }
}