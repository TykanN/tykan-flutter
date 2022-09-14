import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inflearn_lecture/common/const/data.dart';
import 'package:inflearn_lecture/common/dio/dio.dart';
import 'package:inflearn_lecture/common/model/cursor_pagination_model.dart';
import 'package:inflearn_lecture/common/model/pagination_params.dart';
import 'package:inflearn_lecture/common/repository/base_pagination_repository.dart';
import 'package:inflearn_lecture/rating/model/rating_model.dart';
import 'package:retrofit/retrofit.dart';

part 'restaurant_rating_repository.g.dart';

final restaurantRatingRepositoyProvider = Provider.family<RestaurantRatingRepository, String>((ref, id) {
  final dio = ref.watch(dioProvider);
  return RestaurantRatingRepository(dio, baseUrl: '$host/restaurant/$id/rating');
});

@RestApi()
abstract class RestaurantRatingRepository implements IBasePaginationRepository<RatingModel> {
  factory RestaurantRatingRepository(Dio dio, {String baseUrl}) = _RestaurantRatingRepository;

  @GET('')
  @Headers({MyKey.accessToken: 'true'})
  @override
  Future<CursorPagination<RatingModel>> paginate({
    @Queries() PaginationParams? paginationParams = const PaginationParams(),
  });
}
