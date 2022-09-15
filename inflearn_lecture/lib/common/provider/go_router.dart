import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:inflearn_lecture/user/provider/auth_provider.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final provider = ref.read(authProvider);

  return GoRouter(
    initialLocation: '/splash',
    routes: provider.routes,
    redirect: provider.redirectLogic,
    refreshListenable: provider,
  );
});
