import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../models/adherent.dart';
import '../../../services/adherent_service.dart';
import '../../dashboard/widgets/sidebar.dart';
import '../widgets/adherent_form_dialog.dart';

class AdherentsPage extends StatefulWidget {
  const AdherentsPage({super.key});

  @override
  State<AdherentsPage> createState() => _AdherentsPageState();
}

class _AdherentsPageState extends State<AdherentsPage> {
  late Future<List<Adherent>> _futureAdherents;

  static const List<Color> _avatarColors = [
    AppColors.primary,
    AppColors.success,
    AppColors.warning,
    AppColors.info,
  ];

  @override
  void initState() {
    super.initState();
    _loadAdherents();
  }

  void _loadAdherents() {
    _futureAdherents = AdherentService().getAdherents();
  }

  Future<void> _openCreateDialog() async {
    final created = await showDialog<bool>(
      context: context,
      builder: (context) => const AdherentFormDialog(),
    );

    if (created == true) {
      setState(_loadAdherents);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Row(
        children: [
          // Sidebar gère déjà sa propre largeur fixe (280px) en interne,
          // donc pas besoin de la contraindre à nouveau ici.
          const Sidebar(selectedIndex: 1),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// En-tête
                  Row(
                    children: [
                      const Expanded(
                        child: Text(
                          "Adhérents",
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: _openCreateDialog,
                        icon: const Icon(Icons.add_rounded, size: 20),
                        label: const Text("Nouvel adhérent"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 14,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  /// Barre de recherche
                  Container(
                    height: 46,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceLight,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.search, color: AppColors.textSecondary, size: 20),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            style: const TextStyle(color: AppColors.textPrimary, fontSize: 14),
                            decoration: InputDecoration(
                              isDense: true,
                              border: InputBorder.none,
                              hintText: "Rechercher un adhérent...",
                              hintStyle: TextStyle(color: AppColors.textSecondary, fontSize: 14),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  /// Liste
                  Expanded(
                    child: FutureBuilder<List<Adherent>>(
                      future: _futureAdherents,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(color: AppColors.primary),
                          );
                        }

                        if (snapshot.hasError) {
                          return Center(
                            child: Text(
                              "Erreur : ${snapshot.error}",
                              style: const TextStyle(color: AppColors.error),
                            ),
                          );
                        }

                        final adherents = snapshot.data ?? [];

                        if (adherents.isEmpty) {
                          return Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.people_outline, color: AppColors.textSecondary, size: 48),
                                const SizedBox(height: 12),
                                const Text(
                                  "Aucun adhérent pour l'instant",
                                  style: TextStyle(color: AppColors.textSecondary),
                                ),
                                const SizedBox(height: 16),
                                TextButton.icon(
                                  onPressed: _openCreateDialog,
                                  icon: const Icon(Icons.add),
                                  label: const Text("Ajouter le premier adhérent"),
                                ),
                              ],
                            ),
                          );
                        }

                        return ListView.separated(
                          itemCount: adherents.length,
                          separatorBuilder: (_, __) => const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            final adherent = adherents[index];
                            final avatarColor = _avatarColors[index % _avatarColors.length];

                            return Container(
                              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                              decoration: BoxDecoration(
                                color: AppColors.surfaceLight,
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(color: AppColors.border),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 46,
                                    height: 46,
                                    decoration: BoxDecoration(
                                      color: avatarColor.withOpacity(0.18),
                                      shape: BoxShape.circle,
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(
                                      adherent.prenom.isNotEmpty
                                          ? adherent.prenom[0].toUpperCase()
                                          : '?',
                                      style: TextStyle(
                                        color: avatarColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 17,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          adherent.fullName,
                                          style: const TextStyle(
                                            color: AppColors.textPrimary,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        const SizedBox(height: 3),
                                        Text(
                                          adherent.telephone ?? "Aucun téléphone",
                                          style: const TextStyle(
                                            color: AppColors.textSecondary,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    adherent.objectif ?? "Aucun objectif",
                                    style: const TextStyle(
                                      color: AppColors.textSecondary,
                                      fontSize: 13,
                                    ),
                                  ),
                                  const SizedBox(width: 20),
                                  IconButton(
                                    onPressed: () {},
                                    icon: const Icon(Icons.more_vert, color: AppColors.textSecondary, size: 20),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
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