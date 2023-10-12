import 'package:flutter/material.dart';
import 'package:sammseguridad_apk/screens/ScreenPerfil.dart';
import 'package:sammseguridad_apk/screens/ScreenSplash.dart';
import 'package:sammseguridad_apk/screens/logins/ScreenLogin.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({Key? key}) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      // leadingWidth: 20,

      // automaticallyImplyLeading: false,
      // backgroundColor: Colors.white, // Estableciendo el color del AppBar
      title: GestureDetector(
        child: Container(
          // decoration: BoxDecoration(
          //   borderRadius: BorderRadius.circular(20.0), // Ajusta el valor para redondear más o menos
          //   color: Colors.blue[900], // Color de fondo opcional
          // ),
          // width: 150,
          height: 50,
          child: Image.asset("assets/images/SAMM.png"),
          // child: Row(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: [
          //     Image.asset("assets/images/SAMM.png"),
          //     SizedBox(width: 10),
          //     Text(
          //         'SAM',
          //         style: TextStyle(
          //             fontWeight: FontWeight.bold,
          //             // color: Color.fromARGB(255, 255, 255, 255),
          //             fontSize: 18.0),
          //       ),
          //   ],
          // ),
        ),
      ),
      actions: [
        
        PopupMenuButton(
          child: Padding(
            padding: const EdgeInsets.only(right: 15.0),
            child: CircleAvatar(
              child: Icon(Icons.person),
            ),
          ),
          // icon: Icon(Icons.person),
          itemBuilder: (BuildContext context) {
            return [
              PopupMenuItem(
                value: "Perfil",
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text("Perfil"),
                    SizedBox(width: 10),
                    Icon(Icons.person),
                  ],
                ),
              ),
              PopupMenuItem(
                value: "Cerrar sesion",
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text("Cerrar sesion"),
                    SizedBox(width: 10),
                    Icon(Icons.logout),
                  ],
                ),
              ),
            ];
          },

          onSelected: (value) {
            if (value == "Perfil") {
              Navigator.pushNamed(context, ScreenPerfil.routeName);
            } else if (value == "Cerrar sesion") {
              // borrar datos de sharedpreference
              SharedPreferences.getInstance().then((value) {
                value.clear();
              });

              Navigator.popAndPushNamed(context, ScreenSplash.routeName);
            }
          },
        ),
      ],
    );
  }
}
