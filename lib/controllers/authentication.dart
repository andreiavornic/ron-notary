// import 'package:adapty_flutter/adapty_flutter.dart';
import 'package:flutter/material.dart';
import 'package:notary/services/dio_service.dart';
import 'package:dio/dio.dart' as dio;
import 'package:shared_preferences/shared_preferences.dart';

class AuthenticationController with ChangeNotifier {
  bool isLogged = false;

  Future<void> logOut() async {
    isLogged = false;
    // await Adapty.logout();
    removeToken();
    notifyListeners();
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

      await saveToken(token);
      isLogged = true;
      notifyListeners();
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
      isLogged = true;
      notifyListeners();
    } catch (err) {
      throw err;
    }
  }

  Future<void> getVerify(String verifyToken) async {
    try {
      dio.Response resDio = await makeRequest(
        'auth/activate',
        "POST",
        {"verifyToken": verifyToken},
      );
      var extracted = resDio.data;

      if (!extracted['success']) {
        throw extracted['message'];
      }
      String token = extracted['data']['token'];
      await saveToken(token);
      isLogged = true;
      notifyListeners();
    } catch (err) {
      throw err;
    }
  }

  Future<bool> checkLoginStatus() async {
    final token = await getToken();
    if (token != null) {
      isLogged = true;
    }
    return isLogged;
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
      print(extracted);

      if (!extracted['success']) {
        throw extracted['message'];
      }
    } catch (err) {
      print(err);
      throw err;
    }
  }

  Future<bool> saveToken(String token) async {
    final pref = await SharedPreferences.getInstance();
    await pref.setString('TOKEN', token);
    return true;
  }

  Future<String> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("TOKEN");
  }

  Future<void> removeToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("SOCKET_ROOM");
    await prefs.remove("TOKEN");
  }
}
