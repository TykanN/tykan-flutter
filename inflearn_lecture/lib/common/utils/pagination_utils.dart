import 'package:flutter/material.dart';
import 'package:inflearn_lecture/common/provider/pagination_provider.dart';

class PaginationUtils {
  static void paginate({required ScrollController controller, required PaginationProvider provider}) {
    // 현재 위치가 특정 위치까지 왔다면 추가 데이터 요청
    if (controller.offset > controller.position.maxScrollExtent - 300) {
      provider.paginate(fetchMore: true);
    }
  }
}
