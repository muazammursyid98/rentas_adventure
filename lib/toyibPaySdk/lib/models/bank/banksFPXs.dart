import 'package:json_annotation/json_annotation.dart';

import 'bank.dart';

part 'banksFPXs.g.dart';

@JsonSerializable()
class BanksFPXs {
  BanksFPXs();

  List<Bank>? banks;

  factory BanksFPXs.fromJson(Map<String, dynamic> json) =>
      _$BanksFPXsFromJson(json);
  Map<String, dynamic> toJson() => _$BanksFPXsToJson(this);
}
