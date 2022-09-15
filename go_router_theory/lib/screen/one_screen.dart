import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:go_router_theory/layout/default_layout.dart';

class OneScreen extends StatelessWidget {
  const OneScreen({super.key});

  @override
  Widget build(BuildContext context) {
    print('1 build');
    return DefaultLayout(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ElevatedButton(
            onPressed: () {
              context.pop();
            },
            child: Text('POP'),
          ),
        ],
      ),
    );
  }
}
