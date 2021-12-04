import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:notary/views/auth.dart';
import 'package:notary/views/errors/error_page.dart';
import 'package:notary/views/home.dart';
import 'package:notary/services/auth.dart';

class AuthenticationController extends GetxController with CacheManager {
  AuthService _authService = new AuthService();
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
      Response response = await _authService.login(data);
      var extracted = response.body;
      if (!extracted['success']) {
        Get.to(
          () => ErrorPage(
            errorMessage: extracted['message'],
            callback: () => Get.back(),
          ),
        );
        return;
      }
      String token = extracted['data']['token'];

      if (data['remember']) {
        // todo: logout after expire
        print(extracted['data']['expiresIn']);
      }
      // String token = extracted['data']['token'];
      await saveToken(token);
      isLogged.value = true;
      update();

      Get.offAll(
        () => HomePage(),
        transition: Transition.noTransition,
      );
    } catch (err) {
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
}

mixin CacheManager {
  Future<bool> saveToken(String token) async {
    final box = GetStorage();
    await box.write(CacheManagerKey.TOKEN.toString(), token);
    return true;
  }

  String getToken() {
    final box = GetStorage();
    return box.read(CacheManagerKey.TOKEN.toString());
  }

  Future<void> removeToken() async {
    final box = GetStorage();
    await box.remove(CacheManagerKey.TOKEN.toString());
  }
}

enum CacheManagerKey { TOKEN }
