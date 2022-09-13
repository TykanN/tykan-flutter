import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inflearn_lecture/common/const/colors.dart';
import 'package:inflearn_lecture/common/const/data.dart';
import 'package:inflearn_lecture/common/layout/default_layout.dart';
import 'package:inflearn_lecture/common/secure_storage/secure_storage.dart';
import 'package:inflearn_lecture/common/view/root_tab.dart';
import 'package:inflearn_lecture/user/view/login_screen.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  void checkToken() async {
    final storage = ref.read(secureStorageProvider);
    final refreshToken = await storage.read(key: MyKey.refreshToken);
    final accessToken = await storage.read(key: MyKey.accessToken);

    final dio = Dio();

    try {
      final resp =
          await dio.post('$host/auth/token', options: Options(headers: {'authorization': 'Bearer $refreshToken'}));

      await storage.write(key: MyKey.accessToken, value: resp.data['accessToken']);

      if (mounted) {
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (_) => const RootTab()), (route) => false);
      }
    } catch (e) {
      if (mounted) {
        Navigator.of(context)
            .pushAndRemoveUntil(MaterialPageRoute(builder: (_) => const LoginScreen()), (route) => false);
      }
    }

    if (refreshToken == null || accessToken == null) {
    } else {}
  }

  void deleteToken() async {
    final storage = ref.read(secureStorageProvider);
    await storage.deleteAll();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    checkToken();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      backgroundColor: MyColor.primary,
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'asset/img/logo/logo.png',
              width: MediaQuery.of(context).size.width / 2,
            ),
            const SizedBox(height: 16.0),
            const CircularProgressIndicator(
              color: Colors.white,
            )
          ],
        ),
      ),
    );
  }
}
