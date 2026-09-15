import 'package:go_router/go_router.dart';

import '../../features/dashboard/pages/dashboard_page.dart';
import '../../features/auth/pages/login_page.dart';
import '../../features/adherents/pages/adherents_page.dart';
import '../../features/analyse/pages/analyse_page.dart';
import '../../features/historique/pages/historique_page.dart';
import '../../features/historique/pages/seance_detail_page.dart';
import '../../features/historique/pages/statistiques_page.dart';
import '../../features/session/pages/session_terminee_page.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/login',

  routes: [
    // =========================================================
    // AUTHENTIFICATION
    // =========================================================

    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginPage(),
    ),

    // =========================================================
    // DASHBOARD
    // =========================================================

    GoRoute(
      path: '/dashboard',
      builder: (context, state) => const DashboardPage(),
    ),

    // =========================================================
    // ADHÉRENTS
    // =========================================================

    GoRoute(
      path: '/adherents',
      builder: (context, state) => const AdherentsPage(),
    ),

    // =========================================================
    // ANALYSE
    // =========================================================

    GoRoute(
      path: '/analyse',
      builder: (context, state) {
        final idAdherent =
            state.extra is int
                ? state.extra as int
                : null;

        return AnalysePage(
          idAdherent: idAdherent,
        );
      },
    ),

    // =========================================================
    // HISTORIQUE
    // =========================================================

    GoRoute(
      path: '/historique',
      builder: (context, state) => const HistoriquePage(),
    ),

    // =========================================================
    // DÉTAILS D'UNE SÉANCE
    // =========================================================

    GoRoute(
      path: '/seance-detail',
      builder: (context, state) {
        final idSeance =
            state.extra is int
                ? state.extra as int
                : null;

        if (idSeance == null) {
          return const HistoriquePage();
        }

        return SeanceDetailPage(
          idSeance: idSeance,
        );
      },
    ),

    // =========================================================
    // SESSION TERMINÉE
    // =========================================================

    GoRoute(
      path: '/session-terminee',
      builder: (context, state) {
        final data =
            state.extra as Map<String, dynamic>?;

        final errors =
            (data?['erreurs'] as List<dynamic>?)
                    ?.map(
                      (e) => e.toString(),
                    )
                    .toList() ??
                [];

        return SessionTermineePage(
          score: data?['score'] ?? 0,
          duree: data?['duree'] ?? "00:00",
          nbSquats: data?['nbSquats'] ?? 0,
          precision: data?['precision'] ?? 0,
          scorePrecedent:
              data?['scorePrecedent'] ?? 0,
          progression:
              data?['progression'] ?? 0,
          erreurs: fromStrings(errors),
        );
      },
    ),
    GoRoute(
      path: '/statistiques',
      builder: (context, state) =>
          const StatistiquesPage(),
    ),
  ],
);                                    