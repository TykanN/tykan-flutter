import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inflearn_lecture/common/model/cursor_pagination_model.dart';
import 'package:inflearn_lecture/common/provider/pagination_provider.dart';
import 'package:inflearn_lecture/order/model/post_order_body.dart';
import 'package:uuid/uuid.dart';

import 'package:inflearn_lecture/order/model/order_model.dart';
import 'package:inflearn_lecture/order/repository/order_repository.dart';
import 'package:inflearn_lecture/user/provider/basket_provider.dart';

final orderProvider = StateNotifierProvider<OrderNotifier, CursorPaginationBase<OrderModel>>((ref) {
  final repo = ref.watch(orderRepositoryProvider);
  return OrderNotifier(ref: ref, repository: repo);
});

class OrderNotifier extends PaginationProvider<OrderModel, OrderRepository> {
  final Ref ref;

  OrderNotifier({
    required this.ref,
    required super.repository,
  }) : super();

  Future<bool> postOrder() async {
    try {
      const uuid = Uuid();
      final id = uuid.v4();
      final basketState = ref.read(basketProvider);

      await repository.postOrder(
        body: PostOrderBody(
          id: id,
          products: basketState.map((e) => PostOrderBodyProduct(productId: e.product.id, count: e.count)).toList(),
          totalPrice: basketState.fold<int>(0, (p, n) => p + (n.count * n.product.price)),
          createdAt: DateTime.now().toString(),
        ),
      );

      return true;
    } catch (e) {
      return false;
    }
  }
}
