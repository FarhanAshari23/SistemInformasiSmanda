import 'check_url.dart';

class CacheStateImage {
  static final Map<String, bool> _reachableCache = {};

  static Future<bool> checkUrl(String url) async {
    if (_reachableCache.containsKey(url)) return _reachableCache[url]!;

    final result = await isUrlReachable(url);
    _reachableCache[url] = result;
    return result;
  }
}
