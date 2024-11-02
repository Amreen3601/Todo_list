

abstract class BaseApiService {
  Future<dynamic> getApiResponse(
    String url,
    dynamic queryParameters,
    bool tokentrue,
  );
  Future<dynamic> postApiResponse(
    String url,
    dynamic data,
    bool tokentrue,
  );
  Future<dynamic> putApiResponse(
    String url,
    dynamic data,
    bool tokentrue,
  );
  Future<dynamic> deleteApiResponse(
    String url,
  );
}
