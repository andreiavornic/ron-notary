import 'package:flutter/material.dart';
import 'package:get/get.dart';

modalContainer(Widget widget) {
  return Get.bottomSheet(
      Wrap(
        children: [
          Container(
            width: Get.width,
            child: Column(
              children: [
                Column(
                  children: [
                    SizedBox(height: 10),
                    Container(
                      width: 50,
                      height: 4,
                      decoration: BoxDecoration(
                          color: Color(0xFFE0E0E0),
                          borderRadius: BorderRadius.circular(4)),
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ],
            ),
          ),
          widget
        ],
      ),
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25.0),
          topRight: Radius.circular(25.0),
        ),
      ),
      backgroundColor: Color(0xFFFFFFFF));
}
