import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inflearn_lecture/common/component/pagination_list_view.dart';
import 'package:inflearn_lecture/order/component/order_card.dart';
import 'package:inflearn_lecture/order/provider/order_provider.dart';

class OrderScreen extends ConsumerWidget {
  const OrderScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PaginationListView(
      pageStorageKeyValue: 'order',
      provider: orderProvider,
      itemBuilder: (_, index, model) {
        return OrderCard.fromModel(model: model);
      },
    );
  }
}
