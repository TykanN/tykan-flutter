import 'package:dio/dio.dart' hide Headers;
import 'package:inflearn_lecture/common/const/data.dart';
import 'package:inflearn_lecture/common/model/cursor_pagination_model.dart';
import 'package:inflearn_lecture/restaurant/model/restaurant_detail_model.dart';
import 'package:inflearn_lecture/restaurant/model/restaurant_model.dart';
import 'package:retrofit/retrofit.dart';

part 'restaurant_repository.g.dart';

@RestApi()
abstract class RestaurantRepository {
  factory RestaurantRepository(Dio dio, {String baseUrl}) = _RestaurantRepository;

  @GET('')
  @Headers({MyKey.accessToken: 'true'})
  Future<CursorPagination<RestaurantModel>> paginate();

  @GET('/{id}')
  @Headers({MyKey.accessToken: 'true'})
  Future<RestaurantDetailModel> getRestaurantDetail({
    @Path('id') required String rid,
  });
}