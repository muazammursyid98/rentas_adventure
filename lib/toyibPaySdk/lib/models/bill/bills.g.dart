// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bills.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Bills _$BillsFromJson(Map<String, dynamic> json) {
  return Bills()
    ..bills = json['bills']
        ?.map(
            (e) => e == null ? null : Bill.fromJson(e as Map<String, dynamic>))
        ?.toList();
}

Map<String, dynamic> _$BillsToJson(Bills instance) => <String, dynamic>{
      'bills': instance.bills,
    };
