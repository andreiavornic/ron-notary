import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:notary/controllers/authentication.dart';

class NotaryService extends GetConnect {
  var url = dotenv.env['URL'];

  Future<Response> addNotary(Map<String, dynamic> data) {
    final box = GetStorage();
    var token = box.read(CacheManagerKey.TOKEN.toString());
    return post(
      '$url/notary',
      data,
      headers: {
        "Authorization": "Bearer $token",
      },
    );
  }
}
