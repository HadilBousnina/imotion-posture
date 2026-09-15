import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../services/adherent_service.dart';

class AdherentFormDialog extends StatefulWidget {
  const AdherentFormDialog({super.key});

  @override
  State<AdherentFormDialog> createState() => _AdherentFormDialogState();
}

class _AdherentFormDialogState extends State<AdherentFormDialog> {
  final _formKey = GlobalKey<FormState>();

  final _nomController = TextEditingController();
  final _prenomController = TextEditingController();
  final _telephoneController = TextEditingController();
  final _objectifController = TextEditingController();
  final _tailleController = TextEditingController();
  final _poidsController = TextEditingController();

  String? _sexe;
  DateTime? _dateNaissance;

  bool _isSubmitting = false;
  String? _errorMessage;

  @override
  void dispose() {
    _nomController.dispose();
    _prenomController.dispose();
    _telephoneController.dispose();
    _objectifController.dispose();
    _tailleController.dispose();
    _poidsController.dispose();
    super.dispose();
  }

  // =========================================================
  // DATE DE NAISSANCE
  // =========================================================

  Future<void> _selectDateNaissance() async {
    final now = DateTime.now();

    final picked = await showDatePicker(
      context: context,
      initialDate: _dateNaissance ?? DateTime(now.year - 18),
      firstDate: DateTime(1900),
      lastDate: now,
      helpText: 'Date de naissance',
      cancelText: 'Annuler',
      confirmText: 'Valider',
    );

    if (picked == null || !mounted) return;

    setState(() {
      _dateNaissance = picked;
    });
  }

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');

