import 'dart:io';

import 'package:dio/dio.dart';

import '../../../core/api/api_client.dart';
import '../../../core/api/endpoints.dart';
import '../../../models/analyse_posturale.dart';


class AnalyseService {

  final _dio = ApiClient.instance.dio;


  Future<AnalysePosturale> analyserVideo(
    File video,
  ) async {

    final formData = FormData.fromMap({

      "video": await MultipartFile.fromFile(
        video.path,
        filename: video.path.split('/').last,
      ),

    });


    final response = await _dio.post(
      Endpoints.analysePosture,
      data: formData,
      options: Options(
        contentType: "multipart/form-data",
      ),
    );


    return AnalysePosturale.fromJson(
      response.data,
    );
  }
}