import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio;
import 'package:notary/views/errors/error_page.dart';

checkData(dio.Response response) {
  var extracted = response.data;
      if(extracted == null) {
        return;
      }
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
