import 'package:json_annotation/json_annotation.dart';

part 'userStatus.g.dart';

@JsonSerializable()
class UserStatus {
  UserStatus();

  String? status;

  factory UserStatus.fromJson(Map<String, dynamic> json) =>
      _$UserStatusFromJson(json);
  Map<String, dynamic> toJson() => _$UserStatusToJson(this);
}
