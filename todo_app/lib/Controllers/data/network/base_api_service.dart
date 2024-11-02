import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:todo_app/Controllers/data/network/network_api_responce.dart';
import 'package:todo_app/Controllers/data/response/app_exceptions.dart';
import 'package:todo_app/constants/service/hive_service.dart';


class NetworkApiService extends BaseApiService {
  Dio dio = Dio();
//get Api Responce
  @override
  Future getApiResponse(
    String url,
    dynamic queryParameters,
    bool tokentrue,
  ) async {
    if (kDebugMode) {
      print('Api Url ====>$url');
    }
    try {
      Map<String, String> header;
      if (tokentrue) {
        header = {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': "Bearer ${await HiveService.getUserToken()}",
        };
      } else {
        header = {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        };
      }
      final response = await dio
          .get(url, options: Options(headers: header))
          .timeout(const Duration(seconds: 20));

      if (kDebugMode) {
        print('Responce ====> ${response.data}');
      }
      return returnResponse(response);
    } on DioException catch (e) {
      if (e.response!.statusCode == 404) {
        throw UnauthorizedException(e.message);
      }
    }
  }

  //Post Api Responce
  @override
  Future postApiResponse(
    String url,
    data,
    bool tokentrue,
  ) async {
    try {
      Map<String, String> header;

      if (tokentrue) {
        header = {
          'Content-Type': 'application/json',
          'Authorization': "Bearer ${await HiveService.getUserToken()}",
        };
      } else {
        header = {'Content-Type': 'application/json'};
      }
      if (kDebugMode) {
        print('Api Url ====>$url');
        print('Api data ====>$data');
        print('Api data ====>$header');
      }
      final response = await dio
          .post(url, data: data, options: Options(headers: header))
          .timeout(const Duration(seconds: 20));
      if (kDebugMode) {}

      return returnResponse(response);
    } on DioException catch (e) {
      print(e);
      return jsonDecode(e.response.toString());
    }
  }

  //delete api responce
  @override
  Future deleteApiResponse(
    String url,
  ) {
    throw UnimplementedError();
  }

  @override
  Future putApiResponse(
    String url,
    data,
    bool tokentrue,
  ) async {
    try {
      Map<String, String> header;
      if (tokentrue) {
        header = {
          'Content-Type': 'application/json',
          'Authorization': "Bearer ${await HiveService.getUserToken()}",
        };
      } else {
        header = {'Content-Type': 'application/json'};
      }
      if (kDebugMode) {
        print('Api Url ====>$url');
        print('Api data ====>$data');
        // print('Api header ====>$header');
      }
      final response = await dio
          .put(url, data: data, options: Options(headers: header))
          .timeout(const Duration(seconds: 20));

      return returnResponse(response);
    } on DioException catch (e) {
      return jsonDecode(e.response.toString());
    }
  }

  dynamic returnResponse(Response response) async {
    if (response.statusCode == 200) {
      return jsonDecode(response.toString());
    } else if (response.statusCode == 201) {
      return jsonDecode(response.toString());
    } else {
      throw FetchDataException('Error occurred');
    }
  }
}
