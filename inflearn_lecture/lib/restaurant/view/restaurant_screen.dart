import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:inflearn_lecture/common/const/data.dart';
import 'package:inflearn_lecture/restaurant/component/restaurant_card.dart';
import 'package:inflearn_lecture/restaurant/model/restaurant_model.dart';

class RestaurantScreen extends StatelessWidget {
  const RestaurantScreen({super.key});

  Future<List> paginateRestaurant() async {
    final dio = Dio();

    final accessToken = await storage.read(key: MyKey.accessToken);

    final resp = await dio.get('$host/restaurant', options: Options(headers: {'authorization': 'Bearer $accessToken'}));

    return resp.data['data'];
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: FutureBuilder<List>(
            future: paginateRestaurant(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const CircularProgressIndicator();
              }
              return ListView.separated(
                separatorBuilder: (_, index) => const SizedBox(height: 16.0),
                itemCount: snapshot.data!.length,
                itemBuilder: (_, index) {
                  final item = snapshot.data![index];
                  final pItem = RestaurantModel.fromMap(item);

                  return RestaurantCard.fromModel(model: pItem);
                },
              );
            },
          )),
    );
  }
}
