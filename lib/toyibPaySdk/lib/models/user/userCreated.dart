import 'package:json_annotation/json_annotation.dart';

part 'userCreated.g.dart';

@JsonSerializable()
class UserCreated {
  UserCreated();

  @JsonKey(name: 'UserSecretKey')
  String? userSecretKey;

  factory UserCreated.fromJson(Map<String, dynamic> json) =>
      _$UserCreatedFromJson(json);
  Map<String, dynamic> toJson() => _$UserCreatedToJson(this);
}
