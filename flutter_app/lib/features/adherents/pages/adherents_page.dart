import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../dashboard/widgets/adherent_list.dart';
import '../../dashboard/widgets/sidebar.dart';
import '../widgets/adherent_form_dialog.dart';

class AdherentsPage extends StatefulWidget {
  const AdherentsPage({super.key});

  @override
  State<AdherentsPage> createState() => _AdherentsPageState();
}

class _AdherentsPageState extends State<AdherentsPage> {
  final GlobalKey<AdherentListState> _adherentListKey =
      GlobalKey<AdherentListState>();

  // ===========================================================
  // AJOUT D'UN ADHÉRENT
  // ===========================================================

  Future<void> _openAddAdherentDialog() async {
    
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return const AdherentFormDialog();
      },
    );

    // Si l'adhérent a été créé avec succès,
    // on recharge la liste.
    if (result == true) {
      await _adherentListKey.currentState?.refresh();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Row(
        children: [
          // =====================================================
          // SIDEBAR
          // =====================================================

          const Sidebar(
            selectedIndex: 1,
          ),

          // =====================================================
          // CONTENU
          // =====================================================

          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // =================================================
                  // EN-TÊTE
                  // =================================================

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Adhérents',
                              style: TextStyle(
                                color: AppColors.textPrimary,
                                fontSize: 28,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Gérez les adhérents et suivez leurs performances.',
                              style: TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // =================================================
                      // NOUVEL ADHÉRENT
                      // =================================================

                      SizedBox(
                        width: 190,
                        child: ElevatedButton.icon(
                          onPressed: _openAddAdherentDialog,
                          icon: const Icon(
                            Icons.person_add_alt_1_rounded,
                            size: 19,
                          ),
                          label: const Text(
                            'Nouvel adhérent',
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 14,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),

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
                      child: AdherentList(
                        key: _adherentListKey,
                      ),
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
