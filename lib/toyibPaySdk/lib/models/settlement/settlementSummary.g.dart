// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settlementSummary.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SettlementSummary _$SettlementSummaryFromJson(Map<String, dynamic> json) {
  return SettlementSummary()
    ..userID = json['userID'] as String
    ..userName = json['userName'] as String
    ..today = json['today'] as String
    ..amountPending = json['Amount_Pending'] as String
    ..amountSettle = json['Amount_settle'] as String
    ..amountNettPending = json['AmountNett_Pending'] as String
    ..amountNettSettle = json['AmountNett_Settle'] as String
    ..differentPending = json['Different_Pending'] as String
    ..differentSettle = json['Different_Settle'] as String
    ..standardPending = json['Standard_Pending'] as String
    ..standardSettle = json['Standard_Settle'] as String
    ..santaiPending = json['Santai_Pending'] as String
    ..santaiSettle = json['Santai_Settle'] as String
    ..creditcardPending = json['Creditcard_Pending'] as String
    ..creditcardSettle = json['Creditcard_settle'] as String
    ..transactionPending = json['Transaction_Pending'] as String
    ..trnsactionSettle = json['Trnsaction_Settle'] as String;
}

Map<String, dynamic> _$SettlementSummaryToJson(SettlementSummary instance) =>
    <String, dynamic>{
      'userID': instance.userID,
      'userName': instance.userName,
      'today': instance.today,
      'Amount_Pending': instance.amountPending,
      'Amount_settle': instance.amountSettle,
      'AmountNett_Pending': instance.amountNettPending,
      'AmountNett_Settle': instance.amountNettSettle,
      'Different_Pending': instance.differentPending,
      'Different_Settle': instance.differentSettle,
      'Standard_Pending': instance.standardPending,
      'Standard_Settle': instance.standardSettle,
      'Santai_Pending': instance.santaiPending,
      'Santai_Settle': instance.santaiSettle,
      'Creditcard_Pending': instance.creditcardPending,
      'Creditcard_settle': instance.creditcardSettle,
      'Transaction_Pending': instance.transactionPending,
      'Trnsaction_Settle': instance.trnsactionSettle,
    };
