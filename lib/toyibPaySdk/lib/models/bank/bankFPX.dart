import 'package:json_annotation/json_annotation.dart';

part 'bankFPX.g.dart';

@JsonSerializable()
class BankFPX {
  BankFPX();

  @JsonKey(name: 'CODE')
  String? cODE;
  @JsonKey(name: 'NAME')
  String? nAME;

  factory BankFPX.fromJson(Map<String, dynamic> json) =>
      _$BankFPXFromJson(json);
  Map<String, dynamic> toJson() => _$BankFPXToJson(this);
}
