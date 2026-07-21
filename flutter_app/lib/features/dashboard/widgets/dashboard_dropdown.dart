import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

/// Sens de tri disponibles pour la liste des adhérents.
enum SortOrder {
  scoreDesc,
  scoreAsc,
}

extension SortOrderLabel on SortOrder {
  String get label {
    switch (this) {
      case SortOrder.scoreDesc:
        return 'Score : décroissant';
      case SortOrder.scoreAsc:
        return 'Score : croissant';
    }
  }
}

/// Dropdown permettant de changer le sens de tri de la liste
/// des adhérents (par score). Widget de présentation pur :
/// la logique de tri elle-même reste dans le parent / provider.
class DashboardDropdown extends StatelessWidget {
  final SortOrder value;
  final ValueChanged<SortOrder> onChanged;

  const DashboardDropdown({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<SortOrder>(
          value: value,
          isDense: true,
          icon: const Icon(
            Icons.keyboard_arrow_down,
            color: AppColors.textSecondary,
            size: 20,
          ),
          dropdownColor: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
          items: SortOrder.values.map((order) {
            return DropdownMenuItem(
              value: order,
              child: Text(order.label),
            );
          }).toList(),
          onChanged: (newValue) {
            if (newValue != null) onChanged(newValue);
          },
        ),
      ),
    );
  }
}