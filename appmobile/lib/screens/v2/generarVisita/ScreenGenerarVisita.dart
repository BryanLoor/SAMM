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
import 'package:sammseguridad_apk/provider/mainprovider.dart';
import 'package:sammseguridad_apk/services/ApiService.dart';
import 'package:sammseguridad_apk/widgets/Appbar.dart';


class ScreenGenerarVisita extends StatefulWidget {
  String cedula;
  String nombre;
  ScreenGenerarVisita({
    required this.cedula,
    required this.nombre,
    Key? key
  }) : super(key: key);

  @override
  _ScreenGenerarVisitaState createState() => _ScreenGenerarVisitaState();
}

String token = "";

class _ScreenGenerarVisitaState extends State<ScreenGenerarVisita> {
  final _formKey = GlobalKey<FormState>();
  String cedula = '123456789';
  String nombre = 'John Doe';
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  TextEditingController placaController = TextEditingController();

  String _qrData = "";

  // Map<String, dynamic> dataToSend = {
  //   'date': DateFormat('yyyy-MM-dd').format(DateTime.now()),
  //   'time': DateFormat.Hm().format(DateTime.now()),
  //   'duration': 20,
  //   'cedula': "0000000000",
  //   'nameVisitante': "Guest",
  //   'idUbicacion': 1,
  //   'lastNameVisitante': "Guest",
  //   'idAnfitrion': "0000000000",
  //   'idVisitante': 0,
  //   'antecedentes': 0,
  //   'phone': "N/A",
  //   'email': "N/A",
  //   'observaciones': "N/A",
    
  //   // 'lastName': _lastNameController.text,
  //   'placa': "N/A",
  // };

  @override
  void initState() {
    super.initState();
    cedula = widget.cedula;
    nombre = widget.nombre;
    final mainProviderSave = Provider.of<MainProvider>(context, listen: false);

    mainProviderSave.getPreferencesToken().then((dataToken) {
      setState(() {
        token = dataToken.toString();
        mainProviderSave.updateToken(token);
      });
    });
  }

  void _shareQRData(String qrData, String imagePath) async {
    await FlutterShare.shareFile(
      title: 'Compartir QR',
      text: 'Aquí está tu código QR y sus datos:\n$qrData',
      filePath: imagePath, // Pass string directly here.
      chooserTitle: 'Compartir con...',
    );
  }

