import 'package:flutter/foundation.dart';
import 'package:todo_app/Controllers/data/network/base_api_service.dart';
import 'package:todo_app/Models/To_do.dart';
import 'package:todo_app/constants/connectivity.dart';

class ApiRepsitory {
  final NetworkApiService _apiService = NetworkApiService();
  final ConnectivityService _connectivityService = ConnectivityService();

  Future<TodoModel> todoApi(
      {dynamic data, url, token, required context}) async {
    try {
      if (!(await _connectivityService.checkConnectivity(context))) {
        throw Exception('No Internet Connection');
      }

      dynamic response =
          await _apiService.postApiResponse(url, data, token ?? false);
      if (kDebugMode) {
        print(response);
      }

      // Parse the response with TodoModel
      return TodoModel.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }
}
