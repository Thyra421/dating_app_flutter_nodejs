class Api {
  static Future<bool> login() {
    return Future.delayed(const Duration(seconds: 2), () => true);
  }
}
