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
import 'package:sammseguridad_apk/services/ApiService.dart';
import 'package:sammseguridad_apk/widgets/Appbar.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';


class ScreenGenerarVisita extends StatefulWidget {
  String widgetCedula;
  String widgetNombre;
  String widgetApellido;
  
  ScreenGenerarVisita({
    required this.widgetCedula,
    required this.widgetNombre,
    required this.widgetApellido,

    Key? key
  }) : super(key: key);

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
  String idVisitanteEncontrado='';
  Map<String,dynamic> visitanteEncontrado={};
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  TextEditingController placaController = TextEditingController();

  String _qrData = "";


  static const _fontSize = 20.0;
  static const _paddingSize = 15.0;
  static const _buttonFontSize = 18.0;
  static const _sizedBoxHeight = 10.0;
  late List<dynamic> ubicaciones =[];
  late List<dynamic> resultadosBusqueda =[];
  final ApiService _apiService = ApiService();


  TextStyle estiloAzul = TextStyle(
    fontSize: 20, 
    fontWeight: FontWeight.bold,
    color: Colors.blue[900]
  );
  ButtonStyle  estiloboton = ElevatedButton.styleFrom(
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
  Map<String,dynamic> ubicacionSelected = {};

  

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
Future<void> getUbicaciones() async {
    try {
      const String url = "/visitas/getUbicaciones";
      String response = await _apiService.getDataJson(url, token);

      setState(() {
        
        ubicaciones = jsonDecode(response);
      });
    } catch (e) {
      print('Error al obtener datos: $e');
    }
  }

Future<void> consultarExisteVisitante(String cedulaNombre ) async {
    try {
      String url = "/visitas/getPersonaByCED_and_NAME/$cedulaNombre";
      String response = await _apiService.getDataJson(url, "");
      setState(() {
        resultadosBusqueda= jsonDecode(response)["data"];
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
    ubicacionSelected={};
    ubicaciones=[];
    if (stateCedula.length != 10 || !RegExp(r'^[0-9]+$').hasMatch(stateCedula)){
      cedulaIsFiled = false;
    }else{
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
    getUbicaciones();
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
      const SnackBar(content: Text('QR data copied to clipboard')),
    );
  }

  GlobalKey _qrKey = GlobalKey();


  Future<String?> _downloadQRCode(GlobalKey qrKey) async {
    // Solicitar permisos de almacenamiento
    Map<Permission, PermissionStatus> statuses = await [
      Permission.storage,
    ].request();

    if (statuses[Permission.storage]?.isGranted ?? false) {
      // Los permisos de almacenamiento fueron concedidos
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
    } else {
      // Los permisos de almacenamiento fueron denegados, maneja esta situación de acuerdo a tu flujo de la aplicación
      // Puedes mostrar un mensaje al usuario o realizar otras acciones necesarias.
      return null;
    }
  }


  void _sendQRCodeByEmail(String qrData) {
    // TODO: Implement send by email functionality
    // You can use a package like 'url_launcher' to open the email client with pre-filled data
  }
  Future<void> _shareQRImage(data) async {
    final image = await QrPainter(
      data: data,
      version: QrVersions.auto,
      gapless: false,
      
      dataModuleStyle: const QrDataModuleStyle(
        dataModuleShape: QrDataModuleShape.circle
        
      ),
      color: Colors.black,
      emptyColor: Colors.white,
      

    ).toImageData(50); // Generate QR code image data

    const filename = 'qr_code.png';
    final tempDir = await getTemporaryDirectory();// Get temporary directory to store the generated image
    final file = await File('${tempDir!.path}/$filename').create(); // Create a file to store the generated image
    
    var bytes = image!.buffer.asUint8List(); // Get the image bytes
    await file.writeAsBytes(bytes); // Write the image bytes to the file
   //Share.share('check out my website https://example.com', subject: 'Look what I made!');
    final path = await Share.shareFiles([file.path], text: 'QR code for ${data}', subject: 'QR Code', mimeTypes: ['image/png']); // Share the generated image using the share_plus package
   
 } 


  Future<void> _generateQRCode(
      MainProvider mainProvider, ApiService apiService) async {
    // if (_formKey.currentState!.validate()) {
      String formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate);
      //String formattedTime = DateFormat.Hm().format(DateTime.now());
      String formattedTime = '${selectedTime.hour}:${selectedTime.minute}';
      
      //poner en qr ID de registro
      String qrData ='${DateFormat('dd/MM/yyyy').format(selectedDate)},${selectedTime.format(context)},${selectedTime},${stateCedula},${stateNombre},${placaController.text}';
      //String qrData =visitanteEncontrado["Id"].toString();
      Map<String, dynamic> data = {
        'date': formattedDate.toString(),
        'time': formattedTime,
        'duration': 100,
        'cedula': stateCedula,
        'nameVisitante': stateNombre,
        'idUbicacion': ubicacionSelected["Id"],
        'lastNameVisitante': stateApellido,
        //'idAnfitrion': mainProvider.response['Id'],
        'idAnfitrion':MainProvider.prefs.getInt("Id"),
        'idVisitante': visitanteEncontrado["IdPersona"]??"",
        'antecedentes': 0,
        'phone': visitanteEncontrado["Cel_Persona"]??"9999999999",
        'email': visitanteEncontrado["Correo_Personal"]??"correo@ejemplo.com",
        'observaciones': "0000",
        // 'lastName': _lastNameController.text,
        'placa': placaController.text,
      };

      try {
        // print('Data: $data');
        
        var response = await apiService.postData('/visitas/registraVisita', data, token);
        print(response);
        print("==============================");
        // print('Data: $data');

        // print(response);
      } catch (e) {
        // print('Failed to post data: $e');
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
                              subtitle: Text(DateFormat('yyyy-MM-dd')
                                  .format(selectedDate)),
                            ),
                            ListTile(
                              leading: const Icon(Icons.directions_car),
                              title: const Text('Placa'),
                              subtitle: Text(placaController.text),
                            ),
                            ListTile(
                              leading: const Icon(Icons.access_time),
                              title: const Text('Hora'),
                              subtitle:
                                  Text(formattedTime),
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
                    //var imagePath = await _downloadQRCode(_qrKey);
              
                    //_shareQRData(qrData, imagePath??"");
                    //_shareQRImage(qrData);

                    _shareQRImageScreen(
                        context: context,
                        qrWidget: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Text("QR de invitación",style: TextStyle(color: Colors.black, fontSize: 30),),
                              const SizedBox(height: 50),
                              QrImageView(
                                data: qrData,
                                version: QrVersions.auto,
                                size: 350.0,
                                gapless: false,
                                backgroundColor: Colors.white,
                                dataModuleStyle:const  QrDataModuleStyle(
                                  color: Colors.black,
                                  dataModuleShape: QrDataModuleShape.square
                                ),
                                errorStateBuilder: (context, error) {
                                  return const Center(
                                    child: Text(
                                      "Error al generad el qr",
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  );
                                },
                              ),
                              //Text(""),
                            ],
                          ),
                        ));



                  },
                ),
              ),
              /*IconButton(
                icon: const Icon(Icons.copy),
                onPressed: () => _copyQRDataToClipboard(qrData),
              ),
              IconButton(
                icon: const Icon(Icons.download),
                onPressed: () async {
                  var status = await Permission.photos.status;
                  if (!status.isGranted) {
                    status = await Permission.photos.request();
                  }
                  if (status.isGranted) {
                    _downloadQRCode(_qrKey);
                  } else {
                    // print("Permission denied.");
                  }
                },
              ),
              IconButton(
                icon: const Icon(Icons.email),
                onPressed: () => _sendQRCodeByEmail(qrData),
              ),*/
            ],
          );
        },
      );
    // }
  }





