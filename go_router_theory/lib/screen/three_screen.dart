import 'package:flutter/material.dart';
import 'package:go_router_theory/layout/default_layout.dart';

class ThreeScreen extends StatelessWidget {
  const ThreeScreen({super.key});

  static String get routeName => 'three';

  @override
  Widget build(BuildContext context) {
    print('3 build');
    return DefaultLayout(
      child: Column(
        children: [
          Text('3'),
        ],
      ),
    );
  }
}
