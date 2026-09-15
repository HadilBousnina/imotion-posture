import 'dart:convert';

import 'package:http/http.dart' as http;

import '../core/storage/secure_storage.dart';
import '../models/seance.dart';

class SeanceService {
  // =========================================================
  // CONFIGURATION
  // =========================================================

  static const String baseUrl = 'http://127.0.0.1:8000';

  // =========================================================
  // TOKEN
  // =========================================================

  Future<String> _getToken() async {
    final token = await SecureStorage.instance.getToken();

    if (token == null || token.isEmpty) {
      throw Exception(
        'Utilisateur non authentifié.',
      );
    }

    return token;
  }

  // =========================================================
  // GET ALL
  // =========================================================

  Future<List<SeanceEms>> getSeances() async {
    final token = await _getToken();

    final response = await http.get(
      Uri.parse('$baseUrl/seances-ems/'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode != 200) {
      throw Exception(
        'Erreur lors de la récupération des séances : '
        '${response.statusCode} - ${response.body}',
      );
    }

    final decoded = jsonDecode(response.body);

    if (decoded is! List) {
      throw Exception(
        'Réponse invalide du serveur.',
      );
    }

    return decoded
        .map(
          (json) => SeanceEms.fromJson(
            json as Map<String, dynamic>,
          ),
        )
        .toList();
  }

  // =========================================================
  // GET ONE
  // =========================================================

  Future<SeanceEms> getSeance(
    int idSeance,
  ) async {
    final token = await _getToken();

    final response = await http.get(
      Uri.parse(
        '$baseUrl/seances-ems/$idSeance',
      ),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode != 200) {
      throw Exception(
        'Séance introuvable : '
        '${response.statusCode} - ${response.body}',
      );
    }

    final decoded = jsonDecode(response.body);

    if (decoded is! Map<String, dynamic>) {
      throw Exception(
        'Réponse invalide du serveur.',
      );
    }

    return SeanceEms.fromJson(
      decoded,
    );
  }

  // =========================================================
  // CREATE
  // =========================================================

  Future<SeanceEms> createSeance(
    SeanceEms seance,
  ) async {
    final token = await _getToken();

    final response = await http.post(
      Uri.parse('$baseUrl/seances-ems/'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(
        seance.toJson(),
      ),
    );

    if (response.statusCode != 201) {
      throw Exception(
        'Erreur lors de la création de la séance : '
        '${response.statusCode} - ${response.body}',
      );
    }

    final decoded = jsonDecode(response.body);

    if (decoded is! Map<String, dynamic>) {
      throw Exception(
        'Réponse invalide du serveur.',
      );
    }

    return SeanceEms.fromJson(
      decoded,
    );
  }

  // =========================================================
  // UPDATE
  // =========================================================

  Future<SeanceEms> updateSeance(
    int idSeance,
    SeanceEms seance,
  ) async {
    final token = await _getToken();

    final response = await http.put(
      Uri.parse(
        '$baseUrl/seances-ems/$idSeance',
      ),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(
        seance.toJson(),
      ),
    );

    if (response.statusCode != 200) {
      throw Exception(
        'Erreur lors de la modification de la séance : '
        '${response.statusCode} - ${response.body}',
      );
    }

    final decoded = jsonDecode(response.body);

    if (decoded is! Map<String, dynamic>) {
      throw Exception(
        'Réponse invalide du serveur.',
      );
    }

    return SeanceEms.fromJson(
      decoded,
    );
  }

  // =========================================================
  // DELETE
  // =========================================================

  Future<void> deleteSeance(
    int idSeance,
  ) async {
    final token = await _getToken();

    final response = await http.delete(
      Uri.parse(
        '$baseUrl/seances-ems/$idSeance',
      ),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode != 200) {
      throw Exception(
        'Erreur lors de la suppression de la séance : '
        '${response.statusCode} - ${response.body}',
      );
    }
  }
}