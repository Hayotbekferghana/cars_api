import 'package:json_annotation/json_annotation.dart';

part 'company_item.g.dart';

@JsonSerializable(explicitToJson: true)
class CompanyItem {

  @JsonKey(defaultValue: 0, name: "id")
  int id;

  @JsonKey(defaultValue: "", name: "car_model")
  String carModel;

  @JsonKey(defaultValue: 0, name: "average_price")
  int averagePrice;

  @JsonKey(defaultValue: "", name: "logo")
  String logo;

  @JsonKey(defaultValue: 0, name: "established_year")
  int establishedYear;

  @JsonKey(defaultValue: "", name: "description")
  String description;

  @JsonKey(defaultValue: [], name: "car_pics")
  List<String> carPics;

  CompanyItem({
    required this.description,
    required this.carPics,
    required this.id,
    required this.carModel,
    required this.logo,
    required this.averagePrice,
    required this.establishedYear
  });

  factory CompanyItem.fromJson(Map<String, dynamic> json) => _$CompanyItemFromJson(json);


  Map<String, dynamic> toJson() => _$CompanyItemToJson(this);
}