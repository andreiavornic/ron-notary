import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notary/controllers/user.dart';
import 'package:notary/methods/show_error.dart';
import 'package:notary/widgets/button_primary.dart';
import 'package:notary/widgets/confirm_password_reset.dart';
import 'package:notary/widgets/edit_intput.widget.dart';
import 'package:notary/widgets/loading_page.dart';
import 'package:notary/widgets/title_page.dart';

import 'auth.dart';

class NewPassword extends StatefulWidget {
  final String token;

  NewPassword({this.token});

  @override
  _NewPasswordState createState() => _NewPasswordState();
}

class _NewPasswordState extends State<NewPassword> {
  UserController _userController = Get.put(UserController());
  bool _isLoading;
  bool _hidePassword;
  bool _hideConfirmPassword;
  String _password;
  String _confirmPassword;

  @override
  void initState() {
    _isLoading = false;
    _hidePassword = true;
    _hideConfirmPassword = true;
    super.initState();
  }

  _resetPassword() async {
    _isLoading = true;
    setState(() {});
    try {
      await _userController.addNewPassword(_password, widget.token);
      Get.offAll(
        () => ConfirmPasswordReset(),
        transition: Transition.noTransition,
      );
      _isLoading = false;
      setState(() {});
    } catch (err) {
      _isLoading = false;
      setState(() {});
      showError(err);
    }
  }

  @override
  Widget build(BuildContext context) {
    return LoadingPage(
        _isLoading,
        SingleChildScrollView(
          child: Container(
            height: Get.height,
            child: Column(
              children: [
                TitlePage(
                  title: 'New Password',
                  description: 'Type new password',
                  needNav: true,
                ),
                SizedBox(height: 40),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              EditInput(
                                hintText: 'New password',
                                labelText: 'New password',
                                validator: "Password is required",
                                obscureText: _hidePassword,
                                noCapitalize: true,
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _hidePassword
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                    color: Theme.of(context).colorScheme.secondary,
                                    size: 16,
                                  ),
                                  onPressed: () {
                                    _hidePassword = !_hidePassword;
                                    setState(() {});
                                  },
                                ),
                                onChanged: (String value) {
                                  _password = value;
                                  setState(() {});
                                },
                              ),
                              EditInput(
                                hintText: 'Repeat new password',
                                labelText: 'Repeat new password',
                                obscureText: _hideConfirmPassword,
                                noCapitalize: true,
                                onChanged: (String value) {
                                  _confirmPassword = value;
                                  setState(() {});
                                },
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _hideConfirmPassword
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                    color: Theme.of(context).colorScheme.secondary,
                                    size: 16,
                                  ),
                                  onPressed: () {
                                    _hideConfirmPassword =
                                        !_hideConfirmPassword;
                                    setState(() {});
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          children: [
                            ButtonPrimary(
                              text: 'Confirm',
                              callback: _password == null ||
                                      _password.isEmpty ||
                                      _password != _confirmPassword
                                  ? null
                                  : _resetPassword,
                            ),
                            SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Already have an account? ',
                                  style: TextStyle(
                                    color: Color(0xFF999999),
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () => Get.offAll(
                                    () => Auth(),
                                    transition: Transition.noTransition,
                                  ),
                                  child: Text(
                                    'Login Now',
                                    style: TextStyle(
                                      color: Color(0xFF202215),
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 40),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
