import 'package:json_annotation/json_annotation.dart';

import 'userStatus.dart';

part 'userStatuses.g.dart';

@JsonSerializable()
class UserStatuses {
  UserStatuses();

  List<UserStatus>? userStatuses;

  factory UserStatuses.fromJson(Map<String, dynamic> json) =>
      _$UserStatusesFromJson(json);
  Map<String, dynamic> toJson() => _$UserStatusesToJson(this);
}
