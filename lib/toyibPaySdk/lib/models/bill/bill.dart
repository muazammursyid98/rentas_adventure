import 'package:json_annotation/json_annotation.dart';

part 'bill.g.dart';

@JsonSerializable()
class Bill {
  Bill();

  String? billDate;
  @JsonKey(name: 'ID')
  String? iD;
  @JsonKey(name: 'NAME')
  String? nAME;
  String? billDescription;
  String? fixPrice;
  String? billTo;
  String? billEmail;
  String? billPhone;
  String? billStatus;
  String? billCode;
  String? billAmount;
  String? categoryCode;
  String? categoryName;
  String? userName;

  factory Bill.fromJson(Map<String, dynamic> json) => _$BillFromJson(json);
  Map<String, dynamic> toJson() => _$BillToJson(this);
}
