import 'package:flutter/material.dart';

class TwoColumnsWidget extends StatelessWidget {
  final List<Widget> listaDeWidgets;
  final double midSpace;

  const TwoColumnsWidget({
    Key? key,
    required this.listaDeWidgets,
    this.midSpace = 10.0, // Valor predeterminado para midSpace
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> column1Widgets = [];
    List<Widget> column2Widgets = [];

    for (int i = 0; i < listaDeWidgets.length; i++) {
      if (i % 2 == 0) {
        column1Widgets.add(listaDeWidgets[i]);
      } else {
        column2Widgets.add(listaDeWidgets[i]);
      }
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 1,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,

            children: column1Widgets,
          ),
        ),
        SizedBox.square(dimension: midSpace),
        Expanded(
          flex: 1,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: column2Widgets,
          ),
        ),
      ],
    );
  }
}