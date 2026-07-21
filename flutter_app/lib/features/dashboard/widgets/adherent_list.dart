import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../models/adherent.dart';
import '../../../services/adherent_service.dart';

class AdherentList extends StatefulWidget {
  const AdherentList({super.key});

  @override
  State<AdherentList> createState() => _AdherentListState();
}

class _AdherentListState extends State<AdherentList> {
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
    _futureAdherents = AdherentService().getAdherents();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        /// Barre de recherche + filtre
        Row(
          children: [
            Expanded(
              child: Container(
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
            ),
            const SizedBox(width: 14),
            Container(
              height: 46,
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: AppColors.surfaceLight,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: "all",
                  dropdownColor: AppColors.surface,
                  icon: const Icon(Icons.keyboard_arrow_down, color: AppColors.textSecondary),
                  style: const TextStyle(color: AppColors.textPrimary, fontSize: 14),
                  items: const [
                    DropdownMenuItem(value: "all", child: Text("Tous les adhérents")),
                    DropdownMenuItem(value: "active", child: Text("Actifs")),
                    DropdownMenuItem(value: "inactive", child: Text("Inactifs")),
                  ],
                  onChanged: (value) {
                    // TODO : filtrage
                  },
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 20),

        /// Liste des adhérents (connectée à l'API)
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
                    "Erreur de chargement : ${snapshot.error}",
                    style: const TextStyle(color: AppColors.error),
                  ),
                );
              }

              final adherents = snapshot.data ?? [];

              if (adherents.isEmpty) {
                return const Center(
                  child: Text(
                    "Aucun adhérent trouvé",
                    style: TextStyle(color: AppColors.textSecondary),
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
                                adherent.objectif ?? "Aucun objectif défini",
                                style: const TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        ElevatedButton.icon(
                          onPressed: () {
                            // TODO : GoRouter -> écran Analyse temps réel
                          },
                          icon: const Icon(Icons.play_arrow_rounded, size: 18),
                          label: const Text("Démarrer"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 18,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        OutlinedButton.icon(
                          onPressed: () {
                            // TODO : GoRouter -> écran Historique
                          },
                          icon: const Icon(Icons.history, size: 18),
                          label: const Text("Historique"),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.textPrimary,
                            side: const BorderSide(color: AppColors.border),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 18,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.more_vert,
                            color: AppColors.textSecondary,
                            size: 20,
                          ),
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
    );
  }
}