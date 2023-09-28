import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sammseguridad_apk/screens/v2/generarVisita/maps/mapsview.dart';

class RondasPage extends StatelessWidget {
  const RondasPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ElevatedButton(
          onPressed: () {
            // MaterialPageRoute(builder: (context) => MapSample());
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MapView()),
            );
          },
          child: Text('iniciar mapa'),
        
        ),
      ],
    );
  }
}