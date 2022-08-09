import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  User();

  String? userDate;
  String? userId;
  String? userName;
  String? registrationNo;
  String? userFullname;
  String? userEmail;
  String? userPhone;
  @JsonKey(name: 'BankAccountNo')
  String? bankAccountNo;
  String? bankAccountName;
  String? bankName;
  String? userStatus;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
}
