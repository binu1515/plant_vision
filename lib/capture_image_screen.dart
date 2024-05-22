import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data'; // Add this import
import 'dart:ui' as ui;

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:async/async.dart';
import 'package:plant_code/dio_api.dart';

import 'display_image_screen.dart';

class CaptureImageScreen extends StatefulWidget {
  @override
  _CaptureImageScreenState createState() => _CaptureImageScreenState();
}

class _CaptureImageScreenState extends State<CaptureImageScreen> {
  CameraController? _controller;
  Future<void>? _initializeControllerFuture;
  String? _imagePath;
  ui.Image? _displayImage;

  get pred_plant => null;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    final firstCamera = cameras.first;

    _controller = CameraController(
      firstCamera,
      ResolutionPreset.high,
    );

    _initializeControllerFuture = _controller!.initialize();
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _captureAndSaveImage() async {
    try {
      await _initializeControllerFuture;

      final image = await _controller!.takePicture();
      final directory = await getApplicationDocumentsDirectory();
      final imagePath = path.join(directory.path, '${DateTime.now()}.png');
      await image.saveTo(imagePath);

      // Resize the image
      final resizedImage = await _resizeImage(File(imagePath), 300, 300);
      final pred_plant =await postFile(File(imagePath));

      setState(() {
        _imagePath = imagePath;
        _displayImage = resizedImage;
      });

      // Navigate to the new screen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DisplayImageScreen(
            imagePath: _imagePath!,
            displayImage: _displayImage!, pred_plant: pred_plant,
          ),
        ),
      );

      // Upload the image
      Upload(File(imagePath));
    } catch (e) {
      print(e);
    }
  }

  Future<ui.Image> _resizeImage(File file, int width, int height) async {
    final image = img.decodeImage(await file.readAsBytes())!;
    final resized = img.copyResize(image, width: width, height: height);
    final completer = Completer<ui.Image>();
    ui.decodeImageFromList(Uint8List.fromList(img.encodePng(resized)), (ui.Image img) {
      return completer.complete(img);
    });
    return completer.future;
  }

  void Upload(File imageFile) async {
    // open a bytestream
    var stream = http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
    // get file length
    var length = await imageFile.length();

    // string to uri
    var uri = Uri.parse("http://ip:8082/composer/predict");

    // create multipart request
    var request = http.MultipartRequest("POST", uri);

    // multipart that takes file
    var multipartFile = http.MultipartFile('file', stream, length,
        filename: path.basename(imageFile.path));

    // add file to multipart
    request.files.add(multipartFile);

    // send
    var response = await request.send();
    print(response.statusCode);

    // listen for response
    response.stream.transform(utf8.decoder).listen((value) {
      print(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Capture Image'),
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<void>(
              future: _initializeControllerFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return CameraPreview(_controller!);
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _captureAndSaveImage,
        child: Icon(Icons.camera_alt),
      ),
    );
  }
}
