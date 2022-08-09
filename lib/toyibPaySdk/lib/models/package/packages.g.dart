// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'packages.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Packages _$PackagesFromJson(Map<String, dynamic> json) {
  return Packages()
    ..packages = json['packages']
        ?.map((e) =>
            e == null ? null : Package.fromJson(e as Map<String, dynamic>))
        ?.toList();
}

Map<String, dynamic> _$PackagesToJson(Packages instance) => <String, dynamic>{
      'packages': instance.packages,
    };
