import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sammseguridad_apk/provider/mainprovider.dart';
import 'package:sammseguridad_apk/screens/v2/home/HomeRondas.dart';
import 'package:sammseguridad_apk/screens/v2/home/HomeVisitas.dart';
import 'package:sammseguridad_apk/services/ApiService.dart';
import 'package:shared_preferences/shared_preferences.dart';

// import 'ScreenWelcom.dart';
import 'logins/ScreenLogin.dart';
import 'v2/home/Home.dart';

class ScreenSplash extends StatefulWidget {
  static const String routeName = '/splash';

  const ScreenSplash({Key? key}) : super(key: key);

  @override
  _ScreenSplashState createState() => _ScreenSplashState();
}

class _ScreenSplashState extends State<ScreenSplash> {
  @override
  void initState() {
    super.initState();

    Timer(const Duration(seconds: 2), () {
    //   Navigator.pushReplacementNamed(context, LoginPage.routeName);
    //   // Navigator.pushReplacement(
    //   //   context,
    //   //   MaterialPageRoute(builder: (context) => const LoginPage()),
    //   // );
      
      verifySession();
    });
  }



  Future<bool> refreshToken(
    String jwtToken,
  ) async {
    ApiService _apiService = Provider.of<ApiService>(context, listen: false);
    MainProvider _mainProvider = Provider.of<MainProvider>(context, listen: false);
    try {
      var response = await _apiService.postData("/login/actualizar_token", {}, jwtToken);
      if (response['access_token'] != null) {
        _mainProvider.updateToken(response['access_token']);
        _mainProvider.response=response;
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  void verifySession() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final descripcion = prefs.getString("Descripcion");
    bool canrefresh = await refreshToken(token??"");
    if (token != null && canrefresh) {
      if (descripcion == "Agente"){
        Navigator.pushReplacementNamed(context, HomeRondas.routeName);
      }else
      if (descripcion == "Anfitrión"){
        Navigator.pushReplacementNamed(context, HomeVisitas.routeName);
      }else{
        Navigator.pushReplacementNamed(context, Home.routeName);
        print("===================================================================================");

      }
    } else {
      Navigator.pushReplacementNamed(context, LoginPage.routeName);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black,
                  Colors.black,
                ],
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF001554),
                  Color(0xFF297DE2),
                ],
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 10),
                Transform.scale(
                  scale:
                      0.4, // Ajusta este valor para cambiar el tamaño de la imagen
                   child: Image.asset('assets/images/SAMM.png'),  // Asegúrate de que 'assets/my_logo.png' se encuentra en tu archivo pubspec.yaml


                ),
                CircularProgressIndicator(),
                SizedBox(height: 20),
                Text(
                  'SAM',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 255, 255, 255),
                      fontSize: 24.0),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
