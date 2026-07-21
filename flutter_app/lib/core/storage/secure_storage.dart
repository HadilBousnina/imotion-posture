import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  SecureStorage._();
  static final SecureStorage instance = SecureStorage._();

  final _storage = const FlutterSecureStorage();

  static const _tokenKey = 'jwt_token';
  static const _rememberKey = 'remember_me';
  static const _coachIdKey = 'coach_id';

  Future<void> saveCoachId(int id) =>
      _storage.write(key: _coachIdKey, value: id.toString());

  Future<int?> getCoachId() async {
    final value = await _storage.read(key: _coachIdKey);
    return value != null ? int.tryParse(value) : null;
  }

  Future<void> saveToken(String token) =>
      _storage.write(key: _tokenKey, value: token);

  Future<String?> getToken() => _storage.read(key: _tokenKey);

  Future<void> deleteToken() => _storage.delete(key: _tokenKey);

  Future<void> setRememberMe(bool value) =>
      _storage.write(key: _rememberKey, value: value.toString());

  Future<bool> getRememberMe() async {
    final value = await _storage.read(key: _rememberKey);
    return value == 'true';
  }
}