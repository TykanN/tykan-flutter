import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inflearn_lecture/common/const/data.dart';
import 'package:inflearn_lecture/common/dio/dio.dart';
import 'package:inflearn_lecture/common/model/cursor_pagination_model.dart';
import 'package:inflearn_lecture/common/model/pagination_params.dart';
import 'package:inflearn_lecture/common/repository/base_pagination_repository.dart';
import 'package:inflearn_lecture/order/model/order_model.dart';
import 'package:inflearn_lecture/order/model/post_order_body.dart';
import 'package:retrofit/retrofit.dart';

part 'order_repository.g.dart';

final orderRepositoryProvider = Provider<OrderRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return OrderRepository(dio, baseUrl: '$host/order');
});

@RestApi()
abstract class OrderRepository implements IBasePaginationRepository<OrderModel> {
  factory OrderRepository(Dio dio, {String baseUrl}) = _OrderRepository;

  @override
  @GET('')
  @Headers({
    MyKey.accessToken: 'true',
  })
  Future<CursorPagination<OrderModel>> paginate({
    @Queries() PaginationParams? paginationParams = const PaginationParams(),
  });

  @POST('')
  @Headers({
    MyKey.accessToken: 'true',
  })
  Future<OrderModel> postOrder({
    @Body() required PostOrderBody body,
  });
}
