import 'dart:io';

abstract class MyKey {
  static const accessToken = 'accessToken';
  static const refreshToken = 'refreshToken';
}

final host = Platform.isIOS ? 'http://localhost:3000' : 'http://10.0.2.2:3000';
