import 'package:go_router/go_router.dart';

import '../../features/dashboard/pages/dashboard_page.dart';
import '../../features/auth/pages/login_page.dart';
import '../../features/adherents/pages/adherents_page.dart';
import '../../features/analyse/pages/analyse_page.dart';
import '../../features/historique/pages/historique_page.dart';
import '../../features/session/pages/session_terminee_page.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/login',
  routes: [
    GoRoute(path: '/login', builder: (context, state) => const LoginPage()),
    GoRoute(path: '/dashboard', builder: (context, state) => const DashboardPage()),
    GoRoute(path: '/adherents', builder: (context, state) => const AdherentsPage()),
    GoRoute(path: '/analyse', builder: (context, state) => const AnalysePage()),
    GoRoute(path: '/historique', builder: (context, state) => const HistoriquePage()),
    GoRoute(path: '/session-terminee', builder: (context, state) => const SessionTermineePage()),
 
  ],

);