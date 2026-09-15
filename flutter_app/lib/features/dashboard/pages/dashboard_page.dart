import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../widgets/adherent_list.dart';
import '../widgets/dashboard_header.dart';
import '../widgets/metric_card.dart';
import '../widgets/sidebar.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Row(
        children: [
          // =====================================================
          // SIDEBAR
          // =====================================================

          SizedBox(
            width: 280,
            height: double.infinity,
            child: const Sidebar(
              selectedIndex: 0,
            ),
          ),

          // =====================================================
          // CONTENU PRINCIPAL
          // =====================================================

          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // =================================================
                  // HEADER
                  // =================================================

                  const DashboardHeader(),

                  const SizedBox(height: 35),

                  // =================================================
                  // CARTES STATISTIQUES
                  // =================================================

                  Wrap(
                    spacing: 18,
                    runSpacing: 18,
                    children: const [
                      MetricCard(
                        value: "23",
                        title: "Adhérents",
                        subtitle: "Total enregistrés",
                        icon: Icons.people_outline,
                      ),
                      MetricCard(
                        value: "12",
                        title: "Sessions",
                        subtitle: "Aujourd'hui",
                        icon: Icons.fitness_center_outlined,
                      ),
                      MetricCard(
                        value: "81",
                        title: "Score moyen",
                        subtitle: "Moyenne globale",
                        icon: Icons.trending_up,
                        valueColor: Colors.green,
                      ),
                      MetricCard(
                        value: "42%",
                        title: "Progression",
                        subtitle: "Ce mois",
                        icon: Icons.show_chart,
                        valueColor: Colors.orange,
                      ),
                    ],
                  ),

                  const SizedBox(height: 35),

                  // =================================================
                  // LISTE DES ADHÉRENTS
                  // =================================================

                  Expanded(
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: AppColors.border,
                        ),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: const AdherentList(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}