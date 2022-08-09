// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'userStatuses.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserStatuses _$UserStatusesFromJson(Map<String, dynamic> json) {
  return UserStatuses()
    ..userStatuses = json['userStatuses']
        ?.map((e) =>
            e == null ? null : UserStatus.fromJson(e as Map<String, dynamic>))
        ?.toList();
}

Map<String, dynamic> _$UserStatusesToJson(UserStatuses instance) =>
    <String, dynamic>{
      'userStatuses': instance.userStatuses,
    };
