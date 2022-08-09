// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Category _$CategoryFromJson(Map<String, dynamic> json) {
  return Category()
    ..categoryName = json['CategoryName'] as String
    ..categoryDescription = json['categoryDescription'] as String
    ..categoryStatus = json['categoryStatus'] as String;
}

Map<String, dynamic> _$CategoryToJson(Category instance) => <String, dynamic>{
      'CategoryName': instance.categoryName,
      'categoryDescription': instance.categoryDescription,
      'categoryStatus': instance.categoryStatus,
    };
