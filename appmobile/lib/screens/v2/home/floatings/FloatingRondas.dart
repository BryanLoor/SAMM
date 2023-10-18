import 'package:flutter/material.dart';
import 'package:sammseguridad_apk/screens/v2/home/homeNavPages/Rondas/NuevaRondaFormulario.dart';

class FloatingRondas extends StatelessWidget {
  const FloatingRondas({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
        backgroundColor: Colors.blue[900],
      foregroundColor: Colors.white,
      onPressed: () {
        showModalBottomSheet(
          isScrollControlled: true,
          context: context,
          builder: (BuildContext context) {
            return FractionallySizedBox(
              heightFactor: 0.75, // Ajusta este valor según tus necesidades.
              child: NuevaRondaFormulario()
            );
          },
          // builder: (context) => ModalBottomCreateVisita(
          //   cedula: '',
          //   nombre: '',
          // ),
        );
      },
      label: Row(
        children: [
          Icon(Icons.route_rounded),
          Icon(Icons.add),
        ],
      ),
      // child: Center(
      //   child: Row(
      //     children: [
      //       Icon(Icons.route_rounded),
      //       Icon(Icons.add),
      //     ],
      //   )
      // ), // Icono del botón principal
    );
  }
}

