import 'package:flutter_secure_storage/flutter_secure_storage.dart';

//Class that handels the JWT token
class TokenManager {
  static const storage = FlutterSecureStorage();

  static void storeToken(String token) async {
    await storage.write(key: 'jwt_token', value: token);
  }

  static Future<String?> getToken() async {
    String? token = await storage.read(key: 'jwt_token');
    return token;
  }

  static void removeToken() async {
    await storage.delete(key: 'jwt_token');
  }
}