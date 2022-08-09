import 'package:json_annotation/json_annotation.dart';

import 'bankFPX.dart';

part 'bankFPXs.g.dart';

@JsonSerializable()
class BankFPXs {
  BankFPXs();

  List<BankFPX>? bankFPXs;

  factory BankFPXs.fromJson(Map<String, dynamic> json) =>
      _$BankFPXsFromJson(json);
  Map<String, dynamic> toJson() => _$BankFPXsToJson(this);
}
