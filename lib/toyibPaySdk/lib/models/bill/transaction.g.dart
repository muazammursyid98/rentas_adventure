// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Transaction _$TransactionFromJson(Map<String, dynamic> json) {
  return Transaction()
    ..billName = json['billName'] as String
    ..billDescription = json['billDescription'] as String
    ..billTo = json['billTo'] as String
    ..billEmail = json['billEmail'] as String
    ..billPhone = json['billPhone'] as String
    ..billStatus = json['billStatus'] as String
    ..billPermalink = json['billPermalink'] as String
    ..categoryCode = json['categoryCode'] as String
    ..categoryName = json['categoryName'] as String
    ..userName = json['userName'] as String
    ..billpaymentStatus = json['billpaymentStatus'] as String
    ..billpaymentAmount = json['billpaymentAmount'] as String
    ..billpaymentInvoiceNo = json['billpaymentInvoiceNo'] as String;
}

Map<String, dynamic> _$TransactionToJson(Transaction instance) =>
    <String, dynamic>{
      'billName': instance.billName,
      'billDescription': instance.billDescription,
      'billTo': instance.billTo,
      'billEmail': instance.billEmail,
      'billPhone': instance.billPhone,
      'billStatus': instance.billStatus,
      'billPermalink': instance.billPermalink,
      'categoryCode': instance.categoryCode,
      'categoryName': instance.categoryName,
      'userName': instance.userName,
      'billpaymentStatus': instance.billpaymentStatus,
      'billpaymentAmount': instance.billpaymentAmount,
      'billpaymentInvoiceNo': instance.billpaymentInvoiceNo,
    };
