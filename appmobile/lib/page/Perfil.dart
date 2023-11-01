import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:sammseguridad_apk/widgets/Drawer.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:sammseguridad_apk/provider/mainprovider.dart';
import 'package:sammseguridad_apk/screens/logins/LoginResponse.dart';

class PerfilPage extends StatefulWidget {
  
  const PerfilPage({Key? key}) : super(key: key);

  @override
  State<PerfilPage> createState() => _PerfilPageState();
}

class _PerfilPageState extends State<PerfilPage> {

  

  @override
  Widget build(BuildContext context) {
    MainProvider _mainProvider = Provider.of<MainProvider>(context);
    // Generate QR code data
    final qrData = 'Nombres: ${MainProvider.prefs.getString("Nombres")}, '
      'Apellidos: ${MainProvider.prefs.getString("Apellidos")}, '
      'Cédula: ${MainProvider.prefs.getString("Identificacion")}, '
      'Número de celular: ${MainProvider.prefs.getString("Telefono")}, '
      'Correo electrónico: ${MainProvider.prefs.getString("Correo")}, '
      'Contraseña: xxxxxxxxxx'; // Replace with your QR data

    return Scaffold(
     
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        /*decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/FOTO-1.jpg'),
            fit: BoxFit.cover,
          ),
        ),*/
        child: Center(
          child: Container(
            padding: EdgeInsets.all(10.0),
            margin: EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              //color: Colors.blueGrey.withOpacity(0.7),
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: ListView(
              shrinkWrap: true,
              children: [
                SizedBox(height: 20),
                // QR code widget
                Center(
                  child: SizedBox(
                    width: 200,
                    height: 200,
                    child: QrImageView(
                      data: qrData,
                      version: QrVersions.auto,
                      backgroundColor: Colors.white,
                      dataModuleStyle: QrDataModuleStyle(
                        color: Colors.black,
                        dataModuleShape: QrDataModuleShape.square
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                
                SizedBox(height: 10),
                Text(
                  'Información',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 25.0, color: Colors.black),
                ),
                SizedBox(height: 20),
                Column(
                  children: [
                    createInfoRow('Nombres:', '${MainProvider.prefs.getString("Nombres")}'),
                createInfoRow('Apellidos:', '${MainProvider.prefs.getString("Apellidos")}'),
                createInfoRow('Cédula:', '${MainProvider.prefs.getString("Identificacion")}'),
                createInfoRow('Número de celular:', '${MainProvider.prefs.getString("Telefono")}'),
                createInfoRow('Correo electrónico:', '${MainProvider.prefs.getString("Correo")}'),
                createInfoRow('Contraseña:', 'xxxxxxxxxx'),
                  ],
                ),
                InkWell(
                  onTap: () {
                    // Implementar lógica de cambio de contraseña
                  },
                  child: Text(
                    "Cambiar contraseña",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget createInfoRow(String title, String info) {
    return Padding(
      padding: EdgeInsets.only(bottom: 20.0),
      child: Column(
        children: [
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
          Text(
            info,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}