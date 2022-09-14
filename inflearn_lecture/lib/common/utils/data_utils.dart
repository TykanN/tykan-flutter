import 'package:inflearn_lecture/common/const/data.dart';

class DataUtils {
  static String pathToUrl(String value) => '$host$value';

  static List<String> listPathstoUrls(List paths) {
    return paths.map((e) => pathToUrl(e)).toList();
  }
}
