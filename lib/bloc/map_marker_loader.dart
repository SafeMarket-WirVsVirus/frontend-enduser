import 'dart:async';
import 'dart:ui' as ui;
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:reservation_system_customer/repository/data/location.dart';

import '../ui_imports.dart';

class MapMarkerLoader {
  Future<Map<FillStatus, BitmapDescriptor>> loadClusterIcons() async {
    final Map<FillStatus, BitmapDescriptor> markerIcons = {};

    final radius = 25.0;
    final borderWidth = 5.0;

    final borderPaint = Paint()..color = Colors.white;

    for (FillStatus fillStatus in FillStatus.values) {
      final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
      final Canvas canvas = Canvas(pictureRecorder);
      //draw border
      canvas.drawCircle(Offset(radius, radius), radius, borderPaint);

      final backgroundPaint = Paint()
        ..color = _markerBackgroundColor(fillStatus);
      //draw inner circle
      canvas.drawCircle(
          Offset(radius, radius), radius - borderWidth, backgroundPaint);

      // Convert canvas to image
      final ui.Image markerAsImage = await pictureRecorder
          .endRecording()
          .toImage(radius.toInt() * 2, radius.toInt() * 2);

      // Convert image to bytes
      final ByteData byteData =
          await markerAsImage.toByteData(format: ui.ImageByteFormat.png);
      final Uint8List uint8List = byteData.buffer.asUint8List();

      markerIcons[fillStatus] = (BitmapDescriptor.fromBytes(uint8List));
    }
    return markerIcons;
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

  Future<Map<int, BitmapDescriptor>> addNewMarkerIcons(
      List<Location> locations, Map<int, BitmapDescriptor> iconMap) async {
    final size = Size(200, 130);
    final textPadding = 6.0;
    final arrowSize = 18.0;
    final cornerRadius = 13.0;
    final borderWidth = 4.0;

    if (iconMap == null) {
      iconMap = {};
    }

    for (int i = 0; i < locations.length; i++) {
      final location = locations[i];

      if (!iconMap.containsKey(location.id)) {
        final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
        final Canvas canvas = Canvas(pictureRecorder);

        _drawSpeechBubble(
          size,
          canvas,
          Offset(0, 0),
          Colors.white,
          arrowSize,
          cornerRadius,
        );

        _drawSpeechBubble(
          Size(size.width - borderWidth * 2, size.height - borderWidth * 2),
          canvas,
          Offset(borderWidth, borderWidth),
          _markerBackgroundColor(
            location.fillStatus,
          ),
          arrowSize,
          cornerRadius,
        );

        // Add location text
        TextPainter textPainter = TextPainter(
            maxLines: 2,
            ellipsis: "\u2026",
            textDirection: TextDirection.ltr,
            textAlign: TextAlign.center);
        textPainter.text = TextSpan(
          text: location.name,
          style: TextStyle(
            fontSize: 30,
            color: Colors.white,
          ),
        );
        textPainter.layout(maxWidth: size.width - 2 * textPadding);
        textPainter.paint(
            canvas,
            Offset(size.width / 2 - textPainter.width / 2,
                (size.height - textPainter.height - arrowSize) / 2));

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

  _drawSpeechBubble(Size size, Canvas canvas, Offset offset,
      Color backgroundColor, double arrowSize, double cornerRadius) {
    //background
    final bgPaint = Paint()..color = backgroundColor;
    Rect bgRect = Rect.fromLTWH(
        offset.dx, offset.dy, size.width, size.height - arrowSize);
    canvas.drawRRect(
        RRect.fromRectAndRadius(bgRect, Radius.circular(cornerRadius)),
        bgPaint);

    //add arrow down
    DrawTriangle(
            backgroundColor,
            Offset(size.width / 2 - arrowSize / 2 + offset.dx * 1.5,
                size.height - arrowSize + offset.dy))
        .paint(canvas, Size(arrowSize - offset.dx, arrowSize - offset.dy));
  }

  Color _markerBackgroundColor(FillStatus fillStatus) {
    if (fillStatus == FillStatus.green) {
      return Color(0xFF00F2A9);
    } else if (fillStatus == FillStatus.yellow) {
      return Color(0xFFFEBE5F);
    } else if (fillStatus == FillStatus.red) {
      return Color(0xFFFF5C66);
    } else {
      return Colors.grey;
    }
  }
}

class DrawTriangle extends CustomPainter {
  Paint _paint;
  final Offset offset;

  DrawTriangle(Color color, this.offset) {
    _paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
  }

  @override
  void paint(Canvas canvas, Size size) {
    var path = Path();
    path.moveTo(offset.dx, offset.dy);
    path.lineTo(offset.dx + size.width, offset.dy);
    path.lineTo(offset.dx + size.width / 2, size.height + offset.dy);
    path.close();
    canvas.drawPath(path, _paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
