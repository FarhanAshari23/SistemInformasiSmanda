import 'api_client.dart';

class Network {
  static final ApiClient apiClient = ApiClient(
    baseUrl: "http://192.168.18.3:3000/api",
    apiKey: "RAHASIA",
  );
}
