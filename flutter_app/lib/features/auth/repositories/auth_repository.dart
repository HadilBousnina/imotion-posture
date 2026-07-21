import 'package:dio/dio.dart';
import '../../../core/api/api_client.dart';
import '../../../core/api/endpoints.dart';
import '../../../core/storage/secure_storage.dart';

class AuthException implements Exception {
  final String message;
  AuthException(this.message);
}

class AuthRepository {
  final Dio _dio = ApiClient.instance.dio;

  Future<void> login({
    required String email,
    required String password,
    required bool rememberMe,
  }) async {
    try {
      final response = await _dio.post(
        Endpoints.login,
        data: {
          'username': email, // Le backend attend "username", pas "email"
          'password': password,
        },
        options: Options(
          contentType: Headers.formUrlEncodedContentType, // Format urlencoded
        ),
      );

      final token = response.data['access_token'] as String?;
      if (token == null) {
        throw AuthException('Réponse invalide du serveur.');
      }

      await SecureStorage.instance.saveToken(token);
      await SecureStorage.instance.setRememberMe(rememberMe);

      // Récupère le profil du coach connecté pour obtenir son id_coach
      await _fetchAndSaveCoachId();
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw AuthException('Email ou mot de passe incorrect.');
      }
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.connectionError) {
        throw AuthException('Impossible de contacter le serveur.');
      }
      throw AuthException('Une erreur est survenue. Réessayez.');
    }
  }

  Future<void> _fetchAndSaveCoachId() async {
    try {
      final meResponse = await _dio.get('/auth/me');
      // ⚠️ à confirmer : le champ peut s'appeler "id_coach" ou juste "id"
      final coachId = meResponse.data['id_coach'] ?? meResponse.data['id'];
      if (coachId != null) {
        await SecureStorage.instance.saveCoachId(coachId as int);
      }
    } catch (_) {
      // Si /auth/me échoue, on ne bloque pas le login,
      // mais la création d'adhérent échouera plus tard si l'id est manquant.
    }
  }

  Future<bool> isLoggedIn() async {
    final token = await SecureStorage.instance.getToken();
    return token != null;
  }

  Future<void> logout() => SecureStorage.instance.deleteToken();
}