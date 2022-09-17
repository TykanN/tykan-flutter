import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:inflearn_lecture/common/const/colors.dart';
import 'package:inflearn_lecture/product/model/product_model.dart';
import 'package:inflearn_lecture/restaurant/model/restaurant_detail_model.dart';
import 'package:inflearn_lecture/user/provider/basket_provider.dart';

class ProductCard extends ConsumerWidget {
  final String imgUrl;
  final String name;
  final String detail;
  final int price;
  final String id;
  final VoidCallback? onSubtract;
  final VoidCallback? onAdd;

  const ProductCard({
    Key? key,
    required this.imgUrl,
    required this.name,
    required this.detail,
    required this.price,
    required this.id,
    this.onSubtract,
    this.onAdd,
  }) : super(key: key);

  factory ProductCard.fromProductModel({
    required ProductModel model,
    VoidCallback? onSubtract,
    VoidCallback? onAdd,
  }) {
    return ProductCard(
      imgUrl: model.imgUrl,
      name: model.name,
      detail: model.detail,
      price: model.price,
      id: model.id,
      onSubtract: onSubtract,
      onAdd: onAdd,
    );
  }

  factory ProductCard.fromRestaurantProductModel({
    required RestaurantProductModel model,
    VoidCallback? onSubtract,
    VoidCallback? onAdd,
  }) {
    return ProductCard(
      imgUrl: model.imgUrl,
      name: model.name,
      detail: model.detail,
      price: model.price,
      id: model.id,
      onSubtract: onSubtract,
      onAdd: onAdd,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final basket = ref.watch(basketProvider);
    return Column(
      children: [
        IntrinsicHeight(
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
        ),
        if (onSubtract != null && onAdd != null)
          Builder(
            builder: (context) {
              final item = basket.firstWhere((e) => e.product.id == id);
              return Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: _Footer(
                  total: (item.count * item.product.price).toString(),
                  count: item.count,
                  onSubtract: onSubtract!,
                  onAdd: onAdd!,
                ),
              );
            },
          ),
      ],
    );
  }
}

class _Footer extends StatelessWidget {
  final String total;
  final int count;
  final VoidCallback onSubtract;
  final VoidCallback onAdd;

  const _Footer({
    Key? key,
    required this.total,
    required this.count,
    required this.onSubtract,
    required this.onAdd,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            '총액 ₩$total',
            style: const TextStyle(
              color: MyColor.primary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Row(
          children: [
            _renderButton(
              icon: Icons.remove,
              onTap: onSubtract,
            ),
            const SizedBox(width: 8.0),
            Text(
              count.toString(),
              style: const TextStyle(
                color: MyColor.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 8.0),
            _renderButton(
              icon: Icons.add,
              onTap: onAdd,
            )
          ],
        ),
      ],
    );
  }

  Widget _renderButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: MyColor.primary, width: 1.0),
      ),
      child: InkWell(
        onTap: onTap,
        child: Icon(
          icon,
          color: MyColor.primary,
        ),
      ),
    );
  }
}
