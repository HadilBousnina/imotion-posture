class Coach {
  final int id;
  final String nom;
  final String prenom;
  final String email;

  Coach({
    required this.id,
    required this.nom,
    required this.prenom,
    required this.email,
  });

  factory Coach.fromJson(Map<String, dynamic> json) {
    return Coach(
      id: json['id'] as int,
      nom: json['nom'] as String? ?? '',
      prenom: json['prenom'] as String? ?? '',
      email: json['email'] as String,
    );
  }
}