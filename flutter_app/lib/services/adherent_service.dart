import '../core/api/api_client.dart';
import '../core/api/endpoints.dart';
import '../models/adherent.dart';

class AdherentService {
  final _dio = ApiClient.instance.dio;

  // =========================================================
  // GET — récupérer tous les adhérents
  // =========================================================

  Future<List<Adherent>> getAdherents() async {
    final response = await _dio.get(
      Endpoints.adherents,
    );

    final data = response.data as List;

    return data
        .map((json) => Adherent.fromJson(json))
        .toList();
  }

  // =========================================================
  // CREATE — créer un adhérent
  // =========================================================

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
      },
    );

    return Adherent.fromJson(response.data);
  }

  // =========================================================
  // DELETE
  // =========================================================

  Future<void> deleteAdherent(int idAdherent) async {
    await _dio.delete(
      '${Endpoints.adherents}$idAdherent',
    );
  }
}