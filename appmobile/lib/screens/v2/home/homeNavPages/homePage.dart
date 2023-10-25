import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:sammseguridad_apk/page/PageInfoUrbaSeguridad.dart';
import 'package:sammseguridad_apk/provider/mainprovider.dart';
import 'package:sammseguridad_apk/provider/visitasProvider.dart';
// import 'package:sammseguridad_apk/screens/ScreenRondas.dart';
import 'package:sammseguridad_apk/screens/v2/home/homeNavPages/Rondas/Recorridos/MisRecorridos.dart';
import 'package:sammseguridad_apk/screens/widgets/ModalBottomCreateVisita.dart';
import 'package:sammseguridad_apk/services/ApiService.dart';
// import 'package:sammseguridad_apk/widgets/Drawer.dart';

class HomePage extends StatefulWidget {
  // final Function(int) setIndex;
  HomePage({
    // required this.setIndex,
    super.key
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late bool canedit = false;

    @override
  void initState() {
    super.initState();
    final apiservices = Provider.of<ApiService>(context, listen: false);
    final mainProvider = Provider.of<MainProvider>(context, listen: false);
    mainProvider.canedit().then((value) {
      setState(() {
        canedit = value;
      });
    });
   
  }



  @override
  Widget build(BuildContext context) {
    final visitasProvider = Provider.of<VisitasProvider>(context);
    if (!visitasProvider.hasFetchedData) {
      // print("pidiendo ");
      visitasProvider.refreshvisitas(context,visitasProvider);
      visitasProvider.hasFetchedData = true;
    }

    Future<List<Map<String, dynamic>>> visitas = Provider.of<VisitasProvider>(context).visitaListFuture;
    // final List<Visit> visitas = [
    //   Visit(nombre: 'Juan', apellido: 'Perez', fecha: DateTime(2023, 9, 15)),
    //   Visit(nombre: 'María', apellido: 'Gomez', fecha: DateTime(2023, 9, 10)),
    //   Visit(nombre: 'Pedro', apellido: 'Rodriguez', fecha: DateTime(2023, 9, 5)),
    // ];
    final List<Visit> rondas = [
      Visit(nombre: 'Urb. Pacho Salas', apellido: 'Pablo Cedeno', fecha: DateTime(2023, 9, 15)),
      Visit(nombre: 'Urb. Villas del rey', apellido: 'Pablo Cedeno', fecha: DateTime(2023, 9, 10)),
      Visit(nombre: 'Villas samanes', apellido: 'Pablo Cedeno', fecha: DateTime(2023, 9, 5)),
    ];



    // int _selectedIndex = 0;

    return Center(
      // child:         PuntosDelRecorrido(
      //     rondaNombre: "rondaNombre",
      //     rondaConcretaId: 1,
      //   ),
        // child:[
          child: ListView(
            children: [
              Container(
                height: 40,
                color: Colors.grey[200],
                child: Center(child: Text("Ubicacion - cuenta")),
              ),
              SizedBox.square(dimension: 10.0),
              
              // =====================================================
              canedit?
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
                          isScrollControlled: true,
                          context: context,
                          builder: (BuildContext context) {
                            return FractionallySizedBox(
                              heightFactor: 0.75, // Ajusta este valor según tus necesidades.
                              child: ModalBottomCreateVisita(
                                cedula: '',
                                nombre: '',
                                apellido: '',
                              ),
                            );
                          },
                          // builder: (context) => ModalBottomCreateVisita(
                          //   cedula: '',
                          //   nombre: '',
                          // ),
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
              // ),
              ):Container(),
              
              // SizedBox.square(dimension: 10.0),
              canedit?
              Card(
                margin: EdgeInsets.all(10.0),
                child: InkWell(
                  onTap: () {
                    // setIndex(1);
                    // Navigator.of(context).push(
                    //   MaterialPageRoute(
                    //     builder: (context) => ScreenHistorialVisitas(),
                    //   ),
                    // );
                  },
                  child: FutureBuilder<List<Map<String, dynamic>>>(
                    future: visitas, // Supongo que visitas es un Future<List<Map<String, dynamic>>>
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator(); // Muestra un indicador de carga mientras se espera la respuesta.
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else if (!snapshot.hasData) {
                        return Text('No hay datos disponibles.');
                      } else {
                        final visitasList = snapshot.data!; // Obtén la lista de visitas.
                        final primerasTresVisitas = visitasList.take(7); // Toma las primeras tres visitas.
                        // print(primerasTresVisitas);
                        return ListView(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(), // Evita el desplazamiento
                          children: [
                            for (var visita in primerasTresVisitas)
                              ListTile(
                                title: Text('${visita['ApellidosVisitante']?.toString() ?? 'N/A'} ${visita['NombresVisitante']?.toString() ?? 'N/A'}'),
                                subtitle: Text('FechaVisita: ${visita['FechaVisita']?.toString() ?? 'N/A'}'),
                              ),
                          ],
                        );
                      }
                    },
                  )

                  // child: Text("Visitas"),


                ),
              // ),
              ):Container(),
              

              Divider(),
              // =====================================================
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Recorridos", 
                      style: TextStyle(
                        fontSize: 20, 
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[900]
                      ),
                    ),
                  ],
                ),
              ),
              // SizedBox.square(dimension: 10.0),
              MisRecorridos(),
              // Container(
              //   child: MisRecorridos(),
              //   height: 200,
              // ),
              Divider(),
              // ElevatedButton(
              //   onPressed: () {
              //     Navigator.of(context).push(
              //       MaterialPageRoute(
              //         builder: (context) => PuntosConcretosScreen(
              //                                 rondaNombre: "rondaNombre",
              //                                 rondaConcretaId: 1,
              //                               ),
              //       ),
              //     );
              //   },
              //   child: Text("rondanombre y ronda 1"),
              
              // )
              // =====================================================

            ],
          )
        // ]
    );
  }
}

    // return Column(
    //   children:[
    //     Container(
    //       child: MisRecorridos(),
    //       height: 200,
    //     ),
    //   ]
    // );


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