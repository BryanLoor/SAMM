import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sammseguridad_apk/provider/rondasProvider.dart';
import 'package:sammseguridad_apk/services/ApiService.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NuevaRondaFormulario extends StatelessWidget {
  const NuevaRondaFormulario({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Center(
              child: Text(
                'Crear nueva ronda',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[900]),
              ),
            ),
            Formulario_crea_Ronda(),
          ],
        ),
      ),
    );
  }
}

class Formulario_crea_Ronda extends StatefulWidget {
  @override
  _Formulario_crea_RondaState createState() => _Formulario_crea_RondaState();
}

class _Formulario_crea_RondaState extends State<Formulario_crea_Ronda> {
  final TextEditingController _fechaInicioController = TextEditingController();
  final TextEditingController _fechaFinalController = TextEditingController();
  final TextEditingController _diasController = TextEditingController();
  String selectedFrecuencia = "Diario";
  int selectedLocation = 1;
  bool needDia = false;
  bool rangoFechaValido = false;

  TextEditingController descriptionController = TextEditingController();
  List<Map<String, dynamic>> locations = [];
  List<String> frecuencias = ["Diario", "Semanal", "Mensual", "Dias Laborales"];

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (locations.isEmpty) {
      // Realiza la llamada a getRondaUbicaciones solo si la lista está vacía.
      RondasProvider rondasProvider = Provider.of<RondasProvider>(context);
      ApiService apiService = Provider.of<ApiService>(context);

      rondasProvider.getRondaUbicaciones(apiService).then((ubicaciones) {
        setState(() {
          locations = ubicaciones;
        });
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    String formattedDate =
        DateFormat('yyyy-MM-dd').format(DateTime.now().toLocal());

    _fechaInicioController.text = formattedDate;
    _fechaFinalController.text = formattedDate;
    _diasController.text = "";
  }

  @override
  Widget build(BuildContext context) {
    RondasProvider rondasProvider = Provider.of<RondasProvider>(context);
    ApiService apiService = Provider.of<ApiService>(context);
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Row(
                  children: [
                    Text(
                      "Fecha icicial\n${_fechaInicioController.text}",
                      style: const TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                        onPressed: () {
                          _selectDatePicker(_fechaInicioController);
                        },
                        icon: const Icon(
                          Icons.calendar_month_outlined,
                          color: Colors.black,
                        ))
                  ],
                ),
                Row(
                  children: [
                    Text(
                      "Fecha final\n${_fechaFinalController.text}",
                      style: const TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                        onPressed: () {
                          _selectDatePicker(_fechaFinalController);
                        },
                        icon: const Icon(
                          Icons.calendar_month_outlined,
                          color: Colors.black,
                        ))
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField(
                    decoration: InputDecoration(
                    
                        label: Text(
                      "Frecuencia",
                    )),
                    value:
                        selectedFrecuencia == "" ? "Diario" : selectedFrecuencia,
                    items: frecuencias.map((_frecuencia) {
                      return DropdownMenuItem(
                        value: _frecuencia,
                        child: Text(_frecuencia),
                      );
                    }).toList(),
                    hint: const Text('Selecciona una frecuencia'),
                    onChanged: (value) {
                      setState(() {
                        selectedFrecuencia = value as String;
                        if (selectedFrecuencia == "Diario" ||
                            selectedFrecuencia == "Dias Laborales") {
                          _diasController.text = "";
                          needDia = false;
                        } else
                          needDia = true;
                      });
                      print(selectedFrecuencia);
                    },
                  ),
                ),
                needDia
                    ? IconButton(
                        onPressed: () => _selectDay(_diasController),
                        icon: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text("Dia de la semana"),
                            Icon(Icons.calendar_month_outlined),
                            Text(_diasController.text)
                          ],
                        ))
                    : SizedBox(
                        width: 0,
                      )
              ],
            ),
            Form(
              key: _formKey,
              child: TextFormField(
                controller: descriptionController,
                decoration: const InputDecoration(labelText: 'Descripción'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Campo requerido';
                  }
                  return null;
                },
              ),
            ),
            
            const SizedBox(height: 20),
            DropdownButtonFormField(
              value: selectedLocation,
              items: locations.map((location) {
                return DropdownMenuItem(
                  value: location['id'],
                  child: Text(location['descripcion']),
                );
              }).toList(),
              hint: const Text('Selecciona una ubicación'),
              onChanged: (value) {
                setState(() {
                  selectedLocation = value as int;
                });
              },
            ),
            Container(
              margin: EdgeInsets.only(top: 20),
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[900],
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                onPressed: rangoFechaValido &&
                        _formKey.currentState?.validate() == true && ((needDia==false && _diasController.text=="")|| (needDia==true && _diasController.text!=""))
                    ? () async {
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (context) => const CircularProgressIndicator(),
                        );
    
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        // int userId = prefs.getInt('userId');
                        await rondasProvider.enviarNuevaRonda(
                            apiService,
                            prefs.getInt('Id') ?? 0,
                            selectedLocation,
                            descriptionController.text,
                            _fechaInicioController.text,
                            _fechaFinalController.text,
                            selectedFrecuencia.toUpperCase(),
                            _diasController.text.toUpperCase());
                        Navigator.pop(context);
                        Navigator.pop(context);
                        // show snackbar
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Ronda creada correctamente'),
                            backgroundColor: Colors.green,
                          ),
                        );
                      }
                    : null,
                child: const Text('Enviar'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _selectDay(TextEditingController? controller) {
    List<String> days = [
      "Lunes",
      "Martes",
      "Miercoles",
      "Jueves",
      "Viernes",
      "Sabado",
      "Domingo"
    ];

    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Center(
            child: Text(
              "Escoger día de la semana",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[900]),
            ),
          ),
          content: Container(
            alignment: Alignment.center,
            width: double.maxFinite, // Set width to take the full width
            height: MediaQuery.of(context).size.height * 0.08,
            child: ListView(
              //shrinkWrap: true, // Allow the ListView to take only the space it needs
              scrollDirection: Axis.horizontal,
              children: days.map((day) {
                return GestureDetector(
                  child: Container(
                      padding: EdgeInsets.all(8),
                      margin: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.blue[900],
                          border: Border.all(
                              strokeAlign: 0.1,
                              width: 1,
                              color: Colors.transparent)),
                      child: Center(
                          child: Text(
                        day,
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w500,color: Colors.white),
                      ))),
                  onTap: () {
                    setState(() {
                      _diasController.text = day;
                    });

                    // You can update your controller or perform any other action here
                    Navigator.of(context).pop(); // Close the dialog
                  },
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }

  Future<void> _selectDatePicker(TextEditingController controller) async {
    DateTime selectedDate = DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        String formattedDate = DateFormat('yyyy-MM-dd').format(picked);
        controller.text = formattedDate;
        // Calcula la diferencia de tiempo entre las dos fechas
        Duration diferencia = DateTime.parse(_fechaFinalController.text)
            .difference(DateTime.parse(_fechaInicioController.text));

        // Obtiene el número de días de la diferencia
        int cantidadDias = diferencia.inDays;
        if (cantidadDias > 365) {
          controller.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
          ;
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text("No puede exceder una planificacion anual"),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Ok'),
                  ),
                ],
              );
            },
          );
          rangoFechaValido = false;
        } else
          rangoFechaValido = true;
      });
    }
  }
}
