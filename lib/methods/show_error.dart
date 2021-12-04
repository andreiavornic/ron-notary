import 'package:get/get.dart';
import 'package:notary/views/errors/error_page.dart';

showError(err) {
  Get.to(
    () => ErrorPage(
      errorMessage: err.toString(),
      callback: () => Get.back(),
    ),
  );
}
