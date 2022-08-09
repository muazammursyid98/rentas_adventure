import 'package:json_annotation/json_annotation.dart';

import 'package.dart';

part 'packages.g.dart';

@JsonSerializable()
class Packages {
  Packages();

  List<Package>? packages;

  factory Packages.fromJson(Map<String, dynamic> json) =>
      _$PackagesFromJson(json);
  Map<String, dynamic> toJson() => _$PackagesToJson(this);
}
