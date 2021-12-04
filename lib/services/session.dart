import 'dart:io';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:notary/controllers/authentication.dart';

class SessionService extends GetConnect {
  var url = dotenv.env['URL'];
  Future<Response> getSession() {
    final box = GetStorage();
    var token = box.read(CacheManagerKey.TOKEN.toString());
    return get(
      '$url/session',
      headers: {
        "Authorization": "Bearer $token",
      },
    );
  }

  Future<Response> createSession(File file) {
    final box = GetStorage();
    var token = box.read(CacheManagerKey.TOKEN.toString());

    final form = FormData({
      'file': MultipartFile(file, filename: 'file.pdf'),
    });

    return post(
      '$url/session',
      form,
      headers: {
        "Authorization": "Bearer $token",
      },
    );
  }

  Future<Response> updateSession(
      String typeNotarization, String documentTitle) {
    final box = GetStorage();
    var token = box.read(CacheManagerKey.TOKEN.toString());
    return put(
      '$url/session',
      {
        "typeNotarization": typeNotarization,
        "sessionFileName": documentTitle,
      },
      headers: {
        "Authorization": "Bearer $token",
      },
    );
  }

  Future<Response> deleteSession() {
    final box = GetStorage();
    var token = box.read(CacheManagerKey.TOKEN.toString());
    return delete(
      '$url/session',
      headers: {
        "Authorization": "Bearer $token",
      },
    );
  }

  Future<Response> changeStatus(String status) {
    final box = GetStorage();
    var token = box.read(CacheManagerKey.TOKEN.toString());
    return put(
      '$url/session/$status',
      {},
      headers: {
        "Authorization": "Bearer $token",
      },
    );
  }
}
