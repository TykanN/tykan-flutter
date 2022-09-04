import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract class MyKey {
  static const accessToken = 'accessToken';
  static const refreshToken = 'refreshToken';
}

const storage = FlutterSecureStorage();

final host = Platform.isIOS ? 'http://localhost:3000' : 'http://10.0.2.2:3000';
