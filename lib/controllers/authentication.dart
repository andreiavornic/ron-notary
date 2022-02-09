import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:notary/services/dio_service.dart';

import 'package:notary/views/auth.dart';
import 'package:dio/dio.dart' as dio;

class AuthenticationController extends GetxController with CacheManager {
  final isLogged = false.obs;

  void logOut() {
    isLogged.value = false;
    removeToken();
    update();
    Get.offAll(
      () => Auth(),
      transition: Transition.noTransition,
    );
  }

  Future<void> login(data) async {
    try {
      dio.Response resDio = await makeRequest('auth/login', 'POST', data);
      var extracted = resDio.data;
      print(extracted);

      if (!extracted['success']) {
        throw extracted["message"];
      }
      String token = extracted['data']['token'];

      if (data['remember']) {
        // todo: logout after expire
        print(extracted['data']['expiresIn']);
      }

      await saveToken(token);
      isLogged.value = true;
      update();
    } catch (err) {
      throw err;
    }
  }

  Future<void> loginGoogle(String idToken) async {
    try {
      dio.Response resDio =
          await makeRequest('auth/login-google', 'POST', {"token": idToken});
      var extracted = resDio.data;

      if (!extracted['success']) {
        throw extracted["message"];
      }
      String token = extracted['data']['token'];
      await saveToken(token);
      isLogged.value = true;
      update();
    } catch (err) {
      print(err);
      throw err;
    }
  }

  bool checkLoginStatus() {
    final token = getToken();
    if (token != null) {
      isLogged.value = true;
      update();
    }
    return isLogged.value;
  }

  register(
    String firstName,
    String lastName,
    String email,
    String phone,
    String password,
    String state,
    String longState,
  ) async {
    try {
      dio.Response resDio = await makeRequest('auth/register', 'POST', {
        "firstName": firstName,
        "lastName": lastName,
        "email": email,
        "phone": phone,
        "password": password,
        "state": state,
        "longState": longState,
      });
      var extracted = resDio.data;

      if (!extracted['success']) {
        throw extracted['message'];
      }
    } catch (err) {
      throw err;
    }
  }
}

mixin CacheManager {
  Future<bool> saveToken(String token) async {
    print("token $token");
    final box = GetStorage();
    await box.write('TOKEN', token);
    return true;
  }

  String getToken() {
    final box = GetStorage();
    return box.read("TOKEN");
  }

  Future<void> removeToken() async {
    final box = GetStorage();
    await box.remove("SOCKET_ROOM");
    await box.remove("TOKEN");
  }
}
