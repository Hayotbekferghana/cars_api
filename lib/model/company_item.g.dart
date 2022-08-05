// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'company_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CompanyItem _$CompanyItemFromJson(Map<String, dynamic> json) => CompanyItem(
      description: json['description'] as String? ?? '',
      carPics: (json['car_pics'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      id: json['id'] as int? ?? 0,
      carModel: json['car_model'] as String? ?? '',
      logo: json['logo'] as String? ?? '',
      averagePrice: json['average_price'] as int? ?? 0,
      establishedYear: json['established_year'] as int? ?? 0,
    );

Map<String, dynamic> _$CompanyItemToJson(CompanyItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'car_model': instance.carModel,
      'average_price': instance.averagePrice,
      'logo': instance.logo,
      'established_year': instance.establishedYear,
      'description': instance.description,
      'car_pics': instance.carPics,
    };
