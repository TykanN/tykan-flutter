import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router_theory/provider/auth_provider.dart';

void main() {
  runApp(const ProviderScope(child: _App()));
}

class _App extends ConsumerWidget {
  const _App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    return MaterialApp.router(
      // 라우트 정보를 전달
      routeInformationProvider: router.routeInformationProvider,
      // Object를 router 에서 사용할 수 있는 형태로 변경
      routeInformationParser: router.routeInformationParser,
      // 변경된 값을 통해 실제 어떤 라우트로 변경해줄지 정함
      routerDelegate: router.routerDelegate,
    );
  }
}
