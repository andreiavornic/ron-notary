import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class PdfController {
  Future<void> generatePdf(List<File> files) async {
    var dio = Dio();
    try {
      final prefs = await SharedPreferences.getInstance();
      var url = dotenv.env['URL'];
      var token = prefs.getString("TOKEN");
      dio.options = BaseOptions(
        baseUrl: dotenv.env['URL'],
        headers: {
          HttpHeaders.authorizationHeader: "Bearer $token",
          HttpHeaders.contentTypeHeader: 'application/json',
          "Platform": Platform.operatingSystem
        },
      );
      var formData = FormData();
      files.forEach((file) async {
        String name = Uuid().v4();
        MapEntry multipartFileSign = new MapEntry(
          'images',
          MultipartFile.fromFileSync(file.path, filename: "$name.png"),
        );
        formData.files.add(multipartFileSign);
      });
      await dio.post('$url/session/generate', data: formData);
    } on DioError catch (err) {
      throw err.message;
    } catch (err) {
      throw err;
    }
  }
}
