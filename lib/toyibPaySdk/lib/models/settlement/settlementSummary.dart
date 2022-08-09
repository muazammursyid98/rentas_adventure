import 'package:json_annotation/json_annotation.dart';

part 'settlementSummary.g.dart';

@JsonSerializable()
class SettlementSummary {
  SettlementSummary();

  String? userID;
  String? userName;
  String? today;
  @JsonKey(name: 'Amount_Pending')
  String? amountPending;
  @JsonKey(name: 'Amount_settle')
  String? amountSettle;
  @JsonKey(name: 'AmountNett_Pending')
  String? amountNettPending;
  @JsonKey(name: 'AmountNett_Settle')
  String? amountNettSettle;
  @JsonKey(name: 'Different_Pending')
  String? differentPending;
  @JsonKey(name: 'Different_Settle')
  String? differentSettle;
  @JsonKey(name: 'Standard_Pending')
  String? standardPending;
  @JsonKey(name: 'Standard_Settle')
  String? standardSettle;
  @JsonKey(name: 'Santai_Pending')
  String? santaiPending;
  @JsonKey(name: 'Santai_Settle')
  String? santaiSettle;
  @JsonKey(name: 'Creditcard_Pending')
  String? creditcardPending;
  @JsonKey(name: 'Creditcard_settle')
  String? creditcardSettle;
  @JsonKey(name: 'Transaction_Pending')
  String? transactionPending;
  @JsonKey(name: 'Trnsaction_Settle')
  String? trnsactionSettle;

  factory SettlementSummary.fromJson(Map<String, dynamic> json) =>
      _$SettlementSummaryFromJson(json);
  Map<String, dynamic> toJson() => _$SettlementSummaryToJson(this);
}
