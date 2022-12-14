import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inflearn_lecture/common/const/data.dart';
import 'package:inflearn_lecture/common/dio/dio.dart';
import 'package:inflearn_lecture/common/model/cursor_pagination_model.dart';
import 'package:inflearn_lecture/common/model/pagination_params.dart';
import 'package:inflearn_lecture/common/repository/base_pagination_repository.dart';
import 'package:inflearn_lecture/restaurant/model/restaurant_detail_model.dart';
import 'package:inflearn_lecture/restaurant/model/restaurant_model.dart';
import 'package:retrofit/retrofit.dart';

part 'restaurant_repository.g.dart';

final restaurantRepositoryProvider = Provider<RestaurantRepository>((ref) {
  final dio = ref.watch(dioProvider);
  final repository = RestaurantRepository(dio, baseUrl: '$host/restaurant');
  return repository;
});

@RestApi()
abstract class RestaurantRepository implements IBasePaginationRepository<RestaurantModel> {
  factory RestaurantRepository(Dio dio, {String baseUrl}) = _RestaurantRepository;

  @GET('')
  @Headers({MyKey.accessToken: 'true'})
  @override
  Future<CursorPagination<RestaurantModel>> paginate({
    @Queries() PaginationParams? paginationParams = const PaginationParams(),
  });

  @GET('/{id}')
  @Headers({MyKey.accessToken: 'true'})
  Future<RestaurantDetailModel> getRestaurantDetail({
    @Path('id') required String rid,
  });
}
