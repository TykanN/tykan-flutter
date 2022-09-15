import 'dart:convert';

import 'package:inflearn_lecture/common/const/data.dart';

class DataUtils {
  static String pathToUrl(String value) => '$host$value';

  static List<String> listPathstoUrls(List paths) {
    return paths.map((e) => pathToUrl(e)).toList();
  }

  static String plainToBase64(String plain) {
    Codec<String, String> stringToBase64 = utf8.fuse(base64);
    return stringToBase64.encode(plain);
  }
}
