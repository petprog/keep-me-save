import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Authentication {
  static final String _KEY_AUTH = "KEY_AUTH";
  final storage = const FlutterSecureStorage();
  var isLogin = false;
  Future<void> saveLogin() async {
    await storage.write(key: _KEY_AUTH, value: 'true');
  }

  Future<bool> isLoginAuth() async {
    String isAuthenticated = await storage.read(key: _KEY_AUTH) ?? "false";
    if ("true" == isAuthenticated) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> logout() async {
    await storage.delete(key: _KEY_AUTH);
  }
}
