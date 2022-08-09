// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'userCreateds.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserCreateds _$UserCreatedsFromJson(Map<String, dynamic> json) {
  return UserCreateds()
    ..userCreateds = json['userCreateds']
        ?.map((e) =>
            e == null ? null : UserCreated.fromJson(e as Map<String, dynamic>))
        ?.toList();
}

Map<String, dynamic> _$UserCreatedsToJson(UserCreateds instance) =>
    <String, dynamic>{
      'userCreateds': instance.userCreateds,
    };
