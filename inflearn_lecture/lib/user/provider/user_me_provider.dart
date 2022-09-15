import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:inflearn_lecture/common/const/data.dart';
import 'package:inflearn_lecture/common/secure_storage/secure_storage.dart';
import 'package:inflearn_lecture/user/model/user_model.dart';
import 'package:inflearn_lecture/user/repository/auth_repository.dart';
import 'package:inflearn_lecture/user/repository/user_me_repository.dart';

final userMeProvider = StateNotifierProvider<UserMeStateNotifier, UserModelBase?>((ref) {
  final AuthRepository authRepository = ref.watch(authRepositoryProvider);
  final UserMeRepository repository = ref.watch(userMeRepositoryProvider);
  final FlutterSecureStorage storage = ref.watch(secureStorageProvider);

  return UserMeStateNotifier(
    authRepository: authRepository,
    repository: repository,
    storage: storage,
  );
});

class UserMeStateNotifier extends StateNotifier<UserModelBase?> {
  final AuthRepository authRepository;
  final UserMeRepository repository;
  final FlutterSecureStorage storage;

  UserMeStateNotifier({
    required this.authRepository,
    required this.repository,
    required this.storage,
  }) : super(UserModelLoading()) {
    //내 정보 가져오기
    getMe();
  }

  void getMe() async {
    final refreshToken = await storage.read(key: MyKey.refreshToken);
    final accessToken = await storage.read(key: MyKey.accessToken);

    if (refreshToken == null || accessToken == null) {
      state = null;
      return;
    }

    final resp = await repository.getMe();

    state = resp;
  }

  Future<UserModelBase> login({
    required String username,
    required String password,
  }) async {
    try {
      state = UserModelLoading();
      final resp = await authRepository.login(
        username: username,
        password: password,
      );

      await storage.write(key: MyKey.refreshToken, value: resp.refreshToken);
      await storage.write(key: MyKey.accessToken, value: resp.accessToken);

      final userResp = await repository.getMe();
      state = userResp;

      return userResp;
    } catch (e) {
      state = UserModelError(message: '로그인에 실패했습니다!');

      return Future.value(state);
    }
  }

  Future<void> logOut() async {
    state = null;
    Future.wait(
      [
        storage.delete(key: MyKey.refreshToken),
        storage.delete(key: MyKey.accessToken),
      ],
    );
  }
}
