// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settlements.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Settlements _$SettlementsFromJson(Map<String, dynamic> json) {
  return Settlements()
    ..settlements = json['settlements']
        ?.map((e) =>
            e == null ? null : Settlement.fromJson(e as Map<String, dynamic>))
        ?.toList();
}

Map<String, dynamic> _$SettlementsToJson(Settlements instance) =>
    <String, dynamic>{
      'settlements': instance.settlements,
    };
