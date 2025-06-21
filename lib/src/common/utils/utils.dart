class Utils {

  Utils._();

  static String getLocaleKey(Map<String, dynamic> data) {
    String key = "en";
    key = data.keys.first;

    print("Common Key: $key");

    return key;
  }
}