import 'dart:ui';

import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:reservation_system_customer/repository/data/location.dart';

class MapMarkerLoader {
  Future<Map<FillStatus, BitmapDescriptor>> loadMarkerIcons() async {
    final Map<FillStatus, BitmapDescriptor> markerIcons = {};
    markerIcons[FillStatus.green] = await _icon(FillStatus.green);
    markerIcons[FillStatus.yellow] = await _icon(FillStatus.yellow);
    markerIcons[FillStatus.red] = await _icon(FillStatus.red);
    markerIcons[FillStatus.gray] = await _icon(FillStatus.gray);
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
      case FillStatus.gray:
        return _getBytesFromAsset('assets/icon_gray.png', size);
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
}
