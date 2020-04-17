class Constants {
  static final slotSizeInMinutes = 10;
  static final baseUrl = 'wirvsvirusretail.azurewebsites.net';
  static final minHoursBeforeNowForReservations = 2;
  static final minDurationBeforeNowBeforeExpired = Duration(hours: 1);
  static final durationForNotificationBeforeStartTime = Duration(minutes: 30);
  static final possibleNotificationTimes = [
    Duration(minutes: 15),
    Duration(minutes: 30),
    Duration(minutes: 60)
  ];
  static final websiteUrl = "https://instagram.com/safemarket_wirvsvirus";
}
