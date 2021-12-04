import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:notary/controllers/authentication.dart';

class TypeNotarizationService extends GetConnect {
  var url = dotenv.env['URL'];
  Future<Response> getNotarization() {
    final box = GetStorage();
    var token = box.read(CacheManagerKey.TOKEN.toString());
    return get(
      '$url/type-notarization',
      headers: {
        "Authorization": "Bearer $token",
      },
    );
  }
}
