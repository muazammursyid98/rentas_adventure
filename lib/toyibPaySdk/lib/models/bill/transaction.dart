import 'package:json_annotation/json_annotation.dart';

part 'transaction.g.dart';

@JsonSerializable()
class Transaction {
  Transaction();

  String? billName;
  String? billDescription;
  String? billTo;
  String? billEmail;
  String? billPhone;
  String? billStatus;
  String? billPermalink;
  String? categoryCode;
  String? categoryName;
  String? userName;
  String? billpaymentStatus;
  String? billpaymentAmount;
  String? billpaymentInvoiceNo;

  factory Transaction.fromJson(Map<String, dynamic> json) =>
      _$TransactionFromJson(json);
  Map<String, dynamic> toJson() => _$TransactionToJson(this);
}
