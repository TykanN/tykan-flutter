import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:inflearn_lecture/common/const/data.dart';
import 'package:inflearn_lecture/common/dio/dio.dart';
import 'package:inflearn_lecture/common/layout/default_layout.dart';
import 'package:inflearn_lecture/product/component/product_card.dart';
import 'package:inflearn_lecture/restaurant/component/restaurant_card.dart';
import 'package:inflearn_lecture/restaurant/model/restaurant_detail_model.dart';
import 'package:inflearn_lecture/restaurant/model/restaurant_model.dart';
import 'package:inflearn_lecture/restaurant/repository/restaurant_repository.dart';

class RestaurantDetailScreen extends StatelessWidget {
  final RestaurantModel restaurantModel;
  final String id;

  const RestaurantDetailScreen({
    super.key,
    required this.id,
    required this.restaurantModel,
  });

  Future<RestaurantDetailModel> getRestaurantDetail() async {
    final dio = Dio();

    dio.interceptors.add(CustomInterceptor(tokenStorage: storage));

    final repository = RestaurantRepository(dio, baseUrl: '$host/restaurant');

    return repository.getRestaurantDetail(rid: id);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: '불타는 떡볶이',
      child: FutureBuilder<RestaurantDetailModel>(
        future: getRestaurantDetail(),
        builder: (_, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          final item = snapshot.data!;

          return CustomScrollView(
            slivers: [
              _renderTop(model: item),
              _renderLabel(),
              _renderProduct(item.products),
            ],
          );
        },
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

  Widget _renderProduct(List<RestaurantProductModel> products) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            return Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: ProductCard(
                product: products[index],
              ),
            );
          },
          childCount: products.length,
        ),
      ),
    );
  }

  Widget _renderTop({required RestaurantDetailModel model}) {
    return SliverToBoxAdapter(
      child: RestaurantCard.fromModel(
        model: model,
        isDetail: true,
      ),
    );
  }
}
