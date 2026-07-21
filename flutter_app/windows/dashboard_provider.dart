import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/adherent.dart';

final adherentsProvider = Provider<List<Adherent>>((ref) {
  return [
    Adherent(id: "1", nom: "Mohamed Ben Ali", dernierScore: 82, derniereSession: DateTime(2026, 6, 24)),
    Adherent(id: "2", nom: "Sarra Ben Said", dernierScore: 76, derniereSession: DateTime(2026, 6, 24)),
    Adherent(id: "3", nom: "Youssef Khemiri", dernierScore: 68, derniereSession: DateTime(2026, 6, 23)),
    Adherent(id: "4", nom: "Amel Trabelsi", dernierScore: 90, derniereSession: DateTime(2026, 6, 23)),
  ];
});