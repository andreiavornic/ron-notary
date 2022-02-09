import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:notary/controllers/user.dart';
import 'package:notary/methods/resize_formatting.dart';
import 'package:notary/methods/show_error.dart';
import 'package:notary/widgets/button_primary.dart';
import 'package:notary/widgets/delete_account.dart';
import 'package:notary/widgets/edit_intput.widget.dart';
import 'package:notary/widgets/title_page.dart';

class Account extends StatefulWidget {
  @override
  _AccountState createState() => _AccountState();
}

class _AccountState extends State<Account> {
  UserController _userController = Get.put(UserController());
  String _firstName;
  String _lastName;
  String _phone;
  MaskTextInputFormatter _phoneFormatter = new MaskTextInputFormatter(
    mask: '+# (###) ###-####',
    filter: {
      "#": RegExp(r'[0-9]'),
    },
  );

  @override
  void initState() {
    _getData();
    super.initState();
  }

  _getData() {
    _firstName = _userController.user.value.firstName;
    _lastName = _userController.user.value.lastName;
    _phone = _userController.user.value.phone;
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<UserController>(
        init: UserController(),
        builder: (_controller) {
          return Scaffold(
            body: SingleChildScrollView(
              child: Container(
                height: Get.height,
                child: Column(
                  children: [
                    TitlePage(
                      title: "Account",
                      description: "Personal information",
                      needNav: true,
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          children: [
                            EditInput(
                              hintText: 'First Name',
                              labelText: 'First Name',
                              validator: 'First Name is required',
                              validate: (String value) {
                                if (value.trim().isEmpty) {
                                  return "First Name is required";
                                }
                                return null;
                              },
                              initialValue: _firstName,
                              onChanged: (value) {
                                _firstName = value;
                                setState(() {});
                              },
                            ),
                            EditInput(
                              hintText: 'Last Name',
                              labelText: 'Last Name',
                              validate: (String value) {
                                if (value.trim().isEmpty) {
                                  return "Last Name is required";
                                }
                                return null;
                              },
                              initialValue: _lastName,
                              onChanged: (value) {
                                _lastName = value;
                                setState(() {});
                              },
                            ),
                            EditInput(
                              hintText: 'Phone',
                              labelText: 'Phone',
                              validator: 'Please add your phone',
                              initialValue: _phone,
                              inputFormatters: [_phoneFormatter],
                              keyboardType: TextInputType.phone,
                              onChanged: (value) {
                                _phone = value;
                                setState(() {});
                              },
                            ),
                            EditInput(
                              hintText: 'Email',
                              labelText: 'Email',
                              validator: 'Email is required',
                              initialValue: _controller.user.value.email,
                              onChanged: (value) => null,
                              readOnly: true,
                              suffixIcon: Icon(
                                Icons.edit_off,
                                color: Color(0xFFADAEAF),
                              ),
                            ),
                            EditInput(
                              hintText: 'Password',
                              labelText: 'Password',
                              validator: 'Password is required',
                              obscureText: true,
                              initialValue: 'password',
                              onChanged: (value) => null,
                              readOnly: true,
                              suffixIcon: Icon(
                                Icons.edit_off,
                                color: Color(0xFFADAEAF),
                              ),
                            ),
                            DeleteAccount(),
                          ],
                        ),
                      ),
                    ),
                    ButtonPrimary(
                      text: "Save",
                      callback: !_checkData() ? null : _saveData,
                    ),
                    SizedBox(
                        height: Get.height < 670
                            ? 20
                            : reSize(40)),
                  ],
                ),
              ),
            ),
          );
        });
  }

  bool _checkData() {
    if (_firstName.isNotEmpty && _lastName.isNotEmpty && _phone.isNotEmpty) {
      return true;
    }
    return false;
  }

  _saveData() async {
    try {
      await _userController.updateData({
        "firstName": _firstName,
        "lastName": _lastName,
        "phone": _phone,
      });
      Get.back();
    } catch (err) {
      showError(err);
    }
  }
}
