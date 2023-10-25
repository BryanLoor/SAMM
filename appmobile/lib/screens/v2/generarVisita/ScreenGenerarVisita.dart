import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:sammseguridad_apk/provider/mainprovider.dart';
import 'package:sammseguridad_apk/provider/visitasProvider.dart';
import 'package:sammseguridad_apk/services/ApiService.dart';
import 'package:sammseguridad_apk/widgets/Appbar.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

class ScreenGenerarVisita extends StatefulWidget {
  String widgetCedula;
  String widgetNombre;
  String widgetApellido;
  
  var parentKey;

  ScreenGenerarVisita(
      {required this.widgetCedula,
      required this.widgetNombre,
      required this.widgetApellido,
      this.parentKey,
      Key? key})
      : super(key: key);

  @override
  _ScreenGenerarVisitaState createState() => _ScreenGenerarVisitaState();
}

String token = "";

class _ScreenGenerarVisitaState extends State<ScreenGenerarVisita> {
  final _screenshotController = ScreenshotController();

  bool cedulaIsFiled = false;
  final _formKey = GlobalKey<FormState>();
  String stateCedula = '';
  String stateNombre = '';
  String stateApellido = '';
  String idVisitanteEncontrado = '';
  Map<String, dynamic> visitanteEncontrado = {};
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  TextEditingController placaController = TextEditingController();

  String _qrData = "";

  static const _fontSize = 20.0;
  static const _paddingSize = 15.0;
  static const _buttonFontSize = 18.0;
  static const _sizedBoxHeight = 10.0;
  late List<dynamic> ubicaciones = [];
  late List<dynamic> resultadosBusqueda = [];
  final ApiService _apiService = ApiService();

