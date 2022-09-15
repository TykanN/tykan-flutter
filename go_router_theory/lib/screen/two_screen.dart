import 'package:flutter/material.dart';
import 'package:go_router_theory/layout/default_layout.dart';

class TwoScreen extends StatelessWidget {
  const TwoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    print('2 build');
    return DefaultLayout(
      child: Column(
        children: [
          Text('2'),
        ],
      ),
    );
  }
}
