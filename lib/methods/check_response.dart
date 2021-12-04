import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:notary/views/errors/error_page.dart';

checkData(Response response) {
  var extracted = response.body;
  if (!extracted['success']) {
    if (Get.isBottomSheetOpen) {
      Get.bottomSheet(Container(
        height: 100,
        color: Color(0xFFFFFFFF),
      ));
    }
    Get.to(
      () => ErrorPage(
        errorMessage: extracted['message'],
        callback: () => Get.back(),
      ),
    );
    return null;
  } else {
    return extracted['data'];
  }
}
