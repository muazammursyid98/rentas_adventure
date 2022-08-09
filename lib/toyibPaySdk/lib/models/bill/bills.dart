import 'package:json_annotation/json_annotation.dart';

import 'bill.dart';

part 'bills.g.dart';

@JsonSerializable()
class Bills {
  Bills();

  List<Bill>? bills;

  factory Bills.fromJson(Map<String, dynamic> json) => _$BillsFromJson(json);
  Map<String, dynamic> toJson() => _$BillsToJson(this);
}
