import 'package:flutter/material.dart';
import 'package:sammseguridad_apk/page/PageInfoSeguRonda.dart';
// import 'package:sammseguridad_apk/page/PageInfoUrbaSeguridad.dart';
import 'package:sammseguridad_apk/page/QRView%20.dart';
// import 'package:sammseguridad_apk/screens/v2/generarVisita/ScreenGenerarVisita.dart';
import 'package:sammseguridad_apk/screens/ScreenHistorialRondas.dart';
import 'package:sammseguridad_apk/screens/ScreenHistorialVisitas.dart';
// import 'package:sammseguridad_apk/screens/ScreenRondas.dart';
import 'package:sammseguridad_apk/screens/widgets/ModalBottomCreateVisita.dart';
import 'package:sammseguridad_apk/widgets/Appbar.dart';
// import 'package:sammseguridad_apk/widgets/Drawer.dart';
import 'package:sammseguridad_apk/widgets/TwoColumnsWidget.dart';
// import 'package:sammseguridad_apk/widgets/navbar.dart';

class ScreenHome extends StatelessWidget {
  static const routeName = 'Home';
  ScreenHome({super.key});

  @override
  Widget build(BuildContext context) {

    final List<Visit> visitas = [
      Visit(nombre: 'Juan', apellido: 'Perez', fecha: DateTime(2023, 9, 15)),
      Visit(nombre: 'María', apellido: 'Gomez', fecha: DateTime(2023, 9, 10)),
      Visit(nombre: 'Pedro', apellido: 'Rodriguez', fecha: DateTime(2023, 9, 5)),
    ];
    final List<Visit> rondas = [
      Visit(nombre: 'Urb. Pacho Salas', apellido: 'Pablo Cedeno', fecha: DateTime(2023, 9, 15)),
      Visit(nombre: 'Urb. Villas del rey', apellido: 'Pablo Cedeno', fecha: DateTime(2023, 9, 10)),
      Visit(nombre: 'Villas samanes', apellido: 'Pablo Cedeno', fecha: DateTime(2023, 9, 5)),
    ];

    // int _selectedIndex = 0;

    return Scaffold(
      appBar: CustomAppBar(),
      // drawer: CustomDrawer(),
      // bottomNavigationBar: NavBar(_selectedIndex),
      body: Center(
        // child:[
          child: ListView(
            children: [
              Container(
                height: 40,
                color: Colors.grey[200],
                child: Center(child: Text("Ubicacion - cuenta")),
              ),
              SizedBox.square(dimension: 10.0),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TwoColumnsWidget(
                  listaDeWidgets: [
                    ElevatedButton(
                      onPressed: () {
                        // Navigator.of(context).push(
                        //   MaterialPageRoute(
                        //     builder: (context) => ScreenGenerarVisita(),
                        //   ),
                        // );
                        showModalBottomSheet(
                          context: context,
                          builder: (context) => ModalBottomCreateVisita(
                            cedula: '',
                            nombre: '',
                          ),
                        );
                      },
                      child: Text('crear visita'),
                    ),
                    // ElevatedButton(
                    //   onPressed: () {
                    //     Navigator.of(context).push(
                    //       MaterialPageRoute(
                    //         builder: (context) => PageInfoUrbaSeguridad(),
                    //       ),
                    //     );
                    //   },
                    //   child: Text('info seguridad'),
                    // ),
                    // ElevatedButton(
                    //   onPressed: () {
                    //     Navigator.of(context).push(
                    //       MaterialPageRoute(
                    //         builder: (context) => ScreenRondas(),
                    //       ),
                    //     );
                    //   },
                    //   child: Text('rondas'),
                    // ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => ScreenHistorialRondas(),
                          ),
                        );
                      },
                      child: Text('historial rondas'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => PageInfoSeguRonda(),
                          ),
                        );
                      },
                      child: Text('seguridad rondas'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => QRViewExample(),
                          ),
                        );
                      },
                      child: Text('QR'),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Visitas", 
                      style: TextStyle(
                        fontSize: 20, 
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[900]
                      ),
                    ),
              
                    PopupMenuButton(
                      onSelected: (value) {
                        // ScreenGenerarVisita()
                        // print(value);
              
                        showModalBottomSheet(
                          context: context,
                          builder: (context) => ModalBottomCreateVisita(
                            cedula: '',
                            nombre: '',
                          ),
                        );
                      },
                      icon: Icon(Icons.add),
                      itemBuilder: (BuildContext context) {
                        return [
                          PopupMenuItem(
                            value: "Crear invitacion",
                            child: Text('Crear invitacion'),
                          ),
                        ];
                      },
              
                    ),
                  ],
                ),
              ),
              // SizedBox.square(dimension: 10.0),
              Card(
                margin: EdgeInsets.all(10.0),
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ScreenHistorialVisitas(),
                      ),
                    );
                  },
                  child: Column(
                    children: [
                      for (var visita in visitas.take(3))
                        ListTile(
                          title: Text('${visita.nombre} ${visita.apellido}'),
                          subtitle: Text('Fecha de visita: ${visita.fecha.toLocal()}'),
                        ),
                    ],
                  ),
                ),
              ),
              Divider(),

              
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Rondas", style: 
                  TextStyle(
                    fontSize: 20, 
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[900]),
                ),
              ),
              Card(
                margin: EdgeInsets.all(10.0),
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ScreenHistorialRondas(),
                      ),
                    );
                  },
                  child: Column(
                    children: [
                      for (var ronda in rondas.take(3))
                        ListTile(
                          title: Text('${ronda.nombre}'),
                          subtitle: Text('supervisor:${ronda.apellido} - Fecha: ${ronda.fecha.toLocal()}'),
                        ),
                    ],
                  ),
                ),
              ),
              Card(
                margin: EdgeInsets.all(10.0),
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ScreenHistorialVisitas(),
                      ),
                    );
                  },
                  child: Column(
                    children: [
                      for (var ronda in rondas.take(3))
                        ListTile(
                          title: Text('${ronda.nombre}'),
                          subtitle: Text('supervisor:${ronda.apellido} - Fecha: ${ronda.fecha.toLocal()}'),
                        ),
                    ],
                  ),
                ),
              )

            ],
          ),
        //   ScreenHistorialVisitas(),
        //   ScreenHistorialRondas(),
        // ][_selectedIndex],
      ),
    );
  }
}


class Visit {
  final String nombre;
  final String apellido;
  final DateTime fecha;

  Visit({
    required this.nombre,
    required this.apellido,
    required this.fecha,
  });
}