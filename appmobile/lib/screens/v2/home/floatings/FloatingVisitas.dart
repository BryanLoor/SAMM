import 'package:flutter/material.dart';
import 'package:sammseguridad_apk/screens/widgets/ModalBottomCreateVisita.dart';

class FloatingVisitas extends StatelessWidget {
  const FloatingVisitas({
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
      label: Row(
        children: [
          Icon(Icons.car_crash_rounded),
          Icon(Icons.add),
        ],
      ), // Icono del botón principal
    );
  }
}