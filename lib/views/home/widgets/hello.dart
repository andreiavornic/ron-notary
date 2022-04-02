import 'package:flutter/material.dart';
import 'package:notary/controllers/user.dart';
import 'package:notary/methods/resize_formatting.dart';
import 'package:provider/provider.dart';

class Hello extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<UserController>(builder: (context, _controller, _) {
      return Column(
        children: [
          SizedBox(height: reSize(context, 80)),
          SizedBox(
            height: reSize(context, 19),
            child: Text(
              "Welcome,",
              style: TextStyle(
                color: Theme.of(context).colorScheme.secondary,
                fontSize: 16,
              ),
            ),
          ),
          SizedBox(height: reSize(context, 5)),
          if (_controller.user != null)
            Text(
              "${_controller.user.firstName} ${_controller.user.lastName}",
              style: TextStyle(
                color: Color(0xFF000000),
                fontSize: 24,
                fontWeight: FontWeight.w700,
              ),
            ),

          SizedBox(
            height: reSize(context, 30),
          ),
        ],
      );
    });
  }
}
