import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class We3Camera extends StatefulWidget {
  We3Camera({
    
    this.isBackCam = true,
    required this.cameras,
  }) ;
  final List<CameraDescription> cameras;
  final bool isBackCam;
  @override
  State<We3Camera> createState() => _We3CameraState();
}

class _We3CameraState extends State<We3Camera> {
  CameraController? controller;
  String? imagePath;

  @override
  void initState() {
    super.initState();
    controller = CameraController(
        widget.cameras[widget.isBackCam ? 0 : 1], ResolutionPreset.veryHigh);
    controller?.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  Future<String?> takePicture() async {
    if (!controller!.value.isInitialized) {
      return null;
    }

    String filePath;
    if (controller!.value.isTakingPicture) {
      return null;
    }

    try {
      XFile picture = await controller!.takePicture();
      filePath = picture.path;
    } on CameraException catch (e) {
      print(e);
      return null;
    }
    return filePath;
  }

  void onTakePictureButtonPressed() {
    takePicture().then((String? filePath) {
      if (mounted) {
        setState(() {
          imagePath = filePath;
        });
        if (filePath != null) {
          Fluttertoast.showToast(
            msg: "Picture saved",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
          );
          Navigator.pop(context, filePath);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    if (!controller!.value.isInitialized) {
      return Container();
    }

    return Container(
      width: size.width,
      height: size.width / controller!.value.aspectRatio,
      child: Stack(
        children: <Widget>[
          CameraPreview(controller!),
          Positioned(
              bottom: 20,
              right: size.width / 2.2,
              height: size.width / 7,
              width: size.width / 7,
              child: FloatingActionButton(
                child: Icon(Icons.camera),
                backgroundColor: Colors.blueGrey,
                onPressed: controller != null &&
                        controller!.value.isInitialized &&
                        !controller!.value.isRecordingVideo
                    ? onTakePictureButtonPressed
                    : null,
              ))
        ],
      ),
    );
  }
}
