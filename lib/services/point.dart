import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:notary/controllers/authentication.dart';
import 'package:notary/models/point.dart';

class PointService extends GetConnect {
  var url = dotenv.env['URL'];

  Future<Response> getPoints() {
    final box = GetStorage();
    var token = box.read(CacheManagerKey.TOKEN.toString());
    return get(
      '$url/point',
      headers: {
        "Authorization": "Bearer $token",
      },
    );
  }

  Future<Response> addPoints(List<Point> points) {
    final box = GetStorage();
    var token = box.read(CacheManagerKey.TOKEN.toString());

    List<Map<String, dynamic>> data = [];
    points.forEach((element) {
      data.add(element.toJson());
    });
    return post(
      '$url/point',
      data,
      headers: {
        "Authorization": "Bearer $token",
      },
    );
  }

  Future<Response> updatePoints(String type) {
    final box = GetStorage();
    var token = box.read(CacheManagerKey.TOKEN.toString());

    return put(
      '$url/point',
      {"type": type},
      headers: {
        "Authorization": "Bearer $token",
      },
    );
  }
}
