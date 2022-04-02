import 'package:flutter/material.dart';

import 'package:notary/controllers/session.dart';
import 'package:notary/controllers/user.dart';
import 'package:notary/views/process/recipient_status.dart';
import 'package:provider/provider.dart';

class ListRecipients extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Consumer2<SessionController, UserController>(
      builder: (context, _controller, _userController, _) {
        return ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: _controller.recipients.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(right: 24),
              child: _controller.recipients.length > 0
                  ? Provider.of<UserController>(context, listen: false).user != null && Provider.of<UserController>(context, listen: false).user.id !=
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
