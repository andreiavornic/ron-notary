import 'dart:io';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:notary/controllers/authentication.dart';

class JournalService extends GetConnect {
  var url = dotenv.env['URL'];
  Future<Response> getJournals() {
    final box = GetStorage();
    var token = box.read(CacheManagerKey.TOKEN.toString());
    return get(
      '$url/journal',
      headers: {
        "Authorization": "Bearer $token",
      },
    );
  }

  Future<Response> getJournalById(String id) {
    final box = GetStorage();
    var token = box.read(CacheManagerKey.TOKEN.toString());
    return get(
      '$url/journal/$id',
      headers: {
        "Authorization": "Bearer $token",
      },
    );
  }

}
