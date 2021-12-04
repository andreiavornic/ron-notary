import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:notary/controllers/authentication.dart';

class RecipientService extends GetConnect {
  var url = dotenv.env['URL'];
  Future<Response> createRecipient(Map<String, dynamic> recipient) {
    final box = GetStorage();
    var token = box.read(CacheManagerKey.TOKEN.toString());
    return post(
      '$url/recipient',
      recipient,
      headers: {
        "Authorization": "Bearer $token",
      },
    );
  }

  Future<Response> getRecipients() {
    final box = GetStorage();
    var token = box.read(CacheManagerKey.TOKEN.toString());
    return get(
      '$url/recipient',
      headers: {
        "Authorization": "Bearer $token",
      },
    );
  }

  Future<Response> updateRecipient(Map<String, dynamic> recipient, String id) {
    final box = GetStorage();
    var token = box.read(CacheManagerKey.TOKEN.toString());
    return put(
      '$url/recipient/$id',
      recipient,
      headers: {
        "Authorization": "Bearer $token",
      },
    );
  }

  Future<Response> deleteRecipient(String id) {
    final box = GetStorage();
    var token = box.read(CacheManagerKey.TOKEN.toString());
    return delete(
      '$url/recipient/$id',
      headers: {
        "Authorization": "Bearer $token",
      },
    );
  }
}
