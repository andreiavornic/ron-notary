import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

FutureOr<Response> makeRequest(String path, String method, dynamic data) async {
  try {
    var dio = Dio();
    final prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('TOKEN');
    dio.options = BaseOptions(
      baseUrl: dotenv.env['URL'],
      headers: {
        HttpHeaders.authorizationHeader: "Bearer $token",
        HttpHeaders.contentTypeHeader: 'application/json'
      },
    );

    print("$method: ${dio.options.baseUrl}$path");

    Response response;
    switch (method) {
      case ("POST"):
        response = await dio.post(path, data: data);
        break;
      case ("PUT"):
        response = await dio.put(path, data: data);
        break;
      case ("DELETE"):
        response = await dio.delete(path);
        break;
      default:
        response = await dio.get(path);
        break;
    }
    return response;
  } on DioError catch (e) {
    if (e.response.statusCode == 502) {
      return Response(
        data: {
          "success": false,
          "message": "SERVE_NOT_RESPONSE",
        }, requestOptions: null,
      );
    }
    if (e.response != null) {
      return e.response;
    } else {
      throw e.message;
    }
  }
}
