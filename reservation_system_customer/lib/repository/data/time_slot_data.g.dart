// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'time_slot_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TimeSlotDataResult _$TimeSlotDataResultFromJson(Map<String, dynamic> json) {
  return TimeSlotDataResult(
    (json['items'] as List)
        ?.map((e) =>
            e == null ? null : TimeSlotData.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

TimeSlotData _$TimeSlotDataFromJson(Map<String, dynamic> json) {
  return TimeSlotData(
    start:
        json['start'] == null ? null : DateTime.parse(json['start'] as String),
    end: json['end'] == null ? null : DateTime.parse(json['end'] as String),
    registrationCount: json['registrationCount'] as int,
  );
}