  void _copyQRDataToClipboard(String qrData) {
    Clipboard.setData(ClipboardData(text: qrData));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('QR data copied to clipboard')),
    );
  }

  GlobalKey _qrKey = GlobalKey();

  Future<String> _downloadQRCode(GlobalKey qrKey) async {
    RenderRepaintBoundary boundary =
        qrKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
    var image = await boundary.toImage();
    ByteData? byteData = await image.toByteData(format: ImageByteFormat.png);
    Uint8List pngBytes = byteData!.buffer.asUint8List();

    // Guarda la imagen en el directorio temporal del dispositivo
    final directory = await getTemporaryDirectory();
    final imagePath = '${directory.path}/qr_code.png';
    File imageFile = File(imagePath);
    await imageFile.writeAsBytes(pngBytes);

    return imageFile.path; // Retorna la ruta de la imagen
  }

  void _sendQRCodeByEmail(String qrData) {
    // TODO: Implement send by email functionality
    // You can use a package like 'url_launcher' to open the email client with pre-filled data
  }


  Future<void> _generateQRCode(
      MainProvider mainProvider, ApiService apiService) async {
    // if (_formKey.currentState!.validate()) {
      String formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate);
      String formattedTime = DateFormat.Hm().format(DateTime.now());
      String qrData =
          // '${DateFormat('dd/MM/yyyy').format(_selectedDate)},${_selectedTime.format(context)},${_selectedDuration},${_idController.text},${_nameController.text},${_lastNameController.text},${_plateController.text}';
          '${DateFormat('dd/MM/yyyy').format(selectedDate)},${selectedTime.format(context)},${selectedTime},${cedula},${nombre},${placaController.text}';

      Map<String, dynamic> data = {
        'date': formattedDate.toString(),
        'time': formattedTime.toString(),
        'duration': 100,
        'cedula': cedula,
        'nameVisitante': nombre.split("")[0],
        'idUbicacion': 1,
        'lastNameVisitante': nombre.split("")[1],
        'idAnfitrion': mainProvider.response['Id'],
        'idVisitante': 0,
        'antecedentes': 0,
        'phone': "0000",
        'email': "0000",
        'observaciones': "0000",
        
        // 'lastName': _lastNameController.text,
        'placa': placaController.text,
      };

      try {
        print('Data: $data');
        var response =
            await apiService.postData('/visitas/registraVisita', data, token);
        print('Data: $data');

        print(response);
      } catch (e) {
        print('Failed to post data: $e');
      }

      setState(() {
        _qrData = qrData;
      });

      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    child: BarcodeWidget(
                      key: _qrKey,
                      barcode: Barcode.qrCode(),
                      data: qrData,
                      width: 200,
                      height: 200,
                    ),
                  ),
                  SizedBox(height: 16),
                  Text('Datos de la invitación:',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            ListTile(
                              leading: Icon(Icons.credit_card),
                              title: Text('Cédula'),
                              subtitle: Text(cedula),
                            ),
                            ListTile(
                              leading: Icon(Icons.person),
                              title: Text('Nombres'),
                              subtitle: Text(nombre),
                            ),
                            ListTile(
                              leading: Icon(Icons.calendar_today),
                              title: Text('Fecha'),
                              subtitle: Text(DateFormat('yyyy-MM-dd')
                                  .format(selectedDate)),
                            ),
                            ListTile(
                              leading: Icon(Icons.directions_car),
                              title: Text('Placa'),
                              subtitle: Text(placaController.text),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            // ListTile(
                            //   leading: Icon(Icons.person),
                            //   title: Text('Apellidos'),
                            //   subtitle: Text(_lastNameController.text),
                            // ),
                            ListTile(
                              leading: Icon(Icons.access_time),
                              title: Text('Hora'),
                              subtitle:
                                  Text(DateFormat.Hm().format(DateTime.now())),
                            ),
                            ListTile(
                              leading: Icon(Icons.timer),
                              title: Text('Duración'),
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
              IconButton(
                icon: Icon(Icons.share),
                onPressed: () async {
                  var imagePath = await _downloadQRCode(_qrKey);
                  _shareQRData(qrData, imagePath);
                },
              ),
              IconButton(
                icon: Icon(Icons.copy),
                onPressed: () => _copyQRDataToClipboard(qrData),
              ),
              IconButton(
                icon: Icon(Icons.download),
                onPressed: () async {
                  var status = await Permission.photos.status;
                  if (!status.isGranted) {
                    status = await Permission.photos.request();
                  }
                  if (status.isGranted) {
                    _downloadQRCode(_qrKey);
                  } else {
                    print("Permission denied.");
                  }
                },
              ),
              IconButton(
                icon: Icon(Icons.email),
                onPressed: () => _sendQRCodeByEmail(qrData),
              ),
            ],
          );
        },
      );
    // }
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
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null && picked != selectedTime) {
      setState(() {
        selectedTime = picked;
      });
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
                padding: EdgeInsets.all(16.0),
                child: TextField(
                  decoration: InputDecoration(
                    labelText: '$fieldName',
                  ),
                  onChanged: (value) {
                    setState(() {
                      if (fieldName == 'Cédula') {
                        cedula = value;
                      } else if (fieldName == 'Nombre') {
                        nombre = value;
                      }
                    });
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final mainProvider = Provider.of<MainProvider>(context, listen: false);
    final apiService = Provider.of<ApiService>(context, listen: false);
    return Scaffold(
      appBar: CustomAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListView(
          children: [
            Card(
              child: Column(
                children: [
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(Icons.person),
                    )
                  ),
                  Center(
                    child: Text("invitar a:")
                  ),
                  Center(
                    child: Text(nombre)
                  ),
                  Center(
                    child: Text(cedula)
                  ),
                ],
              ),
            ),
            // ListTile(
            //   title: Text('Cédula'),
            //   subtitle: Text(cedula),
            //   // trailing: IconButton(
            //   //   icon: Icon(Icons.edit),
            //   //   onPressed: () {
            //   //     _editField('Cédula');
            //   //   },
            //   // ),
            // ),
            ListTile(
              title: Text('Nombre'),
              subtitle: Text(nombre),
              trailing: IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {
                  _editField('Nombre');
                },
              ),
            ),
            ListTile(
              title: Text('Fecha de Visita'),
              subtitle: Text("${selectedDate.toLocal()}".split(' ')[0]),
              trailing: IconButton(
                icon: Icon(Icons.calendar_today),
                onPressed: () {
                  _selectDate(context);
                },
              ),
            ),
            ListTile(
              title: Text('Hora de Ingreso'),
              subtitle: Text("${selectedTime.format(context)}"),
              trailing: IconButton(
                icon: Icon(Icons.access_time),
                onPressed: () {
                  _selectTime(context);
                },
              ),
            ),
            ListTile(
              title: Text('Placa'),
              subtitle: TextField(
                controller: placaController,
                decoration: InputDecoration(
                  hintText: 'Ej. ABC-123',
                ),
              ),
            ),
            ElevatedButton.icon(
              onPressed: () => _generateQRCode(mainProvider, apiService),
              icon: Icon(Icons.filter_center_focus),
              label: Text('Generar QR'),
              // style: ElevatedButton.styleFrom(
              //   primary: Color(0xff0040AE),
              // ),
            ),
          ],
        ),

      ),
    );
  }
}
