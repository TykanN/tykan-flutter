import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inflearn_lecture/order/model/post_order_body.dart';
import 'package:uuid/uuid.dart';

import 'package:inflearn_lecture/order/model/order_model.dart';
import 'package:inflearn_lecture/order/repository/order_repository.dart';
import 'package:inflearn_lecture/user/provider/basket_provider.dart';

final orderProvider = StateNotifierProvider<OrderNotifier, List<OrderModel>>((ref) {
  final repo = ref.watch(orderRepositoryProvider);
  return OrderNotifier(ref: ref, repository: repo);
});

class OrderNotifier extends StateNotifier<List<OrderModel>> {
  final Ref ref;
  final OrderRepository repository;

  OrderNotifier({
    required this.ref,
    required this.repository,
  }) : super([]);

  Future<bool> postOrder() async {
    try {
      const uuid = Uuid();
      final id = uuid.v4();
      final basketState = ref.read(basketProvider);

      final resp = await repository.postOrder(
        body: PostOrderBody(
          id: id,
          products: basketState.map((e) => PostOrderBodyProduct(productId: e.product.id, count: e.count)).toList(),
          totalPrice: basketState.fold<int>(0, (p, n) => p + (n.count * n.product.price)),
          createdAt: DateTime.now().toString(),
        ),
      );

      return true;
    } catch (e) {
      throw e;
      return false;
    }
  }
}
