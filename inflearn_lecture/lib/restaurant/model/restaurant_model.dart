import 'dart:convert';

import 'package:inflearn_lecture/common/const/data.dart';

enum RestaurantPriceRange {
  expensive,
  medium,
  cheap,
}

class RestaurantModel {
  final String id;
  final String name;
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

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'thumbUrl': thumbUrl,
      'tags': tags,
      'priceRange': priceRange.name,
      'ratings': ratings,
      'ratingsCount': ratingsCount,
      'deliveryTime': deliveryTime,
      'deliveryFee': deliveryFee,
    };
  }

  factory RestaurantModel.fromMap(Map<String, dynamic> map) {
    return RestaurantModel(
      id: map['id'],
      name: map['name'],
      thumbUrl: '$host${map['thumbUrl']}',
      tags: List<String>.from(map['tags']),
      priceRange: RestaurantPriceRange.values
          .firstWhere((e) => e.name == map['priceRange']),
      ratings: map['ratings'],
      ratingsCount: map['ratingsCount'],
      deliveryTime: map['deliveryTime'],
      deliveryFee: map['deliveryFee'],
    );
  }

  String toJson() => json.encode(toMap());
  factory RestaurantModel.fromJson(String source) =>
      RestaurantModel.fromMap(json.decode(source));
}
