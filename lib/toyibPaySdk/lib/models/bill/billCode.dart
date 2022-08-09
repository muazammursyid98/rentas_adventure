import 'package:json_annotation/json_annotation.dart';

part 'billCode.g.dart';

@JsonSerializable()
class BillCode {
  BillCode();

  @JsonKey(name: 'BillCode')
  String? billCode;

  factory BillCode.fromJson(Map<String, dynamic> json) =>
      _$BillCodeFromJson(json);
  Map<String, dynamic> toJson() => _$BillCodeToJson(this);
}
