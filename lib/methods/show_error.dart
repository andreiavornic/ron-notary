import 'package:get/get.dart';
import 'package:notary/controllers/authentication.dart';
import 'package:notary/views/auth.dart';
import 'package:notary/views/errors/error_page.dart';
import 'package:notary/views/start.dart';

showError(err) {
  print(err);
  if (err == 'JWT EXPIRED' || err == 'TOKEN NULL') {
    AuthenticationController _authController =
        Get.put(AuthenticationController());
    _authController.logOut();
    Get.to(
      () => ErrorPage(
        errorMessage: "Your session was expired!",
        callback: () => Get.off(
          () => Auth(),
          transition: Transition.noTransition,
        ),
      ),
    );
    return;
  } else if (err == 'Session not found') {
    Get.to(
      () => ErrorPage(
        errorMessage: "This session was closed, please check eJournal",
        callback: () => Get.off(
          () => Start(),
          transition: Transition.noTransition,
        ),
      ),
    );
    return;
  }
  Get.to(
    () => ErrorPage(
      errorMessage: err.toString(),
      callback: () => Get.back(),
    ),
  );
}
