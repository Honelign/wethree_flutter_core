// import 'package:flutter/material.dart';
// import 'package:qr_code_scanner/qr_code_scanner.dart';

// class We3QrScan extends StatefulWidget {
//   We3QrScan() ;

//   @override
//   State<We3QrScan> createState() => _We3QrScanState();
// }

// class _We3QrScanState extends State<We3QrScan> {
//   final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
//   Barcode? result;
//   QRViewController? controller;
//   bool flashStatus = false;

//   void _onQRViewCreated(QRViewController controller) {
//     this.controller = controller;
//     controller.scannedDataStream.listen((scanData) {
//       setState(() {
//         result = scanData;
//         controller.dispose();
//       });
//     }, onDone: () {
//       Navigator.pop(context, result);
//     });
//   }

//   @override
//   void dispose() {
//     controller?.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             IconButton(
//                 onPressed: () => Navigator.pop(context, null),
//                 icon: Icon(Icons.arrow_back)),
//             Text(
//               'Scanning QR    ',
//               style: TextStyle(
//                   color: Colors.grey[700],
//                   fontWeight: FontWeight.bold,
//                   fontSize: 16),
//             ),
//             Icon(Icons.arrow_back, color: Colors.white),
//           ],
//         ),
//         Padding(
//             padding: const EdgeInsets.all(10.0),
//             child: Container(
//                 height: 500,
//                 child: Stack(
//                   children: [
//                     QRView(key: qrKey, onQRViewCreated: _onQRViewCreated),
//                     Align(
//                         alignment: Alignment.bottomRight,
//                         child: Padding(
//                           padding: const EdgeInsets.all(12.0),
//                           child: FloatingActionButton(
//                               elevation: 0,
//                               backgroundColor: Colors.transparent,
//                               onPressed: () async {
//                                 controller?.toggleFlash();
//                                 flashStatus = await controller?.getFlashStatus()??false;
//                                 setState(() {});
//                               },
//                               child: Icon(
//                                 flashStatus ? Icons.flash_off : Icons.flash_on,
//                                 color: Colors.orange,
//                               )),
//                         ))
//                   ],
//                 ))),
//       ],
//     );
//   }
// }
