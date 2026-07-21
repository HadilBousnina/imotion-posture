class Adherent {
  final int idAdherent;
  final String nom;
  final String prenom;
  final String? dateNaissance;
  final String? sexe;
  final double? taille;
  final double? poids;
  final String? telephone;
  final String? objectif;
  final int idCoach;
  final String createdAt;

  const Adherent({
    required this.idAdherent,
    required this.nom,
    required this.prenom,
    this.dateNaissance,
    this.sexe,
    this.taille,
    this.poids,
    this.telephone,
    this.objectif,
    required this.idCoach,
    required this.createdAt,
  });

  factory Adherent.fromJson(Map<String, dynamic> json) {
    return Adherent(
      idAdherent: json['id_adherent'],
      nom: json['nom'] ?? '',
      prenom: json['prenom'] ?? '',
      dateNaissance: json['date_naissance'],
      sexe: json['sexe'],
      taille: (json['taille'] as num?)?.toDouble(),
      poids: (json['poids'] as num?)?.toDouble(),
      telephone: json['telephone'],
      objectif: json['objectif'],
      idCoach: json['id_coach'],
      createdAt: json['created_at'] ?? '',
    );
  }

  String get fullName => '$prenom $nom';
}