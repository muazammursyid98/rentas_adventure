// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bill.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Bill _$BillFromJson(Map<String, dynamic> json) {
  return Bill()
    ..billDate = json['billDate'] as String
    ..iD = json['ID'] as String
    ..nAME = json['NAME'] as String
    ..billDescription = json['billDescription'] as String
    ..fixPrice = json['fixPrice'] as String
    ..billTo = json['billTo'] as String
    ..billEmail = json['billEmail'] as String
    ..billPhone = json['billPhone'] as String
    ..billStatus = json['billStatus'] as String
    ..billCode = json['billCode'] as String
    ..billAmount = json['billAmount'] as String
    ..categoryCode = json['categoryCode'] as String
    ..categoryName = json['categoryName'] as String
    ..userName = json['userName'] as String;
}

Map<String, dynamic> _$BillToJson(Bill instance) => <String, dynamic>{
      'billDate': instance.billDate,
      'ID': instance.iD,
      'NAME': instance.nAME,
      'billDescription': instance.billDescription,
      'fixPrice': instance.fixPrice,
      'billTo': instance.billTo,
      'billEmail': instance.billEmail,
      'billPhone': instance.billPhone,
      'billStatus': instance.billStatus,
      'billCode': instance.billCode,
      'billAmount': instance.billAmount,
      'categoryCode': instance.categoryCode,
      'categoryName': instance.categoryName,
      'userName': instance.userName,
    };
