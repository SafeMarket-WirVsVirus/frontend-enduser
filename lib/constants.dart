import 'package:google_maps_flutter/google_maps_flutter.dart';

class Constants {
  static final slotSizeInMinutes = 15;
  static final baseUrl = 'wirvsvirusretail.azurewebsites.net';
  static final minHoursBeforeNowForReservations = 2;
  static final minDurationBeforeNowBeforeExpired = Duration(hours: 1);
  static final durationForNotificationBeforeStartTime = Duration(minutes: 30);
  static final websiteUrl = "https://instagram.com/safemarket_wirvsvirus";
  static final tutorialInitialCameraPositionLatLng = LatLng(52.52279, 13.3864963);
  static final tutorialLocationIds = [7];
  static final tutorialFirstTestMarker = 7;
}
