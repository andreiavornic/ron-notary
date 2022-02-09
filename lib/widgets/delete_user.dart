import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:notary/controllers/authentication.dart';
import 'package:notary/controllers/user.dart';
import 'package:notary/methods/resize_formatting.dart';
import 'package:notary/methods/show_error.dart';

import 'button_primary_outline.dart';

class DeleteUser extends StatefulWidget {
  @override
  _DeleteUserState createState() => _DeleteUserState();
}

class _DeleteUserState extends State<DeleteUser> {
  UserController _userController = Get.put(UserController());
  AuthenticationController _authController =
      Get.put(AuthenticationController());

  initState() {
    super.initState();
  }

  _deleteUser() async {
    try {
      await _userController.deleteAccount();
      _authController.logOut();
    } catch (err) {
      showError(err);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: Get.height / 4 * 3,
        width: Get.width,
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: reSize(80),
                    height: reSize(80),
                    decoration: BoxDecoration(
                        color: Color(0xFFFC563D),
                        borderRadius: BorderRadius.circular(80)),
                    child: Center(
                      child: SvgPicture.asset(
                        'assets/images/26.svg',
                        width: reSize(50),
                        color: Color(0xFFFFFFFF),
                      ),
                    ),
                  ),
                  SizedBox(height: reSize(20)),
                  Text(
                    'Are you sure?',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: reSize(20)),
                  Text(
                    "When you delete your account, your profile, documents, eJournal Log and video-audio recordings will be permanently removed.",
                    style: TextStyle(
                      color: Color(0xFF494949),
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: reSize(20)),
                  Text(
                    "You will be able to download your account content within 10 days after requesting deletion.",
                    style: TextStyle(
                      color: Color(0xFF494949),
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 50),
                  ButtonPrimaryOutline(
                    width: reSize(230),
                    text: 'Delete',
                    callback: _deleteUser,
                    color: Colors.red,
                  )
                ],
              ),
            ),
          ],
        ));
  }
}
