// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'categoryCodes.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CategoryCodes _$CategoryCodesFromJson(Map<String, dynamic> json) {
  return CategoryCodes()
    ..categoryCodes = json['categoryCodes']
        ?.map((e) =>
            e == null ? null : CategoryCode.fromJson(e as Map<String, dynamic>))
        ?.toList();
}

Map<String, dynamic> _$CategoryCodesToJson(CategoryCodes instance) =>
    <String, dynamic>{
      'categoryCodes': instance.categoryCodes,
    };
