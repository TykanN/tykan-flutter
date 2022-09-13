import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inflearn_lecture/common/component/custom_text_form_field.dart';
import 'package:inflearn_lecture/common/const/colors.dart';
import 'package:inflearn_lecture/common/const/data.dart';
import 'package:inflearn_lecture/common/layout/default_layout.dart';
import 'package:inflearn_lecture/common/secure_storage/secure_storage.dart';
import 'package:inflearn_lecture/common/view/root_tab.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  String username = '';
  String password = '';

  final dio = Dio();

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      child: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: SafeArea(
          top: true,
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const _Title(),
                const SizedBox(height: 16.0),
                const _SubTitle(),
                Image.asset(
                  'asset/img/misc/logo.png',
                  width: MediaQuery.of(context).size.width / 3 * 2,
                ),
                CustomTextFormField(
                  hintText: '이메일을 입력해주세요.',
                  onChanged: (value) {
                    username = value;
                  },
                  // errorText: '에러가 있습니다',
                ),
                const SizedBox(height: 16.0),
                CustomTextFormField(
                  hintText: '비밀번호을 입력해주세요.',
                  obscureText: true,
                  onChanged: (value) {
                    password = value;
                  },
                  // errorText: '에러가 있습니다',
                ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () async {
                    // ID/비번
                    final rawString = '$username:$password';

                    Codec<String, String> stringToBase64 = utf8.fuse(base64);

                    String token = stringToBase64.encode(rawString);

                    final resp = await dio.post(
                      '$host/auth/login',
                      options: Options(
                        headers: {'authorization': 'Basic $token'},
                      ),
                    );

                    final refreshToken = resp.data[MyKey.refreshToken];
                    final accessToken = resp.data[MyKey.accessToken];

                    final storage = ref.read(secureStorageProvider);

                    await storage.write(key: MyKey.refreshToken, value: refreshToken);
                    await storage.write(key: MyKey.accessToken, value: accessToken);

                    if (mounted) {
                      Navigator.of(context)
                          .pushAndRemoveUntil(MaterialPageRoute(builder: (_) => const RootTab()), (route) => false);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: MyColor.primary,
                  ),
                  child: const Text('로그인'),
                ),
                TextButton(
                  onPressed: () async {},
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.black,
                  ),
                  child: const Text('회원가입'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Title extends StatelessWidget {
  const _Title({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text(
      '환영합니다!',
      style: TextStyle(
        fontSize: 34,
        fontWeight: FontWeight.w500,
        color: Colors.black,
      ),
    );
  }
}

class _SubTitle extends StatelessWidget {
  const _SubTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text(
      '이메일과 비밀번호를 입력해서 로그인 해주세요!\n오늘도 성공적인 주문이 되길 :)',
      style: TextStyle(
        fontSize: 16.0,
        color: MyColor.bodyText,
      ),
    );
  }
}
