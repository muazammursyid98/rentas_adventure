// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'banks.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Banks _$BanksFromJson(Map<String, dynamic> json) {
  return Banks()
    ..banks = json['banks']
        ?.map(
            (e) => e == null ? null : Bank.fromJson(e as Map<String, dynamic>))
        ?.toList();
}

Map<String, dynamic> _$BanksToJson(Banks instance) => <String, dynamic>{
      'banks': instance.banks,
    };
