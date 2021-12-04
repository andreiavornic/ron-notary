import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';

class AuthService extends GetConnect {
  var url = dotenv.env['URL'];
  Future<Response> login(Map data) =>
      post('$url/auth/login', data);
}
