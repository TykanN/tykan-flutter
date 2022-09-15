import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inflearn_lecture/product/model/product_model.dart';
import 'package:inflearn_lecture/user/model/basket_item_model.dart';
import 'package:collection/collection.dart';

final basketProvider = StateNotifierProvider<BasketNotifier, List<BasketItemModel>>((ref) {
  return BasketNotifier();
});

class BasketNotifier extends StateNotifier<List<BasketItemModel>> {
  BasketNotifier() : super([]);

  Future<void> addToBasket({required ProductModel product}) async {
    final exists = state.firstWhereOrNull((e) => e.product.id == product.id) != null;
    // 1) 이미 있다면 장바구니에 있는 값에 카운트 증가

    if (exists) {
      state = state
          .map(
            (e) => e.product.id == product.id ? e.copyWith(count: e.count + 1) : e,
          )
          .toList();
    }
    // 2) 아직 장바구니에 해당되는 상품이 없다면 추가
    else {
      state = [
        ...state,
        BasketItemModel(product: product, count: 1),
      ];
    }
  }

  Future<void> removeFromBasket({
    required ProductModel product,
    // 카운트에 관계없이 아예 삭제
    bool isDelete = false,
  }) async {
    final exists = state.firstWhereOrNull((e) => e.product.id == product.id) != null;
    // 1) 상품이 존재하지 않을 때, 즉시 리턴
    if (!exists) {
      return;
    }
    // 2) 장바구니에 상품이 존재할 때
    // 2-1) 상품의 카운트가 1보다 크면 -1 한다.
    // 2-2) 상품의 카운트 1이면 삭제한다.

    final existingProduct = state.firstWhere((e) => e.product.id == product.id);
    if (existingProduct.count == 1 || isDelete) {
      state = state.where((e) => e.product.id != product.id).toList();
    } else {
      state = state.map((e) => e.product.id == product.id ? e.copyWith(count: e.count + 1) : e).toList();
    }
  }
}
