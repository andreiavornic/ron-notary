import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:notary/controllers/user.dart';
import 'package:notary/methods/resize_formatting.dart';
import 'package:notary/methods/show_error.dart';
import 'package:notary/widgets/button_primary.dart';
import 'package:notary/widgets/button_primary_outline.dart';
import 'package:notary/widgets/edit_intput.widget.dart';
import 'package:notary/widgets/title_page.dart';

class DigitalCertificate extends StatefulWidget {
  @override
  _DigitalCertificateState createState() => _DigitalCertificateState();
}

class _DigitalCertificateState extends State<DigitalCertificate> {
  bool _hidePassword;
  bool _savePassword;
  String _password;

  @override
  void initState() {
    _hidePassword = true;
    _savePassword = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<UserController>(
        init: UserController(),
        builder: (_controller) {
          return Scaffold(
            body: Container(
              height: Get.height,
              child: Column(
                children: [
                  TitlePage(
                    title: 'Digital Certificate',
                    description: 'Manage your certificate',
                    needNav: true,
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          children: [
                            SizedBox(height: reSize(50)),
                            Container(
                              child: Center(
                                child: SvgPicture.asset(
                                  'assets/images/99.svg',
                                  width: reSize(32),
                                  height: reSize(32),
                                ),
                              ),
                              width: reSize(90),
                              height: reSize(118),
                              decoration: BoxDecoration(
                                color: Color(0xFFF5F6F9),
                                border: Border.all(
                                  color: Color(0xFF000000).withOpacity(0.07),
                                ),
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                            SizedBox(height: reSize(15)),
                            Text(
                              "${_controller.certificate}",
                              style: TextStyle(
                                color: Color(0xFF000000),
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(height: reSize(30)),
                            Text(
                              "Uploaded",
                              style: TextStyle(
                                color: Color(0xFF161617),
                                fontSize: 28,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            SizedBox(height: reSize(20)),
                            Text(
                              "Certificate will be used to sign the final document. Set password to make it secure",
                              style: TextStyle(
                                color: Color(0xFF494949),
                                fontSize: 14,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: reSize(50)),
                            _controller.passwordCertificate.value
                                ? Container(
                                    child: Column(
                                      children: [
                                        Container(
                                          width: reSize(80),
                                          height: reSize(80),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(50),
                                            color:
                                                Theme.of(context).accentColor,
                                          ),
                                          child: Center(
                                            child: SvgPicture.asset(
                                              'assets/images/109.svg',
                                              color: Theme.of(context)
                                                  .primaryColor,
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: reSize(15)),
                                        Text(
                                          'Password saved',
                                          style: TextStyle(
                                            color: Color(0xFF161617),
                                            fontSize: 16,
                                          ),
                                        ),
                                        SizedBox(height: reSize(15)),
                                        ButtonPrimaryOutline(
                                          callback: () => null,
                                          text: 'Remove Password',
                                          width: reSize(230),
                                        )
                                      ],
                                    ),
                                  )
                                : Column(
                                    children: [
                                      EditInput(
                                        hintText: 'Certificate Password',
                                        labelText: 'Certificate Password',
                                        obscureText: _hidePassword,
                                        onChanged: (String value) {
                                          _password = value;
                                          setState(() {});
                                        },
                                        suffixIcon: IconButton(
                                          icon: Icon(
                                            _hidePassword
                                                ? Icons.visibility_off
                                                : Icons.visibility,
                                            color:
                                                Theme.of(context).accentColor,
                                            size: reSize(16),
                                          ),
                                          onPressed: () {
                                            _hidePassword = !_hidePassword;
                                            setState(() {});
                                          },
                                        ),
                                      ),
                                      SizedBox(height: reSize(35)),
                                      GestureDetector(
                                        onTap: _passwordState,
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              width: reSize(20),
                                              height: reSize(20),
                                              decoration: BoxDecoration(
                                                color: _savePassword
                                                    ? Theme.of(context)
                                                        .primaryColor
                                                    : Color(0xFFFFFFFF),
                                                border: Border.all(
                                                  color: _savePassword
                                                      ? Theme.of(context)
                                                          .primaryColor
                                                      : Color(0xFFCDCDCD),
                                                  width: 1,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(3),
                                              ),
                                              child: _savePassword
                                                  ? Center(
                                                      child: Icon(
                                                        Icons.check,
                                                        size: reSize(14),
                                                      ),
                                                    )
                                                  : SizedBox(),
                                            ),
                                            SizedBox(width: reSize(10)),
                                            Text(
                                              "I authorize Ronary to store my Password\nCertificate",
                                              style: TextStyle(
                                                color: Theme.of(context)
                                                    .accentColor,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                            Column(
                              children: [
                                SizedBox(height: reSize(20)),
                                InkWell(
                                  onTap: () => null,
                                  child: Text(
                                    "Remove Certificate",
                                    style: TextStyle(
                                      color: Color(0xFFFF5454),
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                                SizedBox(height: reSize(20)),
                                _controller.passwordCertificate.value
                                    ? Container()
                                    : ButtonPrimary(
                                        text: "Save",
                                        callback: !_controller
                                                        .passwordCertificate
                                                        .value &&
                                                    _password == null ||
                                                _password.trim().isEmpty ||
                                                !_savePassword
                                            ? null
                                            : _addPassword,
                                      ),
                                SizedBox(
                                  height: Get.height < 670 ? 20 : reSize(40),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  _passwordState() async {
    _savePassword = !_savePassword;
    setState(() {});
  }

  _addPassword() async {
    try {} catch (err) {
      showError(err);
    }
  }
}
