import 'dart:async';
import 'package:http/http.dart' as http;
// ignore: depend_on_referenced_packages
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class FastCacheManager extends CacheManager {
  static final FastCacheManager instance = FastCacheManager._internal();

  factory FastCacheManager() => instance;

  FastCacheManager._internal()
      : super(
          Config(
            'fastCache',
            stalePeriod: const Duration(days: 7),
            maxNrOfCacheObjects: 200,
            fileService: HttpFileService(
              httpClient: TimeoutHttpClient(
                http.Client(),
                timeout: const Duration(seconds: 5),
              ),
            ),
          ),
        );
}

class TimeoutHttpClient extends http.BaseClient {
  final http.Client _inner;
  final Duration timeout;

  TimeoutHttpClient(this._inner, {required this.timeout});

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    return _inner.send(request).timeout(timeout);
  }
}
