import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inflearn_lecture/common/model/cursor_pagination_model.dart';
import 'package:inflearn_lecture/common/provider/pagination_provider.dart';
import 'package:inflearn_lecture/restaurant/model/restaurant_model.dart';
import 'package:collection/collection.dart';
import 'package:inflearn_lecture/restaurant/repository/restaurant_repository.dart';

final restaurantDetailProvider = Provider.family<RestaurantModel?, String>((ref, id) {
  final state = ref.watch(restaurantProvider);

  if (state is! CursorPagination<RestaurantModel>) {
    return null;
  }

  return state.data.firstWhereOrNull((element) => element.id == id);
});

final restaurantProvider = StateNotifierProvider<RestaurantStateNotifier, CursorPaginationBase<RestaurantModel>>((ref) {
  final repository = ref.watch(restaurantRepositoryProvider);
  return RestaurantStateNotifier(repository: repository);
});

class RestaurantStateNotifier extends PaginationProvider<RestaurantModel, RestaurantRepository> {
  RestaurantStateNotifier({required super.repository});

  void getDetail({required String id}) async {
    // 만약에 아직 데이터가 하나도 없는 상태라면
    // 데이터를 가져오는 시도를 한다.
    if (state is! CursorPagination) {
      await paginate();
    }

    // state가 CursorPagination이 아닐 때 그냥 반환 (서버 에러 같은 상황)
    if (state is! CursorPagination) {
      return;
    }

    final pState = state as CursorPagination<RestaurantModel>;
    final resp = await repository.getRestaurantDetail(rid: id);

    if (pState.data.where((e) => e.id == id).isEmpty) {
      state = pState.copyWith(
        data: [
          ...pState.data,
          resp,
        ],
      );
    } else {
      state = pState.copyWith(
          data: pState.data
              .map<RestaurantModel>(
                (e) => e.id == id ? resp : e,
              )
              .toList());
    }
  }
}
