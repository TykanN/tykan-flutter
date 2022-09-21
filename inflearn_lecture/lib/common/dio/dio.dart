import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:inflearn_lecture/common/const/data.dart';
import 'package:inflearn_lecture/common/secure_storage/secure_storage.dart';
import 'package:inflearn_lecture/user/provider/auth_provider.dart';

final dioProvider = Provider<Dio>((ref) {
  final dio = Dio();
  final storage = ref.watch(secureStorageProvider);
  dio.interceptors.add(
    CustomInterceptor(
      tokenStorage: storage,
      ref: ref,
    ),
  );
  return dio;
});

class CustomInterceptor extends Interceptor {
  final FlutterSecureStorage tokenStorage;
  final Ref ref;

  CustomInterceptor({
    required this.tokenStorage,
    required this.ref,
  });

  // 1) 요청을 보낼 때
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    if (options.headers[MyKey.accessToken] == 'true') {
      // 헤더 삭제
      options.headers.remove(MyKey.accessToken);
      // 실제 토큰으로 교체
      final token = await tokenStorage.read(key: MyKey.accessToken);
      options.headers.addAll({'authorization': 'Bearer $token'});
    }

    if (options.headers[MyKey.refreshToken] == 'true') {
      // 헤더 삭제
      options.headers.remove(MyKey.refreshToken);
      // 실제 토큰으로 교체
      final token = await tokenStorage.read(key: MyKey.refreshToken);
      options.headers.addAll({'authorization': 'Bearer $token'});
    }

    print('[REQ] [${options.method}] ${options.uri}');
    super.onRequest(options, handler);
  }

  // 2) 응답을 받을 때
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    print('[RES] [${response.requestOptions.method}] ${response.requestOptions.uri}');
    super.onResponse(response, handler);
  }

  // 3) 에러가 났을 때
  @override
  void onError(DioError err, ErrorInterceptorHandler handler) async {
    print('[ERR] [${err.requestOptions.method}] ${err.requestOptions.uri}');

    final refreshToken = await tokenStorage.read(key: MyKey.refreshToken);
    // refreshToken이 아예 없을 때
    if (refreshToken == null) {
      return handler.reject(err);
    }

    final isStatus401 = err.response?.statusCode == 401;
    final isPathRefresh = err.requestOptions.path == '/auth/token';

    // 401 에러
    // 토큰 재발급 시도해서 재발급되면 다시 새로운 토큰 요청
    if (isStatus401 && !isPathRefresh) {
      final dio = Dio();
      try {
        final resp = await dio.post(
          '$host/auth/token',
          options: Options(
            headers: {'authorization': 'Bearer $refreshToken'},
          ),
        );

        final accessToken = resp.data['accessToken'];
        // accessToken 교체
        final options = err.requestOptions;
        options.headers.addAll({'authorization': 'Bearer $accessToken'});
        await tokenStorage.write(key: MyKey.accessToken, value: accessToken);
        // 요청 재전송
        final reRequestDio = Dio();
        reRequestDio.interceptors.add(this);
        final response = await reRequestDio.fetch(options);

        return handler.resolve(response);
      } on DioError catch (e) {
        ref.read(authProvider.notifier).logout();
        return handler.reject(e);
      }
    }
    super.onError(err, handler);
  }
}
