import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:inflearn_lecture/common/const/data.dart';
import 'package:inflearn_lecture/common/dio/dio.dart';
import 'package:inflearn_lecture/restaurant/component/restaurant_card.dart';
import 'package:inflearn_lecture/restaurant/model/restaurant_model.dart';
import 'package:inflearn_lecture/restaurant/repository/restaurant_repository.dart';
import 'package:inflearn_lecture/restaurant/view/restaurant_detail_screen.dart';

class RestaurantScreen extends StatelessWidget {
  const RestaurantScreen({super.key});

  Future<List<RestaurantModel>> paginateRestaurant() async {
    final dio = Dio();

    dio.interceptors.add(CustomInterceptor(tokenStorage: storage));

    final repositroy = RestaurantRepository(dio, baseUrl: '$host/restaurant');

    final resp = await repositroy.paginate();

    // final accessToken = await storage.read(key: MyKey.accessToken);

    // final resp = await dio.get('$host/restaurant', options: Options(headers: {'authorization': 'Bearer $accessToken'}));

    return resp.data;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: FutureBuilder<List<RestaurantModel>>(
          future: paginateRestaurant(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return ListView.separated(
              separatorBuilder: (_, index) => const SizedBox(height: 16.0),
              itemCount: snapshot.data!.length,
              itemBuilder: (_, index) {
                final item = snapshot.data![index];

                return GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => RestaurantDetailScreen(
                          id: item.id,
                          restaurantModel: item,
                        ),
                      ),
                    );
                  },
                  child: RestaurantCard.fromModel(model: item),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
