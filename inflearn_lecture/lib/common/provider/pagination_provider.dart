import 'package:debounce_throttle/debounce_throttle.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:inflearn_lecture/common/model/cursor_pagination_model.dart';
import 'package:inflearn_lecture/common/model/model_with_id.dart';
import 'package:inflearn_lecture/common/model/pagination_params.dart';
import 'package:inflearn_lecture/common/repository/base_pagination_repository.dart';

class _PaginationInfo {
  final int fetchCount;
  // 추가로 데이터 더 가져오기
  final bool fetchMore;
  // 강제 재로딩
  final bool forceRefetch;

  _PaginationInfo({
    this.fetchCount = 20,
    this.fetchMore = false,
    this.forceRefetch = false,
  });
}

class PaginationProvider<T extends IModelWithId, R extends IBasePaginationRepository<T>>
    extends StateNotifier<CursorPaginationBase<T>> {
  final R repository;

  final paginationThrottle = Throttle(
    const Duration(seconds: 5),
    initialValue: _PaginationInfo(),
    checkEquality: false,
  );

  PaginationProvider({
    required this.repository,
  }) : super(CursorPaginationLoading<T>()) {
    paginate();

    paginationThrottle.values.listen((event) {
      _throttlePagination(event);
    });
  }

  Future<void> paginate({
    int fetchCount = 20,
    // 추가로 데이터 더 가져오기
    bool fetchMore = false,
    // 강제 재로딩
    bool forceRefetch = false,
  }) async {
    paginationThrottle.setValue(_PaginationInfo(
      fetchCount: fetchCount,
      fetchMore: fetchMore,
      forceRefetch: forceRefetch,
    ));
  }

  void _throttlePagination(_PaginationInfo info) async {
    final fetchCount = info.fetchCount;
    final fetchMore = info.fetchMore;
    final forceRefetch = info.forceRefetch;

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
      if (state is CursorPagination<T> && !forceRefetch) {
        final pState = state as CursorPagination<T>;
        if (!pState.meta.hasMore) {
          return;
        }
      }

      final isLoading = state is CursorPaginationLoading<T>;
      final isRefetching = state is CursorPaginationRefetching<T>;
      final isFetchingMore = state is CursorPaginationFetchingMore<T>;

      // 2번 반환 상황
      if (fetchMore && (isLoading || isRefetching || isFetchingMore)) {
        return;
      }

      // 파라미터 생성
      PaginationParams paginationParams = PaginationParams(count: fetchCount);

      // fetchMore 데이터를 더 가져오는 상황
      if (fetchMore) {
        final pState = state as CursorPagination<T>;

        state = CursorPaginationFetchingMore<T>(meta: pState.meta, data: pState.data);
        paginationParams = paginationParams.copyWith(after: pState.data.last.id);
      }
      // 데이터를 처음부터 가져오는 상황
      else {
        // 만약에 기존 데이터가 있다면 기존 데이터를 보존한채로 Fetch
        if (state is CursorPagination<T> && !forceRefetch) {
          final pState = state as CursorPagination<T>;
          state = CursorPaginationRefetching<T>(meta: pState.meta, data: pState.data);
        }
        // 나머지 상황
        else {
          state = CursorPaginationLoading<T>();
        }
      }

      final resp = await repository.paginate(paginationParams: paginationParams);

      if (state is CursorPaginationFetchingMore<T>) {
        final pState = state as CursorPaginationFetchingMore<T>;

        state = resp.copyWith(data: [...pState.data, ...resp.data]);
      } else {
        state = resp;
      }
    } catch (e, stack) {
      print(e);
      print(stack);
      state = CursorPaginationError<T>(message: '데이터를 가져오지 못했습니다.');
    }
  }
}
