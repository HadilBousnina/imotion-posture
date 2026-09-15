import 'dart:typed_data';

import 'package:dio/dio.dart';

import '../core/api/api_client.dart';
import '../models/posture_analysis.dart';

class PostureService {
  final Dio _dio = ApiClient.instance.dio;

  Future<PostureAnalysis> analyzeVideo({
    required Uint8List bytes,
    required String fileName,
  }) async {
    final formData = FormData.fromMap({
      "video": MultipartFile.fromBytes(
        bytes,
        filename: fileName,
      ),
    });

    final response = await _dio.post(
      "/posture/analyze-video",
      data: formData,
    );

    return PostureAnalysis.fromJson(response.data);
  }
}