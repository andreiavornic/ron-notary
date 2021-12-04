import 'package:get/get.dart';
import 'package:notary/methods/show_error.dart';
import 'package:notary/models/user.dart';
import 'package:notary/services/socket.dart';
import 'package:notary/services/auth.dart';
import 'package:notary/services/user.dart';

import 'authentication.dart';

class UserController extends GetxController {
  final _isAuth = false.obs;
  final _user = Rx<User>();
  final _stamp = Rx<String>(null);
  UserService _userService = new UserService();
  SocketService _socketService = new SocketService();
  AuthenticationController _authController = new AuthenticationController();

  @override
  void onInit() {
    super.onInit();
    getUser();
    getStamp();
  }

  @override
  void onClose() {
    _socketService.socket.disconnect();
    super.onClose();
  }

  Rx<User> get user => _user;

  get isAuth => _isAuth;

  get stamp => _stamp;

  Future<void> getUser() async {
    try {
      Response response = await _userService.getUser();
      var extracted = response.body;

      if (!extracted['success']) {
        throw extracted['message'];
      }

      _user.value = new User.fromJson(extracted['data']);
    } catch (err) {
      if (err == 'JWT EXPIRED') {
        _authController.logOut();
        return;
      }
      showError(err);
    }
  }


  Future<void> getStamp() async {
    try {
      Response response = await _userService.getStamp();
      var extracted = response.body;
      print(extracted);
      if (!extracted['success']) {
        throw extracted['message'];
      }
      _stamp.value = extracted['data'];
      print(_stamp);
      update();
    } catch (err) {
      showError(err);
    }
  }
}
