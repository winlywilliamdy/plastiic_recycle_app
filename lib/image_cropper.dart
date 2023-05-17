import 'dart:convert';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:plastic_recycle_annotation/plastic_button.dart';
import 'package:http/http.dart' as http;

class ImageCropper extends StatefulWidget {
  const ImageCropper(this.image, {super.key, required this.imageXFile});
  final Widget image;
  final XFile imageXFile;
  @override
  State<StatefulWidget> createState() {
    return ImageCropperState();
  }
}

class ImageCropperState extends State<ImageCropper> {
  double posx1 = 100.0;
  double posy1 = 100.0;

  double posx2 = 0;
  double posy2 = 0;

  bool firstClick = true;

  bool firstClickVisibility = false;
  bool secondClickVisibility = false;

  void onTapDown(BuildContext context, TapDownDetails details, double width, double height) {
    final RenderObject? box = context.findRenderObject();
    if (box is RenderBox) {
      final Offset localOffset = box.globalToLocal(details.globalPosition);

      var normalizedX = width - (0.9 * width);
      var normalizedY = height - (0.9 * height);

      setState(() {
        if (firstClick) {
          posx1 = localOffset.dx - normalizedX;
          posy1 = localOffset.dy - normalizedY;
          firstClick = false;
          firstClickVisibility = true;
        } else {
          posx2 = localOffset.dx - normalizedX;
          posy2 = localOffset.dy - normalizedY;
          secondClickVisibility = true;
          firstClick = true;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Row(children: [
        Expanded(flex: 10, child: Container()),
        Expanded(
            flex: 80,
            child: Column(children: [
              Expanded(flex: 10, child: Container()),
              Expanded(
                  flex: 80,
                  child: Container(
                    decoration: BoxDecoration(border: Border.all(color: Colors.blue)),
                    child: GestureDetector(
                        onTapDown: (TapDownDetails details) => onTapDown(context, details, width, height),
                        child: Stack(fit: StackFit.expand, children: <Widget>[
                          widget.image,
                          Visibility(
                              visible: secondClickVisibility,
                              child: Positioned(
                                  left: (posx1 < posx2) ? posx1 : posx2,
                                  top: (posy1 < posy2) ? posy1 : posy2,
                                  child: Container(
                                      width: (posx1 - posx2).abs(),
                                      height: (posy1 - posy2).abs(),
                                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(0), color: Colors.blue.withOpacity(0.3))))),
                          Visibility(
                              visible: secondClickVisibility,
                              child: Positioned(
                                  left: posx2 - 5,
                                  top: posy2 - 5,
                                  child: Container(
                                      width: 5, height: 5, decoration: BoxDecoration(borderRadius: BorderRadius.circular(500), color: Colors.red)))),
                          Visibility(
                              visible: firstClickVisibility,
                              child: Positioned(
                                  left: posx1,
                                  top: posy1,
                                  child: Container(
                                      width: 5, height: 5, decoration: BoxDecoration(borderRadius: BorderRadius.circular(500), color: Colors.red))))
                        ])),
                  )),
              Expanded(
                  flex: 10,
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Container(
                              height: 75,
                              width: 200,
                              decoration: const BoxDecoration(color: Colors.transparent),
                              child: PlasticButton(plasticId: 1, callback: callback, plasticType: "PET")),
                          Expanded(child: Container()),
                          Container(
                              height: 75,
                              width: 200,
                              decoration: const BoxDecoration(color: Colors.transparent),
                              child: PlasticButton(plasticId: 2, callback: callback, plasticType: "HDPE")),
                          Expanded(child: Container()),
                          Container(
                              height: 75,
                              width: 200,
                              decoration: const BoxDecoration(color: Colors.transparent),
                              child: PlasticButton(plasticId: 3, callback: callback, plasticType: "PVC")),
                          Expanded(child: Container()),
                          Container(
                              height: 75,
                              width: 200,
                              decoration: const BoxDecoration(color: Colors.transparent),
                              child: PlasticButton(plasticId: 4, callback: callback, plasticType: "LDPE")),
                          Expanded(child: Container()),
                          Container(
                              height: 75,
                              width: 200,
                              decoration: const BoxDecoration(color: Colors.transparent),
                              child: PlasticButton(plasticId: 5, callback: callback, plasticType: "PP")),
                          Expanded(child: Container()),
                          Container(
                              height: 75,
                              width: 200,
                              decoration: const BoxDecoration(color: Colors.transparent),
                              child: PlasticButton(plasticId: 6, callback: callback, plasticType: "PS")),
                          Expanded(child: Container()),
                          Container(
                              height: 75,
                              width: 200,
                              decoration: const BoxDecoration(color: Colors.transparent),
                              child: PlasticButton(plasticId: 7, callback: callback, plasticType: "Other")),
                        ],
                      ),
                      const SizedBox(height: 10)
                    ],
                  )),
            ])),
        Expanded(flex: 10, child: Container()),
      ]),
    );
  }

  void callback(int plasticId) async {
    String baseimage = '';

    await widget.imageXFile.readAsBytes().then((value) {
      baseimage = base64Encode(value);
    });

    // double width = (posx1 - posx2).abs();
    // double height = (posy1 - posy2).abs();
    // double xMid = ;
    // double yMid = ;

    try {
      var uri = Uri.parse("http://192.168.5.51:14450/api/upload/picture/$plasticId/100/100/50/50");
      await http.post(uri, body: {'media': baseimage}).then((value) {
        if (value.statusCode == 200) {
          Navigator.pop(context, 200);
        }
      });
    } catch (e) {
      // print(e);
    }
  }
}
