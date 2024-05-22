import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:async/async.dart';
import 'package:image_picker/image_picker.dart';
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
  final ImagePicker _picker = ImagePicker();

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
      final pred_plant = await postFile(File(imagePath));

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
            displayImage: _displayImage!,
            pred_plant: pred_plant,
          ),
        ),
      );

      // Upload the image
      upload(File(imagePath));
    } catch (e) {
      print(e);
    }
  }

  Future<void> _pickAndSaveImage() async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        final imageFile = File(pickedFile.path);
        final directory = await getApplicationDocumentsDirectory();
        final imagePath = path.join(directory.path, '${DateTime.now()}.png');
        await imageFile.copy(imagePath);

        // Resize the image
        final resizedImage = await _resizeImage(File(imagePath), 300, 300);
        final pred_plant = await postFile(File(imagePath));

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
              displayImage: _displayImage!,
              pred_plant: pred_plant,
            ),
          ),
        );

        // Upload the image
        upload(File(imagePath));
      }
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

  Future<void> upload(File imageFile) async {
    try {
      // open a bytestream
      var stream = http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
      // get file length
      var length = await imageFile.length();

      // string to uri
      var uri = Uri.parse("http://ip:8082/composer/predict"); // Use 10.0.2.2 for Android emulator

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

      // Check if the response is successful
      if (response.statusCode == 200) {
        // Decode the response body using utf8 decoder
        response.stream.transform(utf8.decoder).listen((value) {
          print(value);
        });
      } else {
        print('Error: Failed to upload image. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
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
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FloatingActionButton(
                onPressed: _captureAndSaveImage,
                child: Icon(Icons.camera_alt),
              ),
              SizedBox(width: 20),
              FloatingActionButton(
                onPressed: _pickAndSaveImage,
                child: Icon(Icons.photo_library),
              ),
            ],
          )
        ],
      ),
    );
  }
}
