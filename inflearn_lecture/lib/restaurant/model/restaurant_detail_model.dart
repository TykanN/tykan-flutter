import 'package:inflearn_lecture/common/utils/data_utils.dart';

import 'package:inflearn_lecture/restaurant/model/restaurant_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'restaurant_detail_model.g.dart';

@JsonSerializable()
class RestaurantDetailModel extends RestaurantModel {
  final String detail;
  final List<RestaurantProductModel> products;

  RestaurantDetailModel({
    required super.id,
    required super.name,
    @JsonKey(
      fromJson: DataUtils.pathToUrl,
    )
        required super.thumbUrl,
    required super.tags,
    required super.priceRange,
    required super.ratings,
    required super.ratingsCount,
    required super.deliveryTime,
    required super.deliveryFee,
    required this.detail,
    required this.products,
  });

  @override
  Map<String, dynamic> toJson() => _$RestaurantDetailModelToJson(this);

  factory RestaurantDetailModel.fromJson(Map<String, dynamic> json) => _$RestaurantDetailModelFromJson(json);

  // factory RestaurantDetailModel.fromMap(Map<String, dynamic> map) {
  //   return RestaurantDetailModel(
  //     id: map['id'],
  //     name: map['name'],
  //     thumbUrl: '$host${map['thumbUrl']}',
  //     tags: List<String>.from(map['tags']),
  //     priceRange: RestaurantPriceRange.values.firstWhere((e) => e.name == map['priceRange']),
  //     ratings: map['ratings'],
  //     ratingsCount: map['ratingsCount'],
  //     deliveryTime: map['deliveryTime'],
  //     deliveryFee: map['deliveryFee'],
  //     detail: map['detail'],
  //     products: List<RestaurantProductModel>.from(
  //       map['products'].map((x) => RestaurantProductModel.fromJson(x)),
  //     ),
  //   );
  // }
}

@JsonSerializable()
class RestaurantProductModel {
  final String id;
  final String name;
  @JsonKey(
    fromJson: DataUtils.pathToUrl,
  )
  final String imgUrl;
  final String detail;
  final int price;

  RestaurantProductModel({
    required this.id,
    required this.name,
    required this.imgUrl,
    required this.detail,
    required this.price,
  });

  Map<String, dynamic> toJson() => _$RestaurantProductModelToJson(this);

  factory RestaurantProductModel.fromJson(Map<String, dynamic> json) => _$RestaurantProductModelFromJson(json);
}