    return '$day/$month/${date.year}';
  }

  String _formatDateForApi(DateTime date) {
    final year = date.year.toString().padLeft(4, '0');
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');

    return '$year-$month-$day';
  }

  // =========================================================
  // CREATION
  // =========================================================

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isSubmitting = true;
      _errorMessage = null;
    });

    try {
      await AdherentService().createAdherent(
        nom: _nomController.text.trim(),
        prenom: _prenomController.text.trim(),

        dateNaissance: _dateNaissance != null
            ? _formatDateForApi(_dateNaissance!)
            : null,

        sexe: _sexe,

        taille: double.tryParse(
          _tailleController.text.trim().replaceAll(',', '.'),
        ),

        poids: double.tryParse(
          _poidsController.text.trim().replaceAll(',', '.'),
        ),

        telephone: _telephoneController.text.trim().isEmpty
            ? null
            : _telephoneController.text.trim(),

        objectif: _objectifController.text.trim().isEmpty
            ? null
            : _objectifController.text.trim(),
      );

      if (!mounted) return;

      Navigator.of(context).pop(true);
    } catch (e) {
      debugPrint('🔴 CREATE ADHERENT ERROR: $e');

      if (!mounted) return;

      setState(() {
        _isSubmitting = false;
        _errorMessage = 'Erreur lors de la création de l’adhérent.';
      });
    }
  }

  // =========================================================
  // BUILD
  // =========================================================

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      titlePadding: const EdgeInsets.fromLTRB(28, 28, 28, 8),
      contentPadding: const EdgeInsets.fromLTRB(28, 8, 28, 0),
      actionsPadding: const EdgeInsets.fromLTRB(28, 12, 28, 20),

      title: const Text(
        'Nouvel adhérent',
        style: TextStyle(
          color: AppColors.textPrimary,
          fontSize: 22,
          fontWeight: FontWeight.w700,
        ),
      ),

      content: SizedBox(
        width: 470,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Ajoutez les informations de l’adhérent.',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                  ),
                ),

                const SizedBox(height: 22),

                // -------------------------------------------------
                // PRÉNOM / NOM
                // -------------------------------------------------

                Row(
                  children: [
                    Expanded(
                      child: _buildField(
                        controller: _prenomController,
                        label: 'Prénom *',
                        validator: (value) {
                          if (value == null ||
                              value.trim().isEmpty) {
                            return 'Requis';
                          }
                          return null;
                        },
                      ),
                    ),

                    const SizedBox(width: 12),

                    Expanded(
                      child: _buildField(
                        controller: _nomController,
                        label: 'Nom *',
                        validator: (value) {
                          if (value == null ||
                              value.trim().isEmpty) {
                            return 'Requis';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 14),

                // -------------------------------------------------
                // DATE / SEXE
                // -------------------------------------------------

                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: _isSubmitting
                            ? null
                            : _selectDateNaissance,
                        borderRadius: BorderRadius.circular(10),
                        child: InputDecorator(
                          decoration: _inputDecoration(
                            'Date de naissance',
                          ).copyWith(
                            suffixIcon: const Icon(
                              Icons.calendar_today_outlined,
                              size: 18,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          child: Text(
                            _dateNaissance == null
                                ? 'Sélectionner'
                                : _formatDate(_dateNaissance!),
                            style: TextStyle(
                              color: _dateNaissance == null
                                  ? AppColors.textSecondary
                                  : AppColors.textPrimary,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 12),

                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _sexe,
                        decoration: _inputDecoration('Sexe'),
                        dropdownColor: AppColors.surface,
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 14,
                        ),
                        items: const [
                          DropdownMenuItem(
                            value: 'M',
                            child: Text('Masculin'),
                          ),
                          DropdownMenuItem(
                            value: 'F',
                            child: Text('Féminin'),
                          ),
                        ],
                        onChanged: _isSubmitting
                            ? null
                            : (value) {
                                setState(() {
                                  _sexe = value;
                                });
                              },
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 14),

                // -------------------------------------------------
                // TÉLÉPHONE
                // -------------------------------------------------

                _buildField(
                  controller: _telephoneController,
                  label: 'Téléphone',
                  keyboardType: TextInputType.phone,
                ),

                const SizedBox(height: 14),

                // -------------------------------------------------
                // TAILLE / POIDS
                // -------------------------------------------------

                Row(
                  children: [
                    Expanded(
                      child: _buildField(
                        controller: _tailleController,
                        label: 'Taille (cm)',
                        keyboardType:
                            const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                      ),
                    ),

                    const SizedBox(width: 12),

                    Expanded(
                      child: _buildField(
                        controller: _poidsController,
                        label: 'Poids (kg)',
                        keyboardType:
                            const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 14),

                // -------------------------------------------------
                // OBJECTIF
                // -------------------------------------------------

                _buildField(
                  controller: _objectifController,
                  label: 'Objectif',
                  maxLines: 3,
                ),

                // -------------------------------------------------
                // ERREUR
                // -------------------------------------------------

                if (_errorMessage != null) ...[
                  const SizedBox(height: 14),
                  Text(
                    _errorMessage!,
                    style: const TextStyle(
                      color: AppColors.error,
                      fontSize: 13,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),

      // =========================================================
      // ACTIONS
      // =========================================================

      actions: [
        TextButton(
          onPressed: _isSubmitting
              ? null
              : () => Navigator.of(context).pop(false),
          child: const Text(
            'Annuler',
            style: TextStyle(
              color: AppColors.textSecondary,
            ),
          ),
        ),

        ElevatedButton(
          onPressed: _isSubmitting ? null : _submit,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            elevation: 0,
            padding: const EdgeInsets.symmetric(
              horizontal: 22,
              vertical: 12,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: _isSubmitting
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : const Text('Créer'),
        ),
      ],
    );
  }

  // =========================================================
  // INPUT DECORATION
  // =========================================================

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(
        color: AppColors.textSecondary,
        fontSize: 13,
      ),
      filled: true,
      fillColor: AppColors.surfaceLight,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 12,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(
          color: AppColors.border,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(
          color: AppColors.border,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(
          color: AppColors.primary,
        ),
      ),
    );
  }

  // =========================================================
  // TEXT FIELD
  // =========================================================

  Widget _buildField({
    required TextEditingController controller,
    required String label,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      keyboardType: keyboardType,
      maxLines: maxLines,
      enabled: !_isSubmitting,
      style: const TextStyle(
        color: AppColors.textPrimary,
        fontSize: 14,
      ),
      decoration: _inputDecoration(label),
    );
  }
}