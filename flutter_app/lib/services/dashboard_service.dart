import '../core/api/api_client.dart';
import '../core/api/endpoints.dart';
import '../models/dashboard_stats.dart';

class DashboardService {
  final _dio = ApiClient.instance.dio;

  Future<DashboardStats> getStats() async {
    final response = await _dio.get(
      Endpoints.dashboardStats,
    );

    return DashboardStats.fromJson(
      response.data,
    );
  }
}