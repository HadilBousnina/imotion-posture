import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  // =========================================================
  // TOKEN
  // =========================================================

  static const String _tokenKey = 'access_token';

  // =========================================================
  // SAUVEGARDER LE TOKEN
  // =========================================================

  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(
      _tokenKey,
      token,
    );
  }

  // =========================================================
  // RÉCUPÉRER LE TOKEN
  // =========================================================

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getString(
      _tokenKey,
    );
  }

  // =========================================================
  // SUPPRIMER LE TOKEN
  // =========================================================

  static Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove(
      _tokenKey,
    );
  }

  // =========================================================
  // VÉRIFIER SI L'UTILISATEUR EST CONNECTÉ
  // =========================================================

  static Future<bool> isAuthenticated() async {
    final token = await getToken();

    return token != null && token.isNotEmpty;
  }
}