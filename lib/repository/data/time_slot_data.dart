import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'time_slot_data.g.dart';

@JsonSerializable(createToJson: false)
class TimeSlotDataResult {
  @JsonKey(name: "items")
  final List<TimeSlotData> timeSlotData;

  TimeSlotDataResult(this.timeSlotData);

  factory TimeSlotDataResult.fromJson(Map<String, dynamic> json) =>
      _$TimeSlotDataResultFromJson(json);
}

@JsonSerializable(createToJson: false)
class TimeSlotData {
  DateTime start;
  DateTime end;
  int registrationCount;

  TimeSlotData({
    @required this.start,
    @required this.end,
    @required this.registrationCount,
  });

  factory TimeSlotData.fromJson(Map<String, dynamic> json) =>
      _$TimeSlotDataFromJson(json);
}
