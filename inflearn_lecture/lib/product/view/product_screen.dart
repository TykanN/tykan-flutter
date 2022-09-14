import 'package:flutter/material.dart';
import 'package:inflearn_lecture/common/component/pagination_list_view.dart';
import 'package:inflearn_lecture/product/component/product_card.dart';
import 'package:inflearn_lecture/product/model/product_model.dart';
import 'package:inflearn_lecture/product/provider/product_provider.dart';
import 'package:inflearn_lecture/restaurant/view/restaurant_detail_screen.dart';

class ProductScreen extends StatelessWidget {
  const ProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PaginationListView<ProductModel>(
      provider: productProvider,
      itemBuilder: (context, index, model) {
        return GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => RestaurantDetailScreen(id: model.restaurant.id),
                ),
              );
            },
            child: ProductCard.fromProductModel(model: model));
      },
    );
  }
}
