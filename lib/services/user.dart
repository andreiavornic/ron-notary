import 'dart:io';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:notary/controllers/authentication.dart';
import 'package:path/path.dart';

class UserService extends GetConnect {
  var url = dotenv.env['URL'];

  Future<Response> getUser() {
    final box = GetStorage();
    var token = box.read(CacheManagerKey.TOKEN.toString());
    return get(
      '$url/user',
      headers: {
        "Authorization": "Bearer $token",
      },
    );
  }

  Future<Response> updateData(Map<String, dynamic> data) {
    final box = GetStorage();
    var token = box.read(CacheManagerKey.TOKEN.toString());
    return put(
      '$url/user',
      data,
      headers: {
        "Authorization": "Bearer $token",
      },
    );
  }

  Future<Response> getStamp() {
    final box = GetStorage();
    var token = box.read(CacheManagerKey.TOKEN.toString());
    return get(
      '$url/stamp',
      headers: {
        "Authorization": "Bearer $token",
      },
    );
  }

  Future<Response> getFonts() {
    final box = GetStorage();
    var token = box.read(CacheManagerKey.TOKEN.toString());
    return get(
      '$url/font',
      headers: {
        "Authorization": "Bearer $token",
      },
    );
  }

  Future<Response> addCertificate(
    File certificate,
    String password,
    bool savePassword,
  ) {
    final box = GetStorage();
    var token = box.read(CacheManagerKey.TOKEN.toString());

    String filename = basename(certificate.path);
    final form = FormData({
      'certificate': MultipartFile(certificate, filename: filename),
      'password': password,
      'savePassword': savePassword,
    });

    return post(
      '$url/certificate',
      form,
      headers: {
        "Authorization": "Bearer $token",
      },
    );
  }

  Future<Response> deleteCertificate() {
    final box = GetStorage();
    var token = box.read(CacheManagerKey.TOKEN.toString());
    return delete(
      '$url/certificate',
      headers: {
        "Authorization": "Bearer $token",
      },
    );
  }
}