  TextStyle estiloAzul = TextStyle(
      fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue[900]);
  ButtonStyle estiloboton = ElevatedButton.styleFrom(
    primary: Colors.blue[900],
    onPrimary: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8.0),
    ),
  );

  bool _obscureText = true;

  TextEditingController cedulaController = TextEditingController();
  TextEditingController busquedaController = TextEditingController();
  TextEditingController ubicacionController = TextEditingController();
  Map<String, dynamic> ubicacionSelected = {};

  Future<void> getUbicaciones() async {
    try {
      final token = MainProvider.prefs.getString('token');
      print(token);
      const String url = "/visitas/getUbicaciones";
      String response = await _apiService.getDataJson(url, token!);

      setState(() {
        ubicaciones = jsonDecode(response);
      });
    } catch (e) {
      print('Error al obtener datos: $e');
    }
  }

  Future<void> consultarExisteVisitante(String cedulaNombre) async {
    try {
      String url = "/visitas/getPersonaByCED_and_NAME/$cedulaNombre";
      String response = await _apiService.getDataJson(url, "");
      setState(() {
        resultadosBusqueda = jsonDecode(response)["data"];
        //ubicaciones = jsonDecode(response);
      });
    } catch (e) {
      setState(() {
        resultadosBusqueda = [];
      });
      print('Error al obtener datos: $e');
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    busquedaController.dispose();
  }

  @override
  void initState() {
    super.initState();
    stateCedula = widget.widgetCedula;
    stateNombre = widget.widgetNombre;
    stateApellido = widget.widgetApellido;
    ubicacionSelected = {};
    ubicaciones = [];
    if (stateCedula.length != 10 ||
        !RegExp(r'^[0-9]+$').hasMatch(stateCedula)) {
      cedulaIsFiled = false;
    } else {
      cedulaIsFiled = true;
    }
    // cedulaController.text = widget.cedula;
    final mainProviderSave = Provider.of<MainProvider>(context, listen: false);

    mainProviderSave.getPreferencesToken().then((dataToken) {
      setState(() {
        token = dataToken.toString();
        mainProviderSave.updateToken(token);
      });
    });
    getUbicaciones().then((value) => {
      print(ubicaciones),

          setState(() {
            ubicacionSelected = ubicaciones[0];
          })
        });
  }



  GlobalKey _qrKey = GlobalKey();


  Future<void> _shareQRCode(
      MainProvider mainProvider, ApiService apiService) async {
    // if (_formKey.currentState!.validate()) {
    String formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate);
    //String formattedTime = DateFormat.Hm().format(DateTime.now());
    String formattedTime = '${selectedTime.hour}:${selectedTime.minute}';

    //poner en qr ID de registro
    //String qrData ='${DateFormat('dd/MM/yyyy').format(selectedDate)},${selectedTime.format(context)},${selectedTime},${stateCedula},${stateNombre},${placaController.text}';
    //String qrData =visitanteEncontrado["Id"].toString();
    String qrData = _qrData;
    Map<String, dynamic> data = {
      'date': formattedDate,
      'time': formattedTime,
      'duration': 100,
      'cedula': stateCedula,
      'nameVisitante': stateNombre,
      'idUbicacion': ubicacionSelected["Id"],
      'lastNameVisitante': stateApellido,
      //'idAnfitrion': mainProvider.response['Id'],
      'idAnfitrion': MainProvider.prefs.getInt("Id"),
      'idVisitante': visitanteEncontrado["IdPersona"],
      'antecedentes': 0,
      'phone': visitanteEncontrado["Cel_Persona"] ?? "9999999999",
      'email': visitanteEncontrado["Correo_Personal"] ?? "correo@ejemplo.com",
      'observaciones': "0000",
      // 'lastName': _lastNameController.text,
      'placa': placaController.text,
    };
    try {
      await apiService
          .postData('/visitas/registraVisita', data, token)
          .then((value) => {
                qrData = value["idVisita"].toString(),
              
              });
    } catch (e) {
      print('Failed to post data: $e');
    }

    setState(() {
      _qrData = qrData;
      
    });
  
    // ignore: use_build_context_synchronously
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                RepaintBoundary(
                  key: _qrKey,
                  child: Container(
                    child: BarcodeWidget(
                      // key: _qrKey,
                      barcode: Barcode.qrCode(),
                      data: qrData,
                      width: 200,
                      height: 200,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text('Datos de la invitación:',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          ListTile(
                            leading: const Icon(Icons.credit_card),
                            title: const Text('Cédula'),
                            subtitle: Text(stateCedula),
                          ),
                          ListTile(
                            leading: const Icon(Icons.person),
                            title: const Text('Nombres'),
                            subtitle: Text('$stateNombre $stateApellido'),
                          ),
                          ListTile(
                            leading: const Icon(Icons.calendar_today),
                            title: const Text('Fecha'),
                            subtitle: Text(
                                DateFormat('yyyy-MM-dd').format(selectedDate)),
                          ),
                          ListTile(
                            leading: const Icon(Icons.directions_car),
                            title: const Text('Placa'),
                            subtitle: Text(placaController.text),
                          ),
                          ListTile(
                            leading: const Icon(Icons.access_time),
                            title: const Text('Hora'),
                            subtitle: Text(formattedTime),
                          ),
                          ListTile(
                            leading: const Icon(Icons.timer),
                            title: const Text('Duración'),
                            subtitle: Text('$selectedTime horas'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            Container(
              width: MediaQuery.of(context).size.width,
              color: Colors.blue[900],
              child: IconButton(
                icon: const Icon(Icons.share, color: Colors.white),
                onPressed: () async {
                  _shareQRImageScreen(
                      context: context,
                      qrWidget: Container(
                        color: Colors.white,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 20),
                                child: Image.asset(
                                  width: 100,
                                    height: 100,
                                    'assets/images/SAMM.png'),
                              ),
                               Container(
                                  color: Colors.white,
                                 padding: const EdgeInsets.only(left: 10,right: 10),
                                 child: Text( 
                                  "Te da la bienvenida $stateNombre $stateApellido!",
                                  textAlign: TextAlign.center,
                                  style:
                                      const TextStyle(color: Colors.black, fontSize: 30),
                                                           ),
                               ),
                              const SizedBox(height: 100),
                              QrImageView(
                                data: qrData,
                                version: QrVersions.auto,
                                size: 280.0,
                                gapless: false,
                                backgroundColor: Colors.white,
                                dataModuleStyle: const QrDataModuleStyle(
                                    color: Colors.black,
                                    dataModuleShape: QrDataModuleShape.square),
                                errorStateBuilder: (context, error) {
                                  return const Center(
                                    child: Text(
                                      "Error al generad el qr",
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  );
                                },
                              ),
                              const SizedBox(height: 40),
                              const Text(
                                "Verificado por",
                                style:
                                    TextStyle(color: Colors.black, fontSize: 20,fontStyle: FontStyle.italic),
                              ),
                      
                              //Text(""),
                            ],
                          ),
                        ),
                      ));
                },
              ),
            ),
          ],
        );
      },
    );

  }

  Future<void> _shareQRImageScreen(
      {required BuildContext context, required Widget qrWidget}) async {
    final qrBox = context.findRenderObject() as RenderBox;
    _screenshotController
        .captureFromWidget(qrWidget)
        .then((Uint8List bytes) async {
      final Directory dir = await getApplicationSupportDirectory();
      final String ts = DateTime.now().millisecondsSinceEpoch.toString();

      final String filePath = '${dir.path}/$ts.png';
      XFile? xFile = XFile.fromData(bytes);
      await xFile.saveTo(filePath);
      //await XFile.fromData(bytes).saveTo(filePath);

      await Share.shareXFiles(
        [XFile(filePath)],
        text: "QR generado",
        sharePositionOrigin: qrBox.localToGlobal(Offset.zero) & qrBox.size,
      );
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    TimeOfDay currentTime = TimeOfDay.now();

    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
          child: child!,
        );
      },
    );

    if (picked != null && picked != selectedTime) {
      // Verifica si la hora seleccionada es posterior a la hora actual
      if (picked.hour > currentTime.hour ||
          (picked.hour == currentTime.hour &&
              picked.minute > currentTime.minute)) {
        setState(() {
          selectedTime = picked;
        });
      } else {
        // Muestra un mensaje o realiza alguna acción para indicar que la hora seleccionada no es válida
        // ignore: use_build_context_synchronously
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Hora no válida'),
              content: const Text('Selecciona una hora posterior a la actual.'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      }
    }
  }

  void _editField(String fieldName) {
    // Mostrar un ModalBottomSheet para editar el campo seleccionado
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              ListTile(
                title: Text('Editar $fieldName'),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  decoration: InputDecoration(
                    labelText: '$fieldName',
                  ),
                  onChanged: (value) {
                    setState(() {
                      if (fieldName == 'Cédula') {
                        stateCedula = value;
                      } else if (fieldName == 'Nombre') {
                        stateNombre = value;
                      } else if (fieldName == 'Apellido') {
                        stateApellido = value;
                      }
                    });
                  },
                ),
              ),
              ElevatedButton(
                style: estiloboton,
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Guardar'),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDropListUbicacion() {
    if(ubicacionSelected.isEmpty) getUbicaciones();
    return DropdownButtonFormField(
      padding: const EdgeInsets.all(10),
      decoration: const InputDecoration(
        filled: true,
        //fillColor: Colors.white,
      ),
      //value: _nombreSalonController.text.isNotEmpty?_nombreSalonController.text:"Seleccione Salon...",
      hint: Text(
        ubicaciones.isNotEmpty ? ubicaciones[0]["Descripcion"] : "",
        style: const TextStyle(color: Colors.black),
      ),
      //dropdownColor: Colors.white,
      borderRadius: const BorderRadius.only(
          bottomRight: Radius.circular(20), bottomLeft: Radius.circular(20)),
      //iconEnabledColor: Colors.black,
      items: ubicaciones.map((item) {
        return DropdownMenuItem(
          value: item["Descripcion"],
          child: Text(
            item["Descripcion"] ?? "",
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: Colors.black),
          ),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          ubicacionController.text = value.toString();
          int selectedIndex =
              ubicaciones.indexWhere((item) => item["Descripcion"] == value);
          ubicacionSelected = ubicaciones[selectedIndex];
        });
      },
      isDense: true,
      isExpanded: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    final mainProvider = Provider.of<MainProvider>(context, listen: false);
    final apiService = Provider.of<ApiService>(context, listen: false);
    // return Scaffold(
    //   appBar: CustomAppBar(),
    //   body: Padding(
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListView(
          children: [
            Center(
              child: Text(
                'Invitar a un visitante',
                style: estiloAzul,
              ),
            ),
            const SizedBox(height: 16.0),
            if (!cedulaIsFiled) ...[
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                      10.0), // Ajusta el valor para redondear más o menos
                  color: Colors.white, // Color de fondo opcional
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: TextFormField(
                    //keyboardType: TextInputType.text,
                    controller: busquedaController,
                    decoration: const InputDecoration(
                      hintText: 'Buscar por cedula o nombre',
                      border: InputBorder.none,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, coloque su Cedula o Nombre';
                      }
                      return null;
                    },
                  ),
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[900],
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  onPressed: () async {
                    consultarExisteVisitante(busquedaController.text)
                        .then((value) => {
                              if (resultadosBusqueda.isEmpty)
                                {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: const Text(
                                            'Busqueda no encontrada',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          content: const Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                '¿Desea continuar?',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 20),
                                              ),
                                              Text(
                                                  'Si continua debe ingresar una cédula válida para registrar visitante'),
                                            ],
                                          ),
                                          actions: <Widget>[
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: const Text('No'),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                showDialog(
                                                  context: context,
                                                  builder: (context) {
                                                    return AlertDialog(
                                                      title: const Text(
                                                        'Ingrese cédula válida.',
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      content: TextFormField(
                                                        keyboardType:
                                                            TextInputType
                                                                .number,
                                                        controller:
                                                            cedulaController,
                                                        onChanged: (value) {
                                                          stateCedula = value;
                                                        },
                                                      ),
                                                      actions: <Widget>[
                                                        TextButton(
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                          child: const Text(
                                                              'Cancelar'),
                                                        ),
                                                        TextButton(
                                                          onPressed: () {
                                                            if (stateCedula
                                                                        .length !=
                                                                    10 ||
                                                                !RegExp(r'^[0-9]+$')
                                                                    .hasMatch(
                                                                        stateCedula)) {
                                                              // Si la cédula no tiene 10 dígitos o no son todos números, muestra un mensaje de error
                                                              showDialog(
                                                                context:
                                                                    context,
                                                                builder:
                                                                    (context) {
                                                                  return AlertDialog(
                                                                    title:
                                                                        const Text(
                                                                      'Error de Cédula',
                                                                      style: TextStyle(
                                                                          fontWeight:
                                                                              FontWeight.bold),
                                                                    ),
                                                                    content:
                                                                        const Text(
                                                                            'La cédula debe tener 10 dígitos.'),
                                                                    actions: <Widget>[
                                                                      TextButton(
                                                                        onPressed:
                                                                            () {
                                                                          Navigator.of(context)
                                                                              .pop();
                                                                        },
                                                                        child: const Text(
                                                                            'OK'),
                                                                      ),
                                                                    ],
                                                                  );
                                                                },
                                                              );
                                                            } else {
                                                              setState(() {
                                                                stateCedula =
                                                                    cedulaController
                                                                        .text;
                                                                cedulaIsFiled =
                                                                    true;
                                                              });
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            }
                                                          },
                                                          child:
                                                              const Text('OK'),
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                );
                                              },
                                              child: const Text('Si'),
                                            ),
                                          ],
                                        );
                                      })
                                }
                            });
                  },
                  child: const Text(
                    'Buscar',
                    style: TextStyle(fontSize: 18.0),
                  ),
                ),
              ),
              Container(
                height: 500,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                      10.0), // Ajusta el valor para redondear más o menos
                  //color: Colors.blue[100], // Color de fondo opcional
                ),
                child: ListView.builder(
                  itemCount: resultadosBusqueda.length,
                  itemBuilder: (context, index) {
                    String nombre =
                        (resultadosBusqueda[index]["Nombres"] ?? "") +
                            " " +
                            (resultadosBusqueda[index]["Apellidos"] ?? "");
                    return Container(
                      margin: const EdgeInsets.only(left: 20, right: 20),
                      decoration: const BoxDecoration(
                          border:
                              Border(bottom: BorderSide(color: Colors.blue))),
                      child: ListTile(
                        onTap: () {
                          setState(() {
                            cedulaController.text =
                                resultadosBusqueda[index]["Cedula"];
                            stateNombre =
                                resultadosBusqueda[index]["Nombres"] ?? "";
                            stateApellido =
                                resultadosBusqueda[index]["Apellidos"] ?? "";
                            //idVisitanteEncontrado = resultadosBusqueda[index]["IdPersona"];
                            visitanteEncontrado = resultadosBusqueda[index];
                            busquedaController.text =
                                resultadosBusqueda[index]["Cedula"];
                            setState(() {
                              stateCedula = resultadosBusqueda[index]["Cedula"];
                              cedulaIsFiled = true;
                            });
                          });
                        },
                        title: Text(nombre,
                            style: const TextStyle(color: Colors.black)),
                        subtitle: Text(
                            'CI:${resultadosBusqueda[index]["Cedula"] ?? ""}',
                            style: const TextStyle(color: Colors.black)),
                      ),
                    );
                  },
                ),
              ),
            ] else ...[
              Card(
                child: Column(
                  children: [
                    const Center(
                        child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Icon(Icons.person),
                    )),
                    const Center(child: Text("invitar a:")),
                    Center(child: Text('$stateNombre $stateApellido')),
                    Center(child: Text(stateCedula)),
                  ],
                ),
              ),
              _buildDropListUbicacion(),
              ListTile(
                title: const Text('Nombres *'),
                subtitle: Text(stateNombre),
                trailing: IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    _editField('Nombre');
                  },
                ),
              ),
              ListTile(
                title: const Text('Apellidos *'),
                subtitle: Text(stateApellido),
                trailing: IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    _editField('Apellido');
                  },
                ),
              ),
              ListTile(
                title: const Text('Fecha de Visita'),
                subtitle: Text("${selectedDate.toLocal()}".split(' ')[0]),
                trailing: IconButton(
                  icon: const Icon(Icons.calendar_today),
                  onPressed: () {
                    _selectDate(context);
                  },
                ),
              ),
              ListTile(
                title: const Text('Hora de Ingreso'),
                subtitle: Text(selectedTime.format(context)),
                trailing: IconButton(
                  icon: const Icon(Icons.access_time),
                  onPressed: () {
                    _selectTime(context);
                  },
                ),
              ),
              ListTile(
                title: const Text('Placa'),
                subtitle: TextField(
                  controller: placaController,
                  decoration: const InputDecoration(
                    hintText: 'Ej. ABC-123',
                  ),
                ),
              ),
              ElevatedButton.icon(
                  onPressed: stateNombre.length > 1 && ubicacionSelected.isNotEmpty
                      ? () {
                          _shareQRCode(mainProvider, apiService);
                          setState(() {
                            VisitasProvider().visitaListFuture=VisitasProvider().getVisitaList(apiService);

                          });
                        }
                      : null,
                  icon: const Icon(Icons.filter_center_focus),
                  label: const Text('Invitar'),
                  style: estiloboton),
            ],
          ],
        ),
      ),
    );
    // );
  }
}
