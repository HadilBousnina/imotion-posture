import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/analyse_posturale.dart';
import '../services/analyse_service.dart';

final analyseServiceProvider = Provider<AnalyseService>(
  (ref) => AnalyseService(),
);

class AnalyseNotifier
    extends StateNotifier<AsyncValue<AnalysePosturale?>> {
  AnalyseNotifier(this._service)
      : super(const AsyncData(null));

  final AnalyseService _service;

  Future<void> analyserVideo(File video) async {
    state = const AsyncLoading();

    try {
      final result = await _service.analyserVideo(video);

      state = AsyncData(result);
    } catch (e, stackTrace) {
      state = AsyncError(e, stackTrace);
    }
  }

  void reset() {
    state = const AsyncData(null);
  }
}

final analyseProvider = StateNotifierProvider<
    AnalyseNotifier,
    AsyncValue<AnalysePosturale?>>(
  (ref) => AnalyseNotifier(
    ref.read(analyseServiceProvider),
  ),
);