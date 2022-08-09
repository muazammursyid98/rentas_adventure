import 'package:json_annotation/json_annotation.dart';

import 'settlement.dart';

part 'settlements.g.dart';

@JsonSerializable()
class Settlements {
  Settlements();

  List<Settlement>? settlements;

  factory Settlements.fromJson(Map<String, dynamic> json) =>
      _$SettlementsFromJson(json);
  Map<String, dynamic> toJson() => _$SettlementsToJson(this);
}
