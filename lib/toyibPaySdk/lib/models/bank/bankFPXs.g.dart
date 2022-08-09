// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bankFPXs.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BankFPXs _$BankFPXsFromJson(Map<String, dynamic> json) {
  return BankFPXs()
    ..bankFPXs = json['bankFPXs']
        ?.map((e) =>
            e == null ? null : BankFPX.fromJson(e as Map<String, dynamic>))
        ?.toList();
}

Map<String, dynamic> _$BankFPXsToJson(BankFPXs instance) => <String, dynamic>{
      'bankFPXs': instance.bankFPXs,
    };
