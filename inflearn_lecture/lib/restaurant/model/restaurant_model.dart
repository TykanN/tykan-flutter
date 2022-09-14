import 'package:inflearn_lecture/common/model/model_with_id.dart';
import 'package:inflearn_lecture/common/utils/data_utils.dart';
import 'package:json_annotation/json_annotation.dart';

part 'restaurant_model.g.dart';

enum RestaurantPriceRange {
  expensive,
  medium,
  cheap,
}

@JsonSerializable()
class RestaurantModel implements IModelWithId {
  @override
  final String id;
  final String name;
  @JsonKey(
    fromJson: DataUtils.pathToUrl,
  )
  final String thumbUrl;
  final List<String> tags;
  final RestaurantPriceRange priceRange;
  final double ratings;
  final int ratingsCount;
  final int deliveryTime;
  final int deliveryFee;

  RestaurantModel({
    required this.id,
    required this.name,
    required this.thumbUrl,
    required this.tags,
    required this.priceRange,
    required this.ratings,
    required this.ratingsCount,
    required this.deliveryTime,
    required this.deliveryFee,
  });

  Map<String, dynamic> toJson() => _$RestaurantModelToJson(this);

  factory RestaurantModel.fromJson(Map<String, dynamic> json) => _$RestaurantModelFromJson(json);

  // factory RestaurantModel.fromMap(Map<String, dynamic> map) {
  //   return RestaurantModel(
  //     id: map['id'],
  //     name: map['name'],
  //     thumbUrl: '$host${map['thumbUrl']}',
  //     tags: List<String>.from(map['tags']),
  //     priceRange: RestaurantPriceRange.values.firstWhere((e) => e.name == map['priceRange']),
  //     ratings: map['ratings'],
  //     ratingsCount: map['ratingsCount'],
  //     deliveryTime: map['deliveryTime'],
  //     deliveryFee: map['deliveryFee'],
  //   );
  // }
}
