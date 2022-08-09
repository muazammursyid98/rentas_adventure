// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'banksFPXs.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BanksFPXs _$BanksFPXsFromJson(Map<String, dynamic> json) {
  return BanksFPXs()
    ..banks = json['banks']
        ?.map(
            (e) => e == null ? null : Bank.fromJson(e as Map<String, dynamic>))
        ?.toList();
}

Map<String, dynamic> _$BanksFPXsToJson(BanksFPXs instance) => <String, dynamic>{
      'banks': instance.banks,
    };
