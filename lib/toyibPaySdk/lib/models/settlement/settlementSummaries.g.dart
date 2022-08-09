// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settlementSummaries.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SettlementSummaries _$SettlementSummariesFromJson(Map<String, dynamic> json) {
  return SettlementSummaries()
    ..settlementSummaries = json['settlementSummaries']
        ?.map((e) => e == null
            ? null
            : SettlementSummary.fromJson(e as Map<String, dynamic>))
        ?.toList();
}

Map<String, dynamic> _$SettlementSummariesToJson(
        SettlementSummaries instance) =>
    <String, dynamic>{
      'settlementSummaries': instance.settlementSummaries,
    };
