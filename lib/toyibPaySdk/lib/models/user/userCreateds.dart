import 'package:json_annotation/json_annotation.dart';

import 'userCreated.dart';

part 'userCreateds.g.dart';

@JsonSerializable()
class UserCreateds {
  UserCreateds();

  List<UserCreated>? userCreateds;

  factory UserCreateds.fromJson(Map<String, dynamic> json) =>
      _$UserCreatedsFromJson(json);
  Map<String, dynamic> toJson() => _$UserCreatedsToJson(this);
}
