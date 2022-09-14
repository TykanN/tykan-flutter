import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inflearn_lecture/common/model/cursor_pagination_model.dart';
import 'package:inflearn_lecture/common/model/pagination_params.dart';
import 'package:inflearn_lecture/restaurant/model/restaurant_model.dart';

import 'package:inflearn_lecture/restaurant/repository/restaurant_repository.dart';

final restaurantDetailProvider = Provider.family<RestaurantModel?, String>((ref, id) {
  final state = ref.watch(restaurantProvider);

  if (state is! CursorPagination) {
    return null;
  }

  return state.data.firstWhere((element) => element.id == id);
});

final restaurantProvider = StateNotifierProvider<RestaurantStateNotifier, CursorPaginationBase>((ref) {
  final repository = ref.watch(restaurantRepositoryProvider);
  return RestaurantStateNotifier(repository: repository);
});

class RestaurantStateNotifier extends StateNotifier<CursorPaginationBase> {
  final RestaurantRepository repository;

  RestaurantStateNotifier({required this.repository}) : super(CursorPaginationLoading()) {
    paginate();
  }

  Future<void> paginate({
    int fetchCount = 20,
    // 추가로 데이터 더 가져오기
    bool fetchMore = false,
    // 강제 재로딩
    bool forceRefetch = false,
  }) async {
    try {
      // 1) CursorPagination - 정상 상태
      // 2) CursorPaginationLoading - 데이터 로딩 상태(캐시 없음)
      // 3) CursorPaginationError - 에러 상태
      // 4) CursorPaginationRefetching - 처음부터 다시
      // 5) CursorPaginationFetchMore - 추가 데이터 요청

      // 즉시 반환 상황
      // 1. 기존 상태 hasMore가 false
      // 2. 특정 로딩 중 상태일 때 -> fetchMore: true,
      // fetchMore가 아닐 때는 새로 고침 실행
      if (state is CursorPagination && !forceRefetch) {
        final pState = state as CursorPagination;
        if (!pState.meta.hasMore) {
          return;
        }
      }

      final isLoading = state is CursorPaginationLoading;
      final isRefetching = state is CursorPaginationRefetching;
      final isFetchingMore = state is CursorPaginationFetchingMore;

      // 2번 반환 상황
      if (fetchMore && (isLoading || isRefetching || isFetchingMore)) {
        return;
      }

      // 파라미터 생성
      PaginationParams paginationParams = PaginationParams(count: fetchCount);

      // fetchMore 데이터를 더 가져오는 상황
      if (fetchMore) {
        final pState = state as CursorPagination;

        state = CursorPaginationFetchingMore(meta: pState.meta, data: pState.data);
        paginationParams = paginationParams.copyWith(after: pState.data.last.id);
      }
      // 데이터를 처음부터 가져오는 상황
      else {
        // 만약에 기존 데이터가 있다면 기존 데이터를 보존한채로 Fetch
        if (state is CursorPagination && !forceRefetch) {
          final pState = state as CursorPagination;
          state = CursorPaginationRefetching(meta: pState.meta, data: pState.data);
        }
        // 나머지 상황
        else {
          state = CursorPaginationLoading();
        }
      }

      final resp = await repository.paginate(paginationParams: paginationParams);

      if (state is CursorPaginationFetchingMore) {
        final pState = state as CursorPaginationFetchingMore;

        state = resp.copyWith(data: [...pState.data, ...resp.data]);
      } else {
        state = resp;
      }
    } catch (e) {
      state = CursorPaginationError(message: '데이터를 가져오지 못했습니다.');
    }
  }

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
    state = pState.copyWith(
        data: pState.data
            .map<RestaurantModel>(
              (e) => e.id == id ? resp : e,
            )
            .toList());
  }
}
