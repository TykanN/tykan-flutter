import 'package:flutter/material.dart';
import 'package:inflearn_lecture/common/const/colors.dart';
import 'package:inflearn_lecture/restaurant/model/restaurant_detail_model.dart';

class ProductCard extends StatelessWidget {
  final RestaurantProductModel product;
  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Image.network(
              product.imgUrl,
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
                  product.name,
                  style: const TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  product.detail,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: MyColor.bodyText,
                    fontSize: 14.0,
                  ),
                ),
                Text(
                  '₩${product.price}',
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
