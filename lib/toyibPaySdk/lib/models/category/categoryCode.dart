import 'package:json_annotation/json_annotation.dart';

part 'categoryCode.g.dart';

@JsonSerializable()
class CategoryCode {
  CategoryCode();

  @JsonKey(name: 'CategoryCode')
  String? categoryCode;

  factory CategoryCode.fromJson(Map<String, dynamic> json) =>
      _$CategoryCodeFromJson(json);
  Map<String, dynamic> toJson() => _$CategoryCodeToJson(this);
}
