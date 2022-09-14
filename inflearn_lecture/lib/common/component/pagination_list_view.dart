import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inflearn_lecture/common/model/cursor_pagination_model.dart';
import 'package:inflearn_lecture/common/model/model_with_id.dart';
import 'package:inflearn_lecture/common/provider/pagination_provider.dart';
import 'package:inflearn_lecture/common/repository/base_pagination_repository.dart';
import 'package:inflearn_lecture/common/utils/pagination_utils.dart';

typedef PaginationWidgetBuilder<T extends IModelWithId> = Widget Function(BuildContext context, int index, T model);

class PaginationListView<T extends IModelWithId> extends ConsumerStatefulWidget {
  final StateNotifierProvider<PaginationProvider<T, IBasePaginationRepository<T>>, CursorPaginationBase<T>> provider;
  final PaginationWidgetBuilder<T> itemBuilder;

  const PaginationListView({
    super.key,
    required this.provider,
    required this.itemBuilder,
  });

  @override
  ConsumerState<PaginationListView> createState() => _PaginationListViewState<T>();
}

class _PaginationListViewState<U extends IModelWithId> extends ConsumerState<PaginationListView<U>> {
  final ScrollController controller = ScrollController();

  void scrollListener() {
    PaginationUtils.paginate(
      controller: controller,
      provider: ref.read(widget.provider.notifier),
    );
  }

  @override
  void initState() {
    super.initState();
    controller.addListener(scrollListener);
  }

  @override
  void dispose() {
    controller.removeListener(scrollListener);
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(widget.provider);
    // 첫 로딩
    if (state is CursorPaginationLoading<U>) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    // 에러
    if (state is CursorPaginationError<U>) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            state.message,
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 16.0,
          ),
          ElevatedButton(
            onPressed: () {
              ref.read(widget.provider.notifier).paginate(forceRefetch: true);
            },
            child: const Text('다시 시도'),
          )
        ],
      );
    }

    final CursorPagination<U> cp = state as CursorPagination<U>;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: ListView.separated(
        controller: controller,
        separatorBuilder: (_, index) => const SizedBox(height: 16.0),
        itemCount: cp.data.length + 1,
        itemBuilder: (_, index) {
          if (index == cp.data.length) {
            return Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              child: Center(
                child: state is CursorPaginationFetchingMore
                    ? const CircularProgressIndicator()
                    : const Text('마지막 데이터입니다 ㅠㅠ'),
              ),
            );
          }
          final item = cp.data[index];

          return widget.itemBuilder(context, index, item);
        },
      ),
    );
  }
}
