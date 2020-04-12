import 'dart:async';
import 'dart:ui' as ui;
import 'dart:typed_data';
import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:reservation_system_customer/repository/data/location.dart';

import '../ui_imports.dart';

class MapMarkerLoader {
  Future<Map<FillStatus, BitmapDescriptor>> loadMarkerIcons() async {
    final Map<FillStatus, BitmapDescriptor> markerIcons = {};
    markerIcons[FillStatus.green] = await _icon(FillStatus.green);
    markerIcons[FillStatus.yellow] = await _icon(FillStatus.yellow);
    markerIcons[FillStatus.red] = await _icon(FillStatus.red);
    return markerIcons;
  }

  Future<BitmapDescriptor> _icon(FillStatus color) async {
    final size = 90;
    switch (color) {
      case FillStatus.green:
        return _getBytesFromAsset('assets/icon_green.png', size);
      case FillStatus.red:
        return _getBytesFromAsset('assets/icon_red.png', size);
      case FillStatus.yellow:
        return _getBytesFromAsset('assets/icon_yellow.png', size);
    }
    return null;
  }

  Future<BitmapDescriptor> _getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    final codec = await instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    FrameInfo fi = await codec.getNextFrame();
    final bytes = (await fi.image.toByteData(format: ImageByteFormat.png))
        .buffer
        .asUint8List();
    return BitmapDescriptor.fromBytes(bytes);
  }

  Future<ui.Image> loadMarkerAsset(FillStatus fillStatus) async {
    String imageAssetPath = "assets/icon.png";

    switch (fillStatus) {
      case FillStatus.green:
        imageAssetPath = "assets/icon_green.png";
        break;
      case FillStatus.red:
        imageAssetPath = "assets/icon_red.png";
        break;
      case FillStatus.yellow:
        imageAssetPath = "assets/icon_yellow.png";
        break;
    }

    final ByteData data = await rootBundle.load(imageAssetPath);
    final Completer<ui.Image> completer = Completer();
    ui.decodeImageFromList(Uint8List.view(data.buffer), (ui.Image img) {
      return completer.complete(img);
    });
    return completer.future;
  }

  Future<Map<int, BitmapDescriptor>> addNewMarkerIcons(List<Location> locations,
      Map<int, BitmapDescriptor> iconMap, Size size) async {
    print("before marker creation ran with length ${locations.length}");

    if (iconMap == null) {
      iconMap = {};
    }

    for (int i = 0; i < locations.length; i++) {
      final location = locations[i];

      if (!iconMap.containsKey(location.id)) {
        final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
        final Canvas canvas = Canvas(pictureRecorder);
        final double imageHeight = 100; /*size.height - textHeight * 2*/

        print("creating marker icon for location id ${location.id}");

        //manually add line break if need
        String locationName = location.name;
        if (locationName.length > 15) {
          locationName = locationName.substring(0, 14) +
              "\n" +
              locationName.substring(14, locationName.length);
        }

        // Add location text
        TextPainter textPainter = TextPainter(
            textDirection: TextDirection.ltr, textAlign: TextAlign.center);
        textPainter.text = TextSpan(
          text: locationName,
          style: TextStyle(
            fontSize: 33,
            fontWeight: FontWeight.bold,
            color: Colors.orange,
          ),
        );

        textPainter.layout();
        textPainter.paint(canvas,
            Offset(size.width / 2 - textPainter.width / 2, imageHeight + 10));

        Rect rect = Rect.fromLTWH(
            size.width / 2 - imageHeight / 2, 0, imageHeight, imageHeight);

        // Add path for oval image
        canvas.clipPath(Path()..addRect(rect));

        // Add image
        ui.Image image = await loadMarkerAsset(location
            .fillStatus); // Alternatively use your own method to get the image
        paintImage(
            canvas: canvas, image: image, rect: rect, fit: BoxFit.fitWidth);

        // Convert canvas to image
        final ui.Image markerAsImage = await pictureRecorder
            .endRecording()
            .toImage(size.width.toInt(), size.height.toInt());

        // Convert image to bytes
        final ByteData byteData =
            await markerAsImage.toByteData(format: ui.ImageByteFormat.png);
        final Uint8List uint8List = byteData.buffer.asUint8List();

        iconMap[location.id] = (BitmapDescriptor.fromBytes(uint8List));
      }
    }

    return iconMap;
  }
}
