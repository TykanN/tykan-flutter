import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:inflearn_lecture/common/const/colors.dart';
import 'package:inflearn_lecture/common/layout/default_layout.dart';
import 'package:inflearn_lecture/common/model/cursor_pagination_model.dart';
import 'package:inflearn_lecture/common/utils/pagination_utils.dart';
import 'package:inflearn_lecture/product/component/product_card.dart';
import 'package:inflearn_lecture/product/model/product_model.dart';
import 'package:inflearn_lecture/rating/component/rating_card.dart';
import 'package:inflearn_lecture/rating/model/rating_model.dart';
import 'package:inflearn_lecture/restaurant/component/restaurant_card.dart';
import 'package:inflearn_lecture/restaurant/model/restaurant_detail_model.dart';
import 'package:inflearn_lecture/restaurant/model/restaurant_model.dart';
import 'package:inflearn_lecture/restaurant/provider/restaurant_provider.dart';
import 'package:inflearn_lecture/restaurant/provider/restaurant_rating_provider.dart';
import 'package:inflearn_lecture/restaurant/view/basket_screen.dart';
import 'package:inflearn_lecture/user/provider/basket_provider.dart';
import 'package:skeletons/skeletons.dart';

class RestaurantDetailScreen extends ConsumerStatefulWidget {
  static String get routeName => 'restaurantDetail';
  final String id;

  const RestaurantDetailScreen({
    super.key,
    required this.id,
  });

  @override
  ConsumerState<RestaurantDetailScreen> createState() => _RestaurantDetailScreenState();
}

class _RestaurantDetailScreenState extends ConsumerState<RestaurantDetailScreen> {
  final ScrollController controller = ScrollController();

  void scrollListener() {
    PaginationUtils.paginate(
      controller: controller,
      provider: ref.read(restaurantRatingProvider(widget.id).notifier),
    );
  }

  @override
  void initState() {
    super.initState();
    ref.read(restaurantProvider.notifier).getDetail(id: widget.id);
    controller.addListener(scrollListener);
  }

  @override
  void dispose() {
    controller.removeListener(scrollListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(restaurantDetailProvider(widget.id));
    final ratings = ref.watch(restaurantRatingProvider(widget.id));
    final basket = ref.watch(basketProvider);

    if (state == null) {
      return const DefaultLayout(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    return DefaultLayout(
      title: state.name,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.pushNamed(BasketScreen.routeName);
        },
        child: Badge(
          showBadge: basket.isNotEmpty,
          badgeContent: Text(
            basket.fold(0, (previous, next) => previous + next.count).toString(),
            style: const TextStyle(color: MyColor.primary),
          ),
          badgeColor: Colors.white,
          child: const Icon(Icons.shopping_basket_outlined),
        ),
      ),
      child: CustomScrollView(
        controller: controller,
        slivers: [
          _renderTop(model: state),
          if (state is! RestaurantDetailModel) _renderLoading(),
          if (state is RestaurantDetailModel) _renderLabel(),
          if (state is RestaurantDetailModel)
            _renderProduct(
              products: state.products,
              restaurant: state,
            ),
          if (ratings is CursorPagination<RatingModel>) _renderRatings(ratings: ratings.data),
        ],
      ),
    );
  }

  Widget _renderRatings({required List<RatingModel> ratings}) {
    return SliverPadding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
        sliver: SliverList(
          delegate: SliverChildBuilderDelegate(
            (_, index) => Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: RatingCard.fromModel(
                model: ratings[index],
              ),
            ),
            childCount: ratings.length,
          ),
        ));
  }

  Widget _renderLoading() {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      sliver: SliverList(
        delegate: SliverChildListDelegate(
          List.generate(
            3,
            (index) => Padding(
              padding: const EdgeInsets.only(bottom: 32.0),
              child: SkeletonParagraph(
                style: const SkeletonParagraphStyle(
                  padding: EdgeInsets.zero,
                  lines: 5,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _renderLabel() {
    return const SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      sliver: SliverToBoxAdapter(
        child: Text(
          '메뉴',
          style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _renderProduct({required List<RestaurantProductModel> products, required RestaurantModel restaurant}) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final model = products[index];
            return InkWell(
              onTap: () {
                ref.read(basketProvider.notifier).addToBasket(
                      product: ProductModel(
                          id: model.id,
                          name: model.name,
                          detail: model.detail,
                          imgUrl: model.imgUrl,
                          price: model.price,
                          restaurant: restaurant),
                    );
              },
              child: Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: ProductCard.fromRestaurantProductModel(
                  model: model,
                ),
              ),
            );
          },
          childCount: products.length,
        ),
      ),
    );
  }

  Widget _renderTop({required RestaurantModel model}) {
    return SliverToBoxAdapter(
      child: RestaurantCard.fromModel(
        model: model,
        isDetail: true,
      ),
    );
  }
}
