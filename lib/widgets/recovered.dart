import 'package:flutter/material.dart';

import 'package:notary/controllers/user.dart';
import 'package:notary/methods/show_error.dart';
import 'package:notary/utils/navigate.dart';
import 'package:notary/views/auth.dart';
import 'package:notary/views/confirm_account.dart';
import 'package:notary/views/new_password.dart';
import 'package:notary/widgets/loading_page.dart';
import 'package:notary/widgets/title_page.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';

import '../methods/resize_formatting.dart';
import 'button_primary.dart';
import 'edit_input.widget.dart';

class RecoveredPage extends StatefulWidget {
  final bool isRegister;

  RecoveredPage({@required this.isRegister});

  @override
  _RecoveredPageState createState() => _RecoveredPageState();
}

class _RecoveredPageState extends State<RecoveredPage> {
  String _email;
  String _code;
  bool _isCodeSent;
  bool _loading;

  initState() {
    _isCodeSent = false;
    _loading = false;
    super.initState();
  }

  _sendCode() async {
    try {
      StateM(context).navTo(NewPassword(
        token: _code,
      ));
      // _pinPutController.text = null;
      // _code = null;
      // _email = null;
      _isCodeSent = false;
      setState(() {});
    } catch (err) {
      showError(err, context);
    }
  }

  TextEditingController _pinPutController = TextEditingController();
  final FocusNode _pinPutFocusNode = FocusNode();

  getClipboard(String value) {
    _code = value;
    _pinPutController.text = _code;
    setState(() {});
    FocusScopeNode currentFocus = FocusScope.of(context);

    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
  }

  _resetPassword() async {
    try {
      _loading = true;
      setState(() {});
      await Provider.of<UserController>(context, listen: false)
          .resetPassword(_email);
      _isCodeSent = true;
      _email = null;
      _loading = false;
      setState(() {});
    } catch (err) {
      _loading = false;
      setState(() {});
      showError(err, context);
    }
  }

  _activateAccount() async {
    try {
      _loading = true;
      setState(() {});
      await Provider.of<UserController>(context, listen: false)
          .getVerify(_code);
      StateM(context).navOff(ConfirmAccount());
      _loading = false;
      setState(() {});
    } catch (err) {
      _loading = false;
      setState(() {});
      showError(err, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return LoadingPage(
        _loading,
        SingleChildScrollView(
          child: Container(
            height: StateM(context).height(),
            child: Column(
              children: [
                TitlePage(
                  title: widget.isRegister
                      ? 'Activate Account'
                      : 'Recovery Password',
                  description: 'You will recieve email with instructions',
                  needNav: true,
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        _isCodeSent || widget.isRegister
                            ? Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      widget.isRegister
                                          ? 'Please enter 6-digit code to activate\nyour account'
                                          : 'Please enter 6-digit code to create\nnew password',
                                      style: TextStyle(
                                        color: Color(0xFF20303C),
                                        fontSize: 16,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    SizedBox(height: 30),
                                    Pinput(
                                      length: 6,
                                      cursor: Container(),
                                      separator: SizedBox(
                                        width: 15,
                                      ),
                                      defaultPinTheme: PinTheme(
                                          textStyle: TextStyle(
                                            fontSize: 32,
                                            color: Color(0xFFC4C4C4),
                                          ),
                                          height: reSize(context, 50),
                                          width: reSize(context, 40),
                                          decoration: BoxDecoration(
                                              color: Color(0xFFFFFFFF),
                                              border: Border(
                                                bottom: BorderSide(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .secondary,
                                                  width: 1.0,
                                                ),
                                              )
                                            // border: Border(
                                            //   bottom: BorderSide(
                                            //     color: Theme.of(context).colorScheme.secondary,
                                            //     width: 1.0,
                                            //   ),
                                            // ),
                                          )),
                                      // cursor: true,
                                      // eachFieldHeight: 46,
                                      // eachFieldWidth: 32,

                                      pinContentAlignment: Alignment.center,
                                      // eachFieldMargin:
                                      //     EdgeInsets.symmetric(horizontal: 4),
                                      onChanged: (String pin) {
                                        _code = pin;
                                        setState(() {});
                                      },
                                      onSubmitted: (String pin) {
                                        getClipboard(pin);
                                      },
                                      onClipboardFound: (String pin) {
                                        getClipboard(pin);
                                      },
                                      focusNode: _pinPutFocusNode,
                                      controller: _pinPutController,
                                      // submittedFieldDecoration:
                                      //     _pinPutDecoration.copyWith(
                                      //   color: Color(0xFFFFFFFF),
                                      //   border: Border(
                                      //     bottom: BorderSide(
                                      //       color: Theme.of(context)
                                      //           .colorScheme
                                      //           .secondary,
                                      //       width: 1.0,
                                      //     ),
                                      //   ),
                                      // ),
                                      // selectedFieldDecoration:
                                      //     _pinPutDecoration.copyWith(
                                      //   color: Color(0xFFFFFFF),
                                      //   border: Border(
                                      //     bottom: BorderSide(
                                      //       color: Theme.of(context)
                                      //           .colorScheme
                                      //           .secondary,
                                      //       width: 1.0,
                                      //     ),
                                      //   ),
                                      // ),
                                      // followingFieldDecoration:
                                      //     _pinPutDecoration.copyWith(
                                      //   color: Color(0xFFFFFFFF),
                                      //   border: Border(
                                      //     bottom: BorderSide(
                                      //       color: Theme.of(context)
                                      //           .colorScheme
                                      //           .secondary,
                                      //       width: 1.0,
                                      //     ),
                                      //   ),
                                      // ),
                                    ),
                                  ],
                                ),
                              )
                            : Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'We are sending 6-digit code to the\nfollowing email:',
                                      style: TextStyle(
                                        color:
                                            Color(0xFF000000).withOpacity(0.56),
                                        fontSize: 14,
                                      ),
                                    ),
                                    SizedBox(height: 35),
                                    EditInput(
                                        labelText: "Email",
                                        obscureText: false,
                                        noCapitalize: true,
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        onChanged: (String value) {
                                          _email = value;
                                          setState(() {});
                                        },
                                        validator:
                                            "Please enter a valid email"),
                                    SizedBox(height: 220),
                                  ],
                                ),
                              ),
                        _isCodeSent
                            ? ButtonPrimary(
                                text: 'Create Password',
                                callback: _code == null || _code.length != 6
                                    ? null
                                    : _sendCode,
                              )
                            : ButtonPrimary(
                                text: "Confirm",
                                callback: widget.isRegister
                                    ? _activateAccount
                                    : _email == null
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
                              onTap: () => StateM(context).navOff(Auth()),
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
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
