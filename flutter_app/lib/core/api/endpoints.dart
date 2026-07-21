class Endpoints {
  Endpoints._();

  // TODO: remplacer par l'URL de ton backend (ex: http://10.0.2.2:8000 pour l'émulateur Android)
  static const String baseUrl = 'http://127.0.0.1:8000';

  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String coaches = '/coachs';
  static const String adherents = '/adherents/';
}