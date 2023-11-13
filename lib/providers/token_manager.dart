import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Handles the storage and retrieval of JWT tokens using FlutterSecureStorage.
class TokenManager {
  /// Instance of FlutterSecureStorage used for secure storage operations.
  static const storage = FlutterSecureStorage();

  /// Stores the JWT token securely.
  ///
  /// The [token] is saved with the key 'jwt_token'.
  static void storeToken(String token) async {
    await storage.write(key: 'jwt_token', value: token);
  }

  /// Retrieves the stored JWT token.
  ///
  /// Returns the JWT token if it exists, otherwise returns null.
  static Future<String?> getToken() async {
    return await storage.read(key: 'jwt_token');
  }

  /// Removes the stored JWT token.
  ///
  /// Deletes the token associated with the key 'jwt_token'.
  static void removeToken() async {
    await storage.delete(key: 'jwt_token');
  }
}
