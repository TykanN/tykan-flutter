import 'package:flutter/material.dart';
import 'package:inflearn_lecture/common/component/pagination_list_view.dart';
import 'package:inflearn_lecture/restaurant/component/restaurant_card.dart';
import 'package:inflearn_lecture/restaurant/model/restaurant_model.dart';
import 'package:inflearn_lecture/restaurant/provider/restaurant_provider.dart';
import 'package:inflearn_lecture/restaurant/view/restaurant_detail_screen.dart';

class RestaurantScreen extends StatelessWidget {
  const RestaurantScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PaginationListView<RestaurantModel>(
      provider: restaurantProvider,
      itemBuilder: (context, index, model) {
        return GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => RestaurantDetailScreen(
                  id: model.id,
                ),
              ),
            );
          },
          child: RestaurantCard.fromModel(model: model),
        );
      },
    );
  }
}
