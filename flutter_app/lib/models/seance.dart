class SeanceEms {
  final int? idSeance;
  final int idAdherent;
  final int idCoach;

  final DateTime dateDebut;
  final DateTime? dateFin;

  final int? duree;
  final double? scoreGlobal;
  final String? commentaire;

  const SeanceEms({
    this.idSeance,
    required this.idAdherent,
    required this.idCoach,
    required this.dateDebut,
    this.dateFin,
    this.duree,
    this.scoreGlobal,
    this.commentaire,
  });

  // =========================================================
  // FROM JSON
  // =========================================================

  factory SeanceEms.fromJson(Map<String, dynamic> json) {
    return SeanceEms(
      idSeance: (json['id_seance'] as num?)?.toInt(),

      idAdherent:
          (json['id_adherent'] as num?)?.toInt() ?? 0,

      idCoach:
          (json['id_coach'] as num?)?.toInt() ?? 0,

      dateDebut:
          DateTime.tryParse(
            json['date_debut']?.toString() ?? '',
          ) ??
          DateTime.now(),

      dateFin: json['date_fin'] != null
          ? DateTime.tryParse(
              json['date_fin'].toString(),
            )
          : null,

      duree:
          (json['duree'] as num?)?.toInt(),

      scoreGlobal:
          (json['score_global'] as num?)?.toDouble(),

      commentaire:
          json['commentaire']?.toString(),
    );
  }

  // =========================================================
  // TO JSON
  // =========================================================

  Map<String, dynamic> toJson() {
    return {
      'id_adherent': idAdherent,
      'date_debut': dateDebut.toIso8601String(),
      if (dateFin != null)
        'date_fin': dateFin!.toIso8601String(),
      if (duree != null)
        'duree': duree,
      if (scoreGlobal != null)
        'score_global': scoreGlobal,
      if (commentaire != null)
        'commentaire': commentaire,
    };
  }
}