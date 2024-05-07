// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:rive/rive.dart';

// class DocumentsLoadingWidget extends StatefulWidget {
//   @override
//   _DocumentsLoadingWidgetState createState() => _DocumentsLoadingWidgetState();
// }

// class _DocumentsLoadingWidgetState extends State<DocumentsLoadingWidget> {
//   Artboard _riveArtboard;
//   RiveAnimationController _controller;

//   @override
//   void initState() {
//     super.initState();
//     rootBundle.load('packages/wethree_flutter_core/assets/documents.riv').then(
//       (data) async {
//         final file = RiveFile();

//         // Load the RiveFile from the binary data.
//         if (file.import(data)) {
//           // The artboard is the root of the animation and gets drawn in the
//           // Rive widget.
//           final artboard = file.mainArtboard;
//           // Add a controller to play back a known animation on the main/default
//           // artboard.We store a reference to it so we can toggle playback.
//           artboard.addController(_controller = SimpleAnimation('idle'));
//           setState(() => _riveArtboard = artboard);
//         }
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: _riveArtboard == null
//           ? const SizedBox()
//           : Rive(artboard: _riveArtboard),
//     );
//   }
// }
