import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:notary/controllers/authentication.dart';

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
}
