import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inflearn_lecture/common/model/cursor_pagination_model.dart';
import 'package:inflearn_lecture/common/provider/pagination_provider.dart';
import 'package:inflearn_lecture/rating/model/rating_model.dart';
import 'package:inflearn_lecture/restaurant/repository/restaurant_rating_repository.dart';

final restaurantRatingProvider =
    StateNotifierProvider.family<RestaurantRatingNotifier, CursorPaginationBase, String>((ref, id) {
  final repository = ref.watch(restaurantRatingRepositoyProvider(id));
  return RestaurantRatingNotifier(repository: repository);
});

class RestaurantRatingNotifier extends PaginationProvider<RatingModel, RestaurantRatingRepository> {
  RestaurantRatingNotifier({
    required super.repository,
  });
}
