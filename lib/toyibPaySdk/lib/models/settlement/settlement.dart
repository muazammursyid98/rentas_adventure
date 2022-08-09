import 'package:json_annotation/json_annotation.dart';

part 'settlement.g.dart';

@JsonSerializable()
class Settlement {
  Settlement();

  String? userID;
  String? userName;
  String? settlementDate;
  String? amount;
  String? amountNett;
  String? different;
  String? standard;
  String? santai;
  String? creditCard;
  String? transaction;

  factory Settlement.fromJson(Map<String, dynamic> json) =>
      _$SettlementFromJson(json);
  Map<String, dynamic> toJson() => _$SettlementToJson(this);
}
