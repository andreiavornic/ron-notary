import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_storage/get_storage.dart';

// class DioService {
//   var dio = Dio();
//
//   DioService() {
//     final box = GetStorage();
//     var token = box.read('TOKEN');
//     dio.options = BaseOptions(
//       baseUrl: dotenv.env['URL'],
//       headers: {
//         HttpHeaders.authorizationHeader: "Bearer $token",
//         HttpHeaders.contentTypeHeader: 'application/json'
//       },
//     );
//   }
//
//   Future<Response> getData(String path) async {
//     print("getData: ${dio.options.baseUrl}$path");
//     return await dio.get(path);
//   }
//
//   Future<Response> postData(String path, dynamic data) async {
//     print("postData: ${dio.options.baseUrl}$path");
//     return await dio.post(path, data: data);
//   }
//
//   Future<Response> putData(String path, dynamic data) async {
//     print("putData: ${dio.options.baseUrl}$path");
//     return await dio.put(path, data: data);
//   }
//
//   Future<Response> deleteData(String path) async {
//     print("deleteData: ${dio.options.baseUrl}$path");
//     return await dio.delete(path);
//   }
// }

Future<Response> makeRequest(String path, String method, dynamic data) async {
  try {
    var dio = Dio();
    final box = GetStorage();

    var token = box.read('TOKEN');

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
    // The request was made and the server responded with a status code
    // that falls out of the range of 2xx and is also not 304.
    if (e.response != null) {
      return e.response;
    } else {
      // Something happened in setting up or sending the request that triggered an Error
      print(e.requestOptions);
      print(e.message);
      throw e.message;
    }
  }
}
