import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:inflearn_lecture/common/component/pagination_list_view.dart';
import 'package:inflearn_lecture/common/utils/page_stroage.dart';
import 'package:inflearn_lecture/restaurant/component/restaurant_card.dart';
import 'package:inflearn_lecture/restaurant/model/restaurant_model.dart';
import 'package:inflearn_lecture/restaurant/provider/restaurant_provider.dart';
import 'package:inflearn_lecture/restaurant/view/restaurant_detail_screen.dart';

class RestaurantScreen extends StatelessWidget {
  const RestaurantScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PaginationListView<RestaurantModel>(
      pageStorageKeyValue: PageStorageUtils.mainRestaurant,
      provider: restaurantProvider,
      itemBuilder: (context, index, model) {
        return GestureDetector(
          onTap: () {
            context.goNamed(
              RestaurantDetailScreen.routeName,
              params: {'rid': model.id},
            );
          },
          child: RestaurantCard.fromModel(model: model),
        );
      },
    );
  }
}
