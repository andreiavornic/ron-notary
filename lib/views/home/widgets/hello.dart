import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notary/controllers/user.dart';
import 'package:notary/methods/resize_formatting.dart';

class Hello extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<UserController>(builder: (_controller) {
      return Column(
        children: [
          SizedBox(height: reSize(80)),
          SizedBox(
            height: reSize(19),
            child: Text(
              "Welcome,",
              style: TextStyle(
                color: Theme.of(context).colorScheme.secondary,
                fontSize: 16,
              ),
            ),
          ),
          SizedBox(height: reSize(5)),
          if (_controller.user.value != null)
            Text(
              "${_controller.user.value.firstName} ${_controller.user.value.lastName}",
              style: TextStyle(
                color: Color(0xFF000000),
                fontSize: 24,
                fontWeight: FontWeight.w700,
              ),
            ),
          SizedBox(
            height: reSize(30),
          ),
        ],
      );
    });
  }
}
