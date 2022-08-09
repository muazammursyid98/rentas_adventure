// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bank.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Bank _$BankFromJson(Map<String, dynamic> json) {
  return Bank()
    ..id = json['id'] as String
    ..bank = json['bank'] as String
    ..status = json['status'] as String;
}

Map<String, dynamic> _$BankToJson(Bank instance) => <String, dynamic>{
      'id': instance.id,
      'bank': instance.bank,
      'status': instance.status,
    };
