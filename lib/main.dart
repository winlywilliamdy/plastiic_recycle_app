// ignore_for_file: use_build_context_synchronously

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import 'image_cropper.dart';

Future<void> main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<CameraDescription>? cameras; //list out the camera available
  CameraController? controller; //controller for camera
  XFile? image; //for captured image

  @override
  void initState() {
    loadCamera();
    super.initState();
  }

  loadCamera() async {
    cameras = await availableCameras();
    if (cameras != null) {
      controller = CameraController(cameras![0], ResolutionPreset.max);
      //cameras[0] = first camera, change to 1 to another camera

      controller!.initialize().then((_) {
        if (!mounted) {
          return;
        }
        setState(() {});
      });
    } else {
      print("NO any camera found");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text("Capture Image from Camera"),
      //   backgroundColor: Colors.redAccent,
      // ),
      body: Container(
          child: Column(children: [
        Expanded(flex: 10, child: Container()),
        Expanded(
          flex: 80,
          child: Row(
            children: [
              Expanded(flex: 10, child: Container()),
              Expanded(
                flex: 80,
                child: SizedBox(
                    child: controller == null
                        ? const Center(child: Text("Loading Camera..."))
                        : !controller!.value.isInitialized
                            ? const Center(
                                child: CircularProgressIndicator(),
                              )
                            : CameraPreview(controller!)),
              ),
              Expanded(flex: 10, child: Container()),
            ],
          ),
        ),
        Expanded(
          flex: 10,
          child: Column(
            children: [
              Expanded(child: Container()),
              SizedBox(
                width: 150,
                height: 50,
                child: ElevatedButton.icon(
                  //image capture button
                  onPressed: () async {
                    try {
                      if (controller != null) {
                        //check if contrller is not null
                        if (controller!.value.isInitialized) {
                          //check if controller is initialized
                          image = await controller!.takePicture();

                          await Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                      pageBuilder: (c, a1, a2) => ImageCropper(
                                          Container(
                                              //show captured image
                                              padding: const EdgeInsets.all(30),
                                              child: image == null ? const Text("No image captured") : Image.network((image!.path), height: 300)
                                              //display captured image
                                              ),
                                          imageXFile: image!),
                                      transitionsBuilder: (c, anim, a2, child) => FadeTransition(opacity: anim, child: child),
                                      transitionDuration: const Duration(milliseconds: 250),
                                      reverseTransitionDuration: const Duration(milliseconds: 250)))
                              .then((value) {
                            if (value == 200) {
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Upload complete!')));
                            }
                          });
                        }
                      }
                    } catch (e) {
                      // print(e); //show error
                    }
                  },
                  icon: const Icon(Icons.camera),
                  label: const Text("Capture"),
                ),
              ),
              Expanded(child: Container()),
            ],
          ),
        ),
      ])),
    );
  }
}
