import 'package:flutter/material.dart';
import 'package:inflearn_lecture/common/const/colors.dart';
import 'package:inflearn_lecture/common/layout/default_layout.dart';
import 'package:inflearn_lecture/common/utils/page_stroage.dart';
import 'package:inflearn_lecture/order/view/order_screen.dart';
import 'package:inflearn_lecture/product/view/product_screen.dart';
import 'package:inflearn_lecture/restaurant/view/restaurant_screen.dart';
import 'package:inflearn_lecture/user/view/profile_screen.dart';

class RootTab extends StatefulWidget {
  static String get routeName => 'home';
  const RootTab({super.key});

  @override
  State<RootTab> createState() => _RootTabState();
}

class _RootTabState extends State<RootTab> with SingleTickerProviderStateMixin {
  int index = 0;
  late final TabController contoller;

  void tabListener() {
    setState(() {
      index = contoller.index;
    });
  }

  @override
  void initState() {
    super.initState();
    contoller = TabController(length: 4, vsync: this);
    contoller.addListener(tabListener);
  }

  @override
  void dispose() {
    contoller.removeListener(tabListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: '테오 딜리버리',
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: MyColor.primary,
        unselectedItemColor: MyColor.bodyText,
        selectedFontSize: 10,
        unselectedFontSize: 10,
        type: BottomNavigationBarType.fixed,
        onTap: (int index) {
          contoller.animateTo(index);
        },
        currentIndex: index,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: '홈',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.fastfood_outlined),
            label: '음식',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long_outlined),
            label: '주문',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outlined),
            label: '프로필',
          ),
        ],
      ),
      child: PageStorage(
        bucket: PageStorageUtils.globalPageBucket,
        child: TabBarView(
          controller: contoller,
          physics: const NeverScrollableScrollPhysics(),
          children: const [
            RestaurantScreen(),
            ProductScreen(),
            OrderScreen(),
            ProfileScreen(),
          ],
        ),
      ),
    );
  }
}
