import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

import 'location.dart';

part 'filter_settings.g.dart';

@JsonSerializable()
class FilterSettings extends Equatable {
  final LocationType locationType;
  final FillStatus minFillStatus;

  FilterSettings({
    @required this.locationType,
    @required this.minFillStatus,
  });

  @override
  List<Object> get props => [locationType, minFillStatus];

  @override
  String toString() => 'FilterSettings: $locationType, $minFillStatus';

  factory FilterSettings.fromJson(Map<String, dynamic> json) =>
      _$FilterSettingsFromJson(json);

  Map<String, dynamic> toJson() => _$FilterSettingsToJson(this);
}
