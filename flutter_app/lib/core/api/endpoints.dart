class Endpoints {
  Endpoints._();

  static const String baseUrl = 'http://127.0.0.1:8000';

  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String coaches = '/coachs';

  static const String adherents = '/adherents/';
  static const String seancesEms = '/seances-ems/';
  static const String dashboardStats = '/dashboard/stats';

  static const String analysePosture =
      "/posture/analyze-video";
}