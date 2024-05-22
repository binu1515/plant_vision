import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

class DisplayImageScreen extends StatelessWidget {
  final String imagePath;
  final ui.Image displayImage;
  final String pred_plant;

  DisplayImageScreen({required this.imagePath, required this.displayImage, required this.pred_plant});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Display Image'),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: double.infinity,
              height: 200.0,

              child: CustomPaint(
                painter: ImagePainter(displayImage),
              ),
            ),
            SizedBox(height: 10),
            Text('Image saved to $imagePath'),
            SizedBox(height: 10),
            Text('Predicted plant: $pred_plant'),
          ],
        ),
      ),
    );
  }
}

class ImagePainter extends CustomPainter {
  final ui.Image image;

  ImagePainter(this.image);

  @override
  void paint(Canvas canvas, Size size) {
    // Scale the image to fit into the container
    final double scaleX = size.width / image.width;
    final double scaleY = size.height / image.height;
    final double scale = scaleX < scaleY ? scaleX : scaleY;

    final double dx = (size.width - image.width * scale) / 2;
    final double dy = (size.height - image.height * scale) / 2;

    final Offset offset = Offset(dx, dy);
    final Rect srcRect = Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble());
    final Rect dstRect = Rect.fromLTWH(dx, dy, image.width * scale, image.height * scale);

    canvas.drawImageRect(image, srcRect, dstRect, Paint());
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
