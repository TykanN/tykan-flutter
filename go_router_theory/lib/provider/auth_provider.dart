import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:go_router_theory/model/user_model.dart';
import 'package:go_router_theory/screen/error_screen.dart';
import 'package:go_router_theory/screen/home_screen.dart';
import 'package:go_router_theory/screen/login_screen.dart';
import 'package:go_router_theory/screen/one_screen.dart';
import 'package:go_router_theory/screen/three_screen.dart';
import 'package:go_router_theory/screen/two_screen.dart';

final routerProvider = Provider<GoRouter>(
  (ref) {
    final authStateProvider = AuthNotifier(ref: ref);
    return GoRouter(
      initialLocation: '/login',
      errorBuilder: (context, state) {
        return ErrorScreen(
          error: state.error.toString(),
        );
      },
      // redirect
      redirect: authStateProvider._redirectLogic,
      // refresh
      refreshListenable: authStateProvider,
      routes: authStateProvider._routes,
    );
  },
);

class AuthNotifier extends ChangeNotifier {
  final Ref ref;

  AuthNotifier({required this.ref}) {
    ref.listen<UserModel?>(
      userProvider,
      (previous, next) {
        if (previous != next) {
          notifyListeners();
        }
      },
    );
  }

  String? _redirectLogic(GoRouterState state) {
    // UserModel?
    final UserModel? user = ref.read(userProvider);
    // 현재 로그인하려는 상태인지
    final loggingIn = state.location == '/login';

    // 유저 정보가 없다 - 로그인 상태가 아님
    //
    // 유저 정보가 없는데 로그인하려는 중도 아니라면 로그인 페이지로 이동한다.
    // 로그인 중이라면 그냥 둔다.
    if (user == null) {
      return loggingIn ? null : '/login';
    }
    // 유저 정보가 있는데 로그인 페이지로 가려한다면 홈으로 이동
    if (loggingIn) {
      return '/';
    }

    return null;
  }

  List<GoRoute> get _routes => [
        GoRoute(
          path: '/',
          builder: (_, state) => const HomeScreen(),
          routes: [
            GoRoute(
              path: 'one',
              builder: (_, state) => OneScreen(),
              routes: [
                GoRoute(
                  path: 'two',
                  builder: (_, state) => TwoScreen(),
                  routes: [
                    GoRoute(
                      path: 'three',
                      name: ThreeScreen.routeName,
                      builder: (_, state) => ThreeScreen(),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        GoRoute(
          path: '/login',
          builder: (_, state) => LoginScreen(),
        ),
      ];
}

final userProvider = StateNotifierProvider<UserStateNotifier, UserModel?>((ref) {
  return UserStateNotifier();
});

class UserStateNotifier extends StateNotifier<UserModel?> {
  UserStateNotifier() : super(null);

  void login({
    required String name,
  }) {
    state = UserModel(name: name);
  }

  void logout() {
    state = null;
  }
}
