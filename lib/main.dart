//import 'package:camerawesome/camerawesome_plugin.dart';
import 'package:flutter/material.dart';
//import 'package:plant_code/camera.dart';
import 'capture_image_screen.dart';
//import 'camera.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Image Capture App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: CaptureImageScreen()
    );
  }
}
