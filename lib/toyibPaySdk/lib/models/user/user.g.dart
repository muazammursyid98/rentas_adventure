// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) {
  return User()
    ..userDate = json['userDate'] as String
    ..userId = json['userId'] as String
    ..userName = json['userName'] as String
    ..registrationNo = json['registrationNo'] as String
    ..userFullname = json['userFullname'] as String
    ..userEmail = json['userEmail'] as String
    ..userPhone = json['userPhone'] as String
    ..bankAccountNo = json['BankAccountNo'] as String
    ..bankAccountName = json['bankAccountName'] as String
    ..bankName = json['bankName'] as String
    ..userStatus = json['userStatus'] as String;
}

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'userDate': instance.userDate,
      'userId': instance.userId,
      'userName': instance.userName,
      'registrationNo': instance.registrationNo,
      'userFullname': instance.userFullname,
      'userEmail': instance.userEmail,
      'userPhone': instance.userPhone,
      'BankAccountNo': instance.bankAccountNo,
      'bankAccountName': instance.bankAccountName,
      'bankName': instance.bankName,
      'userStatus': instance.userStatus,
    };
