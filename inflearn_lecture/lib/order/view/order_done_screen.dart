import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:inflearn_lecture/common/const/colors.dart';
import 'package:inflearn_lecture/common/layout/default_layout.dart';
import 'package:inflearn_lecture/common/view/root_tab.dart';

class OrderDoneScreen extends StatelessWidget {
  static String get routeName => 'orderDone';
  const OrderDoneScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(
              Icons.thumb_up_alt_outlined,
              color: MyColor.primary,
              size: 50.0,
            ),
            const SizedBox(height: 32.0),
            const Text(
              '결제가 완료되었습니다.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32.0),
            ElevatedButton(
              onPressed: () {
                context.goNamed(RootTab.routeName);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: MyColor.primary,
              ),
              child: const Text('홈으로'),
            )
          ],
        ),
      ),
    );
  }
}
