// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'package.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Package _$PackageFromJson(Map<String, dynamic> json) {
  return Package()
    ..id = json['id'] as String
    ..package = json['package'] as String
    ..fee = json['fee'] as String
    ..status = json['status'] as String;
}

Map<String, dynamic> _$PackageToJson(Package instance) => <String, dynamic>{
      'id': instance.id,
      'package': instance.package,
      'fee': instance.fee,
      'status': instance.status,
    };
