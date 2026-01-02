import 'dart:io';

Future<bool> isUrlReachable(String url) async {
  try {
    final uri = Uri.parse(url);

    final request = await HttpClient().headUrl(uri);
    final response = await request.close();

    return response.statusCode >= 200 && response.statusCode < 400;
  } catch (e) {
    return false;
  }
}
