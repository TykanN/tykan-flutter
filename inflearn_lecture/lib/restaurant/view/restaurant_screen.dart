import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inflearn_lecture/common/model/cursor_pagination_model.dart';
import 'package:inflearn_lecture/restaurant/component/restaurant_card.dart';
import 'package:inflearn_lecture/restaurant/model/restaurant_model.dart';
import 'package:inflearn_lecture/restaurant/repository/restaurant_repository.dart';
import 'package:inflearn_lecture/restaurant/view/restaurant_detail_screen.dart';

class RestaurantScreen extends ConsumerWidget {
  const RestaurantScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: FutureBuilder<CursorPagination<RestaurantModel>>(
          future: ref.watch(restaurantRepositoryProvider).paginate(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return ListView.separated(
              separatorBuilder: (_, index) => const SizedBox(height: 16.0),
              itemCount: snapshot.data!.data.length,
              itemBuilder: (_, index) {
                final item = snapshot.data!.data[index];

                return GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => RestaurantDetailScreen(
                          id: item.id,
                          restaurantModel: item,
                        ),
                      ),
                    );
                  },
                  child: RestaurantCard.fromModel(model: item),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
