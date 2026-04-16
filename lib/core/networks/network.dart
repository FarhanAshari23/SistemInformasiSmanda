import 'package:new_sistem_informasi_smanda/core/constants/app_url.dart';

import 'api_client.dart';

class Network {
  static final ApiClient apiClient = ApiClient(
    baseUrl: "${AppUrl.mainRoute}/api",
    apiKey: "RAHASIA",
  );
}
