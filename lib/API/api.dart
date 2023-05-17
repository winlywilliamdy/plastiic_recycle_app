// ignore_for_file: deprecated_member_use

import 'dart:convert';
import 'package:path/path.dart';
import 'package:async/async.dart';
import 'package:universal_io/io.dart' as io;
import 'package:http/http.dart' as http;

class API {
  API();

  void upload(io.File imageFile) async {
    var stream = http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
    var length = await imageFile.length();

    var uri = Uri.parse("192.168.5.51:14450/upload/picture/1/100/100/50/50");

    var request = http.MultipartRequest("POST", uri);
    var multipartFile = http.MultipartFile('image', stream, length, filename: basename(imageFile.path));
    //contentType: new MediaType('image', 'png'));

    request.files.add(multipartFile);
    var response = await request.send();
    print(response.statusCode);
    response.stream.transform(utf8.decoder).listen((value) {
      print(value);
    });
  }
}