Future<void> _shareQRImageScreen(
      {required BuildContext context, required Widget qrWidget}) async {
        final qrBox = context.findRenderObject() as RenderBox;
        _screenshotController.captureFromWidget(qrWidget).then((Uint8List bytes) async {
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
    return DropdownButtonFormField(
      padding: const EdgeInsets.all(10),
      decoration: const InputDecoration(
        filled: true,
        //fillColor: Colors.white,
      ),
      //value: _nombreSalonController.text.isNotEmpty?_nombreSalonController.text:"Seleccione Salon...",
      hint: const Text("Seleccione una ubicacion...",style: TextStyle(color: Colors.black),),
      //dropdownColor: Colors.white,
      borderRadius: const BorderRadius.only(bottomRight: Radius.circular(20), bottomLeft: Radius.circular(20)),
      //iconEnabledColor: Colors.black,
      items: ubicaciones.map((item) {

        return DropdownMenuItem(

          value: item["Descripcion"],
          child: Text(
            item["Descripcion"],
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: Colors.black),
          ),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          ubicacionController.text = value.toString();
          int selectedIndex = ubicaciones.indexWhere((item) => item["Descripcion"] == value);
          ubicacionSelected=ubicaciones[selectedIndex];
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
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
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
                  borderRadius: BorderRadius.circular(10.0), // Ajusta el valor para redondear más o menos
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
                    ),validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, coloque su Cedula o Nombre';
                      }
                      return null;
                    },
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blue[900],
                    onPrimary: Colors.white,
                    
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  onPressed: () async {
                    consultarExisteVisitante(busquedaController.text).then((value) => {

                    });
                    
                  },

                  child: const Text(
                    'Buscar',
                    style: TextStyle(fontSize: 18.0),
                  ),
                ),
              ),
              Container(
                height: 300,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0), // Ajusta el valor para redondear más o menos
                  color: Colors.blue[100], // Color de fondo opcional
                ),
                child: ListView.builder(
                  itemCount: resultadosBusqueda.length,
                  itemBuilder: (context, index) {
                    String nombre= (resultadosBusqueda[index]["Nombres"]??"")+" "+(resultadosBusqueda[index]["Apellidos"]??"");
                    return Container(
                      margin: const EdgeInsets.only(left: 20,right: 20),
                      decoration: const BoxDecoration(
                        border: Border(bottom: BorderSide(
                        color: Colors.blue
                        ))
                      ),
                      child: ListTile(
                        onTap: () {
                          setState(() {
                            cedulaController.text=resultadosBusqueda[index]["Cedula"];
                            stateNombre = resultadosBusqueda[index]["Nombres"]??"";
                            stateApellido = resultadosBusqueda[index]["Apellidos"]??"";
                            //idVisitanteEncontrado = resultadosBusqueda[index]["IdPersona"];
                            visitanteEncontrado = resultadosBusqueda[index];
                          });
                        },
                        title: Text(nombre , style: const TextStyle(color: Colors.black)),
                        subtitle: Text( 'CI:${resultadosBusqueda[index]["Cedula"]??""}', style: const TextStyle(color: Colors.black)),
                                
                      ),
                    );
                },),
              ),
                            const SizedBox(height: 16.0),

              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0), // Ajusta el valor para redondear más o menos
                  color: Colors.white, // Color de fondo opcional
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    controller: cedulaController,
                    decoration: const InputDecoration(
                      hintText: 'Cedula *',
                      border: InputBorder.none,
                    ),validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, coloque su Cedula';
                      }
                      return null;
                    },
                  ),
                ),
              ),

              const SizedBox(height: 16.0),
              
              Container(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blue[900],
                    onPrimary: Colors.white,
                    
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  onPressed: () async {
                    String cedulaescrita = cedulaController.text;
                    // widget.cedula = cedulaController.text;
                    // Validar la cédula
                    if (cedulaescrita.length != 10 || !RegExp(r'^[0-9]+$').hasMatch(cedulaescrita)) {
                      // Si la cédula no tiene 10 dígitos o no son todos números, muestra un mensaje de error
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text('Error de Cédula'),
                            content: const Text('La cédula debe tener 10 dígitos y contener solo números.'),
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
                    } else {
                      // Si la cédula es válida, puedes realizar la acción de invitar al usuario
                      // print('Invitar a: $nombre $apellido (Cédula: $cedula)');
                      // close the modal
                      // Navigator.of(context).pop();
                      // Navigator.of(context).push(
                      //   MaterialPageRoute(
                      //     builder: (context) => ScreenGenerarVisita(
                      //       cedula: cedula,
                      //       nombre: "",
                      //     ),
                      //   ),
                      // );
                      setState(() {
                        stateCedula = cedulaescrita;
                        cedulaIsFiled = true;
                      });
                    }
                  },

                  child: const Text(
                    'verificar',
                    style: TextStyle(fontSize: 18.0),
                  ),
                ),
              ),

              ]
              else ...[




              Card(
                child: Column(
                  children: [
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Icon(Icons.person),
                      )
                    ),
                    const Center(
                      child: Text("invitar a:")
                    ),
                    Center(
                      child: Text('$stateNombre $stateApellido')
                    ),
                    Center(
                      child: Text(stateCedula)
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
                subtitle: Text("${selectedTime.format(context)}"),
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
                onPressed: stateNombre.length > 1 ? () {
                  _generateQRCode(mainProvider, apiService);
                }: null,
                icon: const Icon(Icons.filter_center_focus),
                label: const Text('Invitar'),
                style: estiloboton
              ),
              ],
            ],
          ),
      
        ),
      );
    // );
  }
}
