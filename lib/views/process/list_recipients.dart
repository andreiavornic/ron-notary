import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notary/controllers/session.dart';
import 'package:notary/controllers/user.dart';
import 'package:notary/views/process/recipient_status.dart';

class ListRecipients extends StatelessWidget {
  final UserController _userController = Get.put(UserController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SessionController>(
      builder: (_controller) {
        return ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: _controller.recipients.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(right: 24),
              child: _controller.recipients.length > 0
                  ? _userController.user.value != null && _userController.user.value.id !=
                          _controller.recipients[index].id
                      ? RecipientStatus(_controller.recipients[index])
                      : Container()
                  : Container(),
            );
          },
        );
      },
    );
  }
}
