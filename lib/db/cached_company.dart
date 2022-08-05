import 'dart:ui';

import 'package:task_project/model/company_item.dart';

const String tableName = "cached_company";

class CachedCompanyFields {
  static const String id = "id";
  static const String carModel = "car_model";
  static const String averagePrice = "average_price";
  static const String logo = "logo";
  static const String isFavorite = "is_favorite";
  static const String establishedYear = "established_year";
}

class CachedCompany {
  CachedCompany({
    required this.isFavorite,
    required this.id,
    required this.averagePrice,
    required this.carModel,
    required this.establishedYear,
    required this.logo
  });

  final int id;
  final String carModel;
  final int averagePrice;
  final String logo;
  final int establishedYear;
  final int isFavorite;

  CachedCompany copyWith({
    int? id,
    String? carModel,
    int? averagePrice,
    String? logo,
    int? establishedYear,
    int? isFavorite,
  }) =>
      CachedCompany(
        isFavorite: isFavorite ?? this.isFavorite,
          id: id ?? this.id,
          logo: logo ?? this.logo,
        averagePrice: averagePrice ?? this.averagePrice,
        carModel: carModel ?? this.carModel,
        establishedYear: establishedYear ?? this.establishedYear
      );
  static CachedCompany fromJson(Map<String, Object?> json) =>
      CachedCompany(
        averagePrice: json[CachedCompanyFields.averagePrice] as int,
        carModel: json[CachedCompanyFields.carModel] as String,
        establishedYear: json[CachedCompanyFields.establishedYear] as int,
        logo: json[CachedCompanyFields.logo] as String,
        id: json[CachedCompanyFields.id] as int,
        isFavorite: json[CachedCompanyFields.isFavorite] as int,
      );
  Map<String, Object?> toJson() =>
      {
        CachedCompanyFields.id: id,
        CachedCompanyFields.carModel: carModel,
        CachedCompanyFields.averagePrice:averagePrice,
        CachedCompanyFields.logo: logo,
        CachedCompanyFields.establishedYear: establishedYear,
        CachedCompanyFields.isFavorite: isFavorite,
      };
}