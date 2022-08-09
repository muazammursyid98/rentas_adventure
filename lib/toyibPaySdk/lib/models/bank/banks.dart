import 'package:json_annotation/json_annotation.dart';

import 'bank.dart';

part 'banks.g.dart';

@JsonSerializable()
class Banks {
  Banks();

  List<Bank>? banks;

  factory Banks.fromJson(Map<String, dynamic> json) => _$BanksFromJson(json);
  Map<String, dynamic> toJson() => _$BanksToJson(this);
}
