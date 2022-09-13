import 'package:flutter/material.dart';

class DefaultLayout extends StatelessWidget {
  final Widget child;
  final Color? backgroundColor;
  final String? title;
  final Widget? bottomNavigationBar;
  final List<Widget>? actions;

  const DefaultLayout({
    super.key,
    required this.child,
    this.actions,
    this.backgroundColor,
    this.title,
    this.bottomNavigationBar,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor ?? Colors.white,
      appBar: renderAppBar(),
      body: child,
      bottomNavigationBar: bottomNavigationBar,
    );
  }

  AppBar? renderAppBar() {
    if (title == null) {
      return null;
    }
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      foregroundColor: Colors.black,
      title: Text(
        title!,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
    );
  }
}
