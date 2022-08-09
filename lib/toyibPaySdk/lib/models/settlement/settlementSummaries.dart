import 'package:json_annotation/json_annotation.dart';

import 'settlementSummary.dart';

part 'settlementSummaries.g.dart';

@JsonSerializable()
class SettlementSummaries {
  SettlementSummaries();

  List<SettlementSummary>? settlementSummaries;

  factory SettlementSummaries.fromJson(Map<String, dynamic> json) =>
      _$SettlementSummariesFromJson(json);
  Map<String, dynamic> toJson() => _$SettlementSummariesToJson(this);
}
