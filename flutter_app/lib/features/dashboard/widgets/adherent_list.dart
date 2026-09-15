import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../models/adherent.dart';
import '../../../services/adherent_service.dart';

class AdherentList extends StatefulWidget {
  const AdherentList({super.key});

  @override
  AdherentListState createState() => AdherentListState();
}

class AdherentListState extends State<AdherentList> {
  final TextEditingController _searchController = TextEditingController();
  final AdherentService _adherentService = AdherentService();

  List<Adherent> _adherents = [];
  bool _isLoading = true;
  String? _errorMessage;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadAdherents();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // ===========================================================
  // REFRESH PUBLIC
  // ===========================================================

  Future<void> refresh() async {
    await _loadAdherents();
  }

  // ===========================================================
  // CHARGEMENT DES ADHÉRENTS
  // ===========================================================

  Future<void> _loadAdherents() async {
    debugPrint('🟡 ADHERENTS : début chargement');

    if (mounted) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });
    }

    try {
      debugPrint('🟡 ADHERENTS : appel API');

      final adherents = await _adherentService.getAdherents();

      debugPrint(
        '🟢 ADHERENTS : API terminée → ${adherents.length} adhérents',
      );

      if (!mounted) return;

      setState(() {
        _adherents = adherents;
        _isLoading = false;
      });

      debugPrint('🟢 ADHERENTS : setState terminé');
    } catch (e) {
      debugPrint('🔴 ADHERENTS ERROR : $e');

      if (!mounted) return;

      setState(() {
        _isLoading = false;
        _errorMessage = 'Impossible de charger les adhérents.';
      });
    }
  }

  // ===========================================================
  // SUPPRESSION
  // ===========================================================

  Future<void> _deleteAdherent(Adherent adherent) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.surface,
          title: const Text(
            'Supprimer l’adhérent',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
          content: Text(
            'Voulez-vous vraiment supprimer ${adherent.fullName} ?\n\n'
            'Cette action est définitive.',
            style: const TextStyle(
              color: AppColors.textSecondary,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text(
                'Annuler',
                style: TextStyle(
                  color: AppColors.textSecondary,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.error,
                foregroundColor: Colors.white,
                elevation: 0,
              ),
              child: const Text('Supprimer'),
            ),
          ],
        );
      },
    );

    if (confirmed != true) return;

    try {
      await _adherentService.deleteAdherent(
        adherent.idAdherent,
      );

      if (!mounted) return;

      setState(() {
        _adherents.removeWhere(
          (item) => item.idAdherent == adherent.idAdherent,
        );
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Adhérent supprimé avec succès.'),
        ),
      );
    } catch (e) {
      debugPrint('🔴 DELETE ADHERENT ERROR : $e');

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Impossible de supprimer l’adhérent : $e',
          ),
        ),
      );
    }
  }

  // ===========================================================
  // BUILD
  // ===========================================================

  @override
  Widget build(BuildContext context) {
    final query = _searchQuery.trim().toLowerCase();

    final filteredAdherents = _adherents.where((adherent) {
      if (query.isEmpty) return true;

      return adherent.fullName.toLowerCase().contains(query) ||
          (adherent.telephone?.toLowerCase().contains(query) ?? false) ||
          (adherent.objectif?.toLowerCase().contains(query) ?? false);
    }).toList();

    return Padding(
      padding: const EdgeInsets.all(30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // =====================================================
          // RECHERCHE
          // =====================================================

          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 48,
                  child: TextField(
                    controller: _searchController,
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value;
                      });
                    },
                    decoration: InputDecoration(
                      hintText: 'Rechercher un adhérent...',
                      prefixIcon: const Icon(
                        Icons.search_rounded,
                        size: 20,
                        color: AppColors.textSecondary,
                      ),
                      filled: true,
                      fillColor: AppColors.background,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: AppColors.border,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: AppColors.border,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              SizedBox(
                width: 48,
                height: 48,
                child: IconButton(
                  onPressed: _loadAdherents,
                  tooltip: 'Actualiser',
                  style: IconButton.styleFrom(
                    backgroundColor: AppColors.background,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: const BorderSide(
                        color: AppColors.border,
                      ),
                    ),
                  ),
                  icon: const Icon(
                    Icons.refresh_rounded,
                    size: 20,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // =====================================================
          // CONTENU
          // =====================================================

          Expanded(
            child: _buildContent(filteredAdherents),
          ),
        ],
      ),
    );
  }

  // ===========================================================
  // CONTENU
  // ===========================================================

  Widget _buildContent(List<Adherent> adherents) {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          color: AppColors.primary,
        ),
      );
    }

    if (_errorMessage != null) {
      return _buildErrorState();
    }

    if (_adherents.isEmpty) {
      return _buildEmptyState(
        'Aucun adhérent',
        'Aucun adhérent n’est actuellement enregistré.',
      );
    }

    if (adherents.isEmpty) {
      return _buildEmptyState(
        'Aucun résultat',
        'Aucun adhérent ne correspond à votre recherche.',
      );
    }

    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: adherents.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: _buildAdherentCard(adherents[index]),
        );
      },
    );
  }

  // ===========================================================
  // CARTE ADHÉRENT
  // ===========================================================

  Widget _buildAdherentCard(Adherent adherent) {
    final score = adherent.dernierScore != null
        ? '${adherent.dernierScore}/100'
        : '—';

    final session = adherent.derniereSession?.isNotEmpty == true
        ? adherent.derniereSession!
        : 'Aucune session';

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: AppColors.border,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // =====================================================
          // NOM
          // =====================================================

          Text(
            adherent.fullName,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),

          const SizedBox(height: 6),

          // =====================================================
          // OBJECTIF
          // =====================================================

          Text(
            adherent.objectif?.isNotEmpty == true
                ? adherent.objectif!
                : 'Objectif non renseigné',
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 13,
            ),
          ),

          const SizedBox(height: 14),

          // =====================================================
          // INFORMATIONS
          // =====================================================

          Wrap(
            spacing: 24,
            runSpacing: 8,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.emoji_events_outlined,
                    size: 16,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Score : $score',
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.access_time_rounded,
                    size: 16,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    session,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
              if (adherent.telephone?.isNotEmpty == true)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.phone_outlined,
                      size: 16,
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      adherent.telephone!,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
            ],
          ),

          const SizedBox(height: 18),

          // =====================================================
          // ACTIONS
          // =====================================================

          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(
                  Icons.history_rounded,
                  size: 17,
                ),
                label: const Text('Historique'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.textPrimary,
                  side: const BorderSide(
                    color: AppColors.border,
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),

              // =================================================
              // DÉMARRER
              // =================================================

              ElevatedButton.icon(
                onPressed: () {
                  debugPrint(
                    '🟢 DÉMARRER SESSION → '
                    'adhérent=${adherent.fullName} '
                    'id=${adherent.idAdherent}',
                  );

                  context.push(
                    '/analyse',
                    extra: adherent.idAdherent,
                  );
                },
                icon: const Icon(
                  Icons.play_arrow_rounded,
                  size: 18,
                ),
                label: const Text('Démarrer'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),

              // =================================================
              // SUPPRIMER
              // =================================================

              ElevatedButton.icon(
                onPressed: () {
                  _deleteAdherent(adherent);
                },
                icon: const Icon(
                  Icons.delete_outline_rounded,
                  size: 18,
                ),
                label: const Text('Supprimer'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.error,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ===========================================================
  // ÉTAT VIDE
  // ===========================================================

  Widget _buildEmptyState(
    String title,
    String subtitle,
  ) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.people_outline_rounded,
            size: 48,
            color:
                AppColors.textSecondary.withOpacity(0.5),
          ),
          const SizedBox(height: 14),
          Text(
            title,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 7),
          Text(
            subtitle,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 13,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // ===========================================================
  // ERREUR
  // ===========================================================

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.cloud_off_rounded,
            size: 48,
            color: AppColors.textSecondary,
          ),
          const SizedBox(height: 14),
          const Text(
            'Impossible de charger les adhérents',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Vérifiez la connexion avec le serveur.',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 18),
          ElevatedButton.icon(
            onPressed: _loadAdherents,
            icon: const Icon(
              Icons.refresh_rounded,
            ),
            label: const Text(
              'Réessayer',
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  AppColors.primary,
              foregroundColor: Colors.white,
              elevation: 0,
            ),
          ),
        ],
      ),
    );
  }
}
