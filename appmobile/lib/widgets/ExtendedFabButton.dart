import 'package:flutter/material.dart';

class ExtendedFabButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 6.0,
      borderRadius: BorderRadius.circular(28.0),
      child: Container(
        width: 120, // Ancho fijo para que no se expandan en vertical
        child: FloatingActionButton.extended(
          onPressed: () {
            // Acción cuando se hace clic en el botón
            print('Botón presionado');
          },
          label: Text('Botón'),
          icon: Icon(Icons.star), // Cambia esto por el icono que desees
        ),
      ),
    );
  }
}