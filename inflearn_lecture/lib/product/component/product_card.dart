import 'package:flutter/material.dart';
import 'package:inflearn_lecture/common/const/colors.dart';
import 'package:inflearn_lecture/product/model/product_model.dart';
import 'package:inflearn_lecture/restaurant/model/restaurant_detail_model.dart';

class ProductCard extends StatelessWidget {
  final String imgUrl;
  final String name;
  final String detail;
  final int price;
  final String id;

  const ProductCard({
    super.key,
    required this.imgUrl,
    required this.name,
    required this.detail,
    required this.price,
    required this.id,
  });

  factory ProductCard.fromProductModel({required ProductModel model}) {
    return ProductCard(
      imgUrl: model.imgUrl,
      name: model.name,
      detail: model.detail,
      price: model.price,
      id: model.id,
    );
  }

  factory ProductCard.fromRestaurantProductModel({required RestaurantProductModel model}) {
    return ProductCard(
      imgUrl: model.imgUrl,
      name: model.name,
      detail: model.detail,
      price: model.price,
      id: model.id,
    );
  }

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Image.network(
              imgUrl,
              width: 110,
              height: 110,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  detail,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: MyColor.bodyText,
                    fontSize: 14.0,
                  ),
                ),
                Text(
                  '₩$price',
                  textAlign: TextAlign.right,
                  style: const TextStyle(
                    color: MyColor.primary,
                    fontSize: 12.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
