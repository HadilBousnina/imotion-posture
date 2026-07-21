import '../core/api/api_client.dart';
import '../core/api/endpoints.dart';
import '../core/storage/secure_storage.dart';
import '../models/adherent.dart';

class AdherentService {
  final _dio = ApiClient.instance.dio;

  Future<List<Adherent>> getAdherents() async {
    final response = await _dio.get(Endpoints.adherents);
    final data = response.data as List;
    return data.map((json) => Adherent.fromJson(json)).toList();
  }

  Future<Adherent> createAdherent({
    required String nom,
    required String prenom,
    String? dateNaissance,
    String? sexe,
    double? taille,
    double? poids,
    String? telephone,
    String? objectif,
  }) async {
    final coachId = await SecureStorage.instance.getCoachId();
    if (coachId == null) {
      throw Exception('Coach non identifié. Reconnectez-vous.');
    }

    final response = await _dio.post(
      Endpoints.adherents,
      data: {
        'nom': nom,
        'prenom': prenom,
        'date_naissance': dateNaissance,
        'sexe': sexe,
        'taille': taille,
        'poids': poids,
        'telephone': telephone,
        'objectif': objectif,
        'id_coach': coachId,
      },
    );
    return Adherent.fromJson(response.data);
  }
}