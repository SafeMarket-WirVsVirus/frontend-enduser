// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'filter_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FilterSettings _$FilterSettingsFromJson(Map<String, dynamic> json) {
  return FilterSettings(
    locationType:
        _$enumDecodeNullable(_$LocationTypeEnumMap, json['locationType']),
    minFillStatus:
        _$enumDecodeNullable(_$FillStatusEnumMap, json['minFillStatus']),
  );
}

Map<String, dynamic> _$FilterSettingsToJson(FilterSettings instance) =>
    <String, dynamic>{
      'locationType': _$LocationTypeEnumMap[instance.locationType],
      'minFillStatus': _$FillStatusEnumMap[instance.minFillStatus],
    };

T _$enumDecode<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    throw ArgumentError('A value must be provided. Supported values: '
        '${enumValues.values.join(', ')}');
  }

  final value = enumValues.entries
      .singleWhere((e) => e.value == source, orElse: () => null)
      ?.key;

  if (value == null && unknownValue == null) {
    throw ArgumentError('`$source` is not one of the supported values: '
        '${enumValues.values.join(', ')}');
  }
  return value ?? unknownValue;
}

T _$enumDecodeNullable<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    return null;
  }
  return _$enumDecode<T>(enumValues, source, unknownValue: unknownValue);
}

const _$LocationTypeEnumMap = {
  LocationType.supermarket: 'supermarket',
  LocationType.bakery: 'bakery',
  LocationType.pharmacy: 'pharmacy',
};

const _$FillStatusEnumMap = {
  FillStatus.green: 'green',
  FillStatus.yellow: 'yellow',
  FillStatus.red: 'red',
};
