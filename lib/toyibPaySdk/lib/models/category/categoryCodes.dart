import 'package:json_annotation/json_annotation.dart';

import 'categoryCode.dart';

part 'categoryCodes.g.dart';

@JsonSerializable()
class CategoryCodes {
  CategoryCodes();

  List<CategoryCode>? categoryCodes;

  factory CategoryCodes.fromJson(Map<String, dynamic> json) =>
      _$CategoryCodesFromJson(json);
  Map<String, dynamic> toJson() => _$CategoryCodesToJson(this);
}
