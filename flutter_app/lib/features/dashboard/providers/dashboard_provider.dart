import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/dashboard_stats.dart';
import '../services/dashboard_service.dart';

final dashboardServiceProvider = Provider<DashboardService>((ref) {
  return DashboardService();
});

final dashboardStatsProvider = FutureProvider<DashboardStats>((ref) async {
  final service = ref.read(dashboardServiceProvider);

  return service.getStats();
});