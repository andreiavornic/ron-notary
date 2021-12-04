import 'package:get/get.dart';

double reSize(int currentValue) {
  double ratio = Get.width / 150;
  if (ratio < 2.6) {
    return currentValue / 1.2;
  }
  return currentValue / 1;
}
