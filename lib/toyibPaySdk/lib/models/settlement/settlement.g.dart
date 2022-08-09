// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settlement.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Settlement _$SettlementFromJson(Map<String, dynamic> json) {
  return Settlement()
    ..userID = json['userID'] as String
    ..userName = json['userName'] as String
    ..settlementDate = json['settlementDate'] as String
    ..amount = json['amount'] as String
    ..amountNett = json['amountNett'] as String
    ..different = json['different'] as String
    ..standard = json['standard'] as String
    ..santai = json['santai'] as String
    ..creditCard = json['creditCard'] as String
    ..transaction = json['transaction'] as String;
}

Map<String, dynamic> _$SettlementToJson(Settlement instance) =>
    <String, dynamic>{
      'userID': instance.userID,
      'userName': instance.userName,
      'settlementDate': instance.settlementDate,
      'amount': instance.amount,
      'amountNett': instance.amountNett,
      'different': instance.different,
      'standard': instance.standard,
      'santai': instance.santai,
      'creditCard': instance.creditCard,
      'transaction': instance.transaction,
    };
