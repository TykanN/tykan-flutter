import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inflearn_lecture/common/model/cursor_pagination_model.dart';
import 'package:inflearn_lecture/common/provider/pagination_provider.dart';
import 'package:inflearn_lecture/product/model/product_model.dart';
import 'package:inflearn_lecture/product/repository/product_repository.dart';

final productProvider = StateNotifierProvider<ProductStateNotifier, CursorPaginationBase<ProductModel>>((ref) {
  final repo = ref.watch(productRepositoryProvider);
  return ProductStateNotifier(repository: repo);
});

class ProductStateNotifier extends PaginationProvider<ProductModel, ProductRepository> {
  ProductStateNotifier({required super.repository});
}
