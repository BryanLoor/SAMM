// import 'package:barcode_widget/barcode_widget.dart';
// import 'package:flutter/material.dart';

// class InvitacionDataDialog extends StatefulWidget {
//   const InvitacionDataDialog({super.key});

//   @override
//   State<InvitacionDataDialog> createState() => _InvitacionDataDialogState();
// }

// class _InvitacionDataDialogState extends State<InvitacionDataDialog> {
//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       content: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Container(
//               child: BarcodeWidget(
//                 key: _qrKey,
//                 barcode: Barcode.qrCode(),
//                 data: qrData,
//                 width: 200,
//                 height: 200,
//               ),
//             ),
//             SizedBox(height: 16),
//             Text('Datos de la invitación:',
//                 style:
//                     TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//             SizedBox(height: 8),
//             Row(
//               children: [
//                 Expanded(
//                   child: Column(
//                     children: [
//                       ListTile(
//                         leading: Icon(Icons.credit_card),
//                         title: Text('Cédula'),
//                         subtitle: Text(_idController.text),
//                       ),
//                       ListTile(
//                         leading: Icon(Icons.person),
//                         title: Text('Nombres'),
//                         subtitle: Text(_nameController.text),
//                       ),
//                       ListTile(
//                         leading: Icon(Icons.calendar_today),
//                         title: Text('Fecha'),
//                         subtitle: Text(DateFormat('yyyy-MM-dd')
//                             .format(_selectedDate)),
//                       ),
//                       ListTile(
//                         leading: Icon(Icons.directions_car),
//                         title: Text('Placa'),
//                         subtitle: Text(_plateController.text),
//                       ),
//                     ],
//                   ),
//                 ),
//                 Expanded(
//                   child: Column(
//                     children: [
//                       ListTile(
//                         leading: Icon(Icons.person),
//                         title: Text('Apellidos'),
//                         subtitle: Text(_lastNameController.text),
//                       ),
//                       ListTile(
//                         leading: Icon(Icons.access_time),
//                         title: Text('Hora'),
//                         subtitle:
//                             Text(DateFormat.Hm().format(DateTime.now())),
//                       ),
//                       ListTile(
//                         leading: Icon(Icons.timer),
//                         title: Text('Duración'),
//                         subtitle: Text('$_selectedDuration horas'),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//       actions: [
//         IconButton(
//           icon: Icon(Icons.share),
//           onPressed: () async {
//             var imagePath = await _downloadQRCode(_qrKey);
//             _shareQRData(qrData, imagePath);
//           },
//         ),
//         IconButton(
//           icon: Icon(Icons.copy),
//           onPressed: () => _copyQRDataToClipboard(qrData),
//         ),
//         IconButton(
//           icon: Icon(Icons.download),
//           onPressed: () async {
//             var status = await Permission.photos.status;
//             if (!status.isGranted) {
//               status = await Permission.photos.request();
//             }
//             if (status.isGranted) {
//               _downloadQRCode(_qrKey);
//             } else {
//               print("Permission denied.");
//             }
//           },
//         ),
//         IconButton(
//           icon: Icon(Icons.email),
//           onPressed: () => _sendQRCodeByEmail(qrData),
//         ),
//       ],
//     );
//   }
// }