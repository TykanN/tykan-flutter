import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:inflearn_lecture/common/view/root_tab.dart';
import 'package:inflearn_lecture/common/view/splash_screen.dart';
import 'package:inflearn_lecture/order/view/order_done_screen.dart';
import 'package:inflearn_lecture/restaurant/view/basket_screen.dart';
import 'package:inflearn_lecture/restaurant/view/restaurant_detail_screen.dart';
import 'package:inflearn_lecture/user/model/user_model.dart';
import 'package:inflearn_lecture/user/provider/user_me_provider.dart';
import 'package:inflearn_lecture/user/view/login_screen.dart';

final authProvider = ChangeNotifierProvider<AuthProvider>((ref) {
  return AuthProvider(ref: ref);
});

class AuthProvider extends ChangeNotifier {
  final Ref ref;

  AuthProvider({
    required this.ref,
  }) {
    ref.listen<UserModelBase?>(userMeProvider, (previous, next) {
      if (previous != null) {
        notifyListeners();
      }
    });
  }

  List<GoRoute> get routes => [
        GoRoute(
          path: '/splash',
          name: SplashScreen.routeName,
          builder: (_, __) => const SplashScreen(),
        ),
        GoRoute(
          path: '/login',
          name: LoginScreen.routeName,
          builder: (_, __) => const LoginScreen(),
        ),
        GoRoute(
          path: '/',
          name: RootTab.routeName,
          builder: (_, __) => const RootTab(),
          routes: [
            GoRoute(
              path: 'restaurant/:rid',
              name: RestaurantDetailScreen.routeName,
              builder: (_, state) => RestaurantDetailScreen(
                id: state.params['rid']!,
              ),
            ),
          ],
        ),
        GoRoute(
          path: '/basket',
          name: BasketScreen.routeName,
          builder: (_, __) => const BasketScreen(),
        ),
        GoRoute(
          path: '/order-done',
          name: OrderDoneScreen.routeName,
          builder: (_, __) => const OrderDoneScreen(),
        ),
      ];

  // SplashScreen
  // ?????? ?????? ???????????? ???
  // ????????? ??????????????? ????????????, ??????????????? ?????? ???, ????????? ?????? ???, ???????????? ?????? ??????.
  String? redirectLogic(GoRouterState state) {
    final UserModelBase? user = ref.read(userMeProvider);
    final bool logginIn = state.location == '/login';

    if (user == null) {
      return logginIn ? null : '/login';
    }
    // ??????????????? ?????? null??? ??????

    // UserModel
    // ????????? ????????? ?????? ?????????
    // ????????? ???????????? ?????? ????????? ??????????????? ????????? ??????
    if (user is UserModel) {
      return logginIn || state.location == '/splash' ? '/' : null;
    }

    // UserModelError
    if (user is UserModelError) {
      return !logginIn ? '/login' : null;
    }

    return null;
  }

  logout() => ref.read(userMeProvider.notifier).logOut();
}
