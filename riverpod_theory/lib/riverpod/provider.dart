import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_theory/model/shopping_item_model.dart';
import 'package:riverpod_theory/riverpod/state_notifier_provider.dart';

final filteredShoppingList = Provider<List<ShoppingItemModel>>((ref) {
  final shoppingListState = ref.watch(shoppingListProvider);
  final filterState = ref.watch(filterProvider);
  if (filterState == FilterState.all) {
    return shoppingListState;
  }
  return shoppingListState
      .where((element) => filterState == FilterState.spicy ? element.isSpicy : !element.isSpicy)
      .toList();
});

enum FilterState {
  notSpicy,
  spicy,
  all,
}

final filterProvider = StateProvider<FilterState>((ref) => FilterState.all);
