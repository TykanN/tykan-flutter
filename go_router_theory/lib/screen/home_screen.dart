import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:go_router_theory/layout/default_layout.dart';
import 'package:go_router_theory/provider/auth_provider.dart';
import 'package:go_router_theory/screen/three_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultLayout(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ElevatedButton(
            onPressed: () {
              context.go('/one');
            },
            child: Text('OneScreen GO'),
          ),
          ElevatedButton(
            onPressed: () {
              context.goNamed(ThreeScreen.routeName);
            },
            child: Text('ThreeScreen GO'),
          ),
          ElevatedButton(
            onPressed: () {
              context.go('/error');
            },
            child: Text('Error GO'),
          ),
          ElevatedButton(
            onPressed: () {
              context.go('/login');
            },
            child: Text('LoginScreen GO'),
          ),
          ElevatedButton(
            onPressed: () {
              ref.read(userProvider.notifier).logout();
            },
            child: Text('Logout'),
          ),
        ],
      ),
    );
  }
}
