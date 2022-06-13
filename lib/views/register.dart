import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:notary/controllers/authentication.dart';
import 'package:notary/methods/show_error.dart';
import 'package:notary/utils/navigate.dart';
import 'package:notary/views/policy.dart';
import 'package:notary/views/settings/state_select.dart';
import 'package:notary/widgets/button_primary.dart';
import 'package:notary/widgets/edit_input.widget.dart';
import 'package:notary/widgets/loading_page.dart';
import 'package:notary/widgets/modals/modal_container.dart';
import 'package:notary/widgets/terms_view.dart';
import 'package:notary/widgets/title_page.dart';
import 'package:provider/provider.dart';

import 'confirm_registration.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  String _firstName;
  String _lastName;
  String _email;
  String _phone;
  String _state;
  String _longState;
  String _password;
  String _confirmPassword;
  bool _loading;
  bool _hidePassword;
  bool _hideConfirmPassword;
  MaskTextInputFormatter _phoneFormatter = new MaskTextInputFormatter(
    mask: '+1 (###) ###-####',
    filter: {
      "#": RegExp(r'[0-9]'),
    },
    initialText: '+1',
  );

  @override
  void initState() {
    _loading = false;
    _hidePassword = true;
    _hideConfirmPassword = true;
    _state = 'FL';
    _longState = 'Florida';
    super.initState();
  }

  bool _getValidData() {
    if (_firstName == null ||
        _firstName.trim().isEmpty ||
        _lastName == null ||
        _lastName.trim().isEmpty ||
        _email == null ||
        _email.trim().isEmpty ||
        _phone == null ||
        _phone.trim().isEmpty ||
        _password == null ||
        _password.trim().isEmpty) {
      return false;
    } else if (_password != _confirmPassword) {
      return false;
    }
    return true;
  }

  Future<void> _createAccount() async {
    FocusScopeNode currentFocus = FocusScope.of(context);

    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
    if (!_formKey.currentState.validate()) {
      return;
    }
    _loading = true;
    setState(() {});
    try {
      await Provider.of<AuthenticationController>(context, listen: false)
          .register(
        _firstName,
        _lastName,
        _email,
        _phone,
        _password,
        _state,
        _longState,
      );
      StateM(context).navTo(ConfirmRegistration());
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
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      TitlePage(
                        needNav: true,
                        title: "Create Account",
                        description: "Please register to start using Ronary",
                      ),
                      SizedBox(height: 10),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              EditInput(
                                labelText: "First Name",
                                obscureText: false,
                                onChanged: (String value) {
                                  _firstName = value;
                                  setState(() {});
                                },
                                validate: (String value) {
                                  if (value.isEmpty) {
                                    return "First Name is required!";
                                  }
                                  return null;
                                },
                              ),
                              EditInput(
                                labelText: "Last Name",
                                obscureText: false,
                                onChanged: (String value) {
                                  _lastName = value;
                                  setState(() {});
                                },
                                validate: (String value) {
                                  if (value.isEmpty) {
                                    return "Last Name is required!";
                                  }
                                  return null;
                                },
                              ),
                              EditInput(
                                labelText: "Email",
                                obscureText: false,
                                keyboardType: TextInputType.emailAddress,
                                noCapitalize: true,
                                onChanged: (String value) {
                                  _email = value;
                                  setState(() {});
                                },
                                validate: (String value) {
                                  if (value.isEmpty) {
                                    return "Email is required!";
                                  } else if (!value.contains("@")) {
                                    return "Please add a valid email";
                                  }
                                  return null;
                                },
                              ),
                              Container(
                                width: StateM(context).width() - 40,
                                child: InkWell(
                                  onTap: () {
                                    FocusScopeNode currentFocus =
                                        FocusScope.of(context);

                                    if (!currentFocus.hasPrimaryFocus) {
                                      currentFocus.unfocus();
                                    }
                                    modalContainerSimple(
                                        StateSelect(
                                          changeState:
                                              (abbrevCity, selectedCity) {
                                            _state = abbrevCity;
                                            _longState = selectedCity;
                                            setState(() {});
                                            Navigator.pop(context);
                                          },
                                          isSetting: false,
                                        ),
                                        context);
                                  },
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Notary Commission State',
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                          color: Color(0xFF20303C),
                                          fontSize: 10,
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                      Text(
                                        _state,
                                        style: TextStyle(
                                          color: Color(0xFF20303C),
                                          fontSize: 14,
                                        ),
                                        textAlign: TextAlign.start,
                                      ),
                                      SizedBox(height: 4),
                                      Container(
                                        color: Color(0xFFEDEDED),
                                        width: StateM(context).width() - 40,
                                        height: 1,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              EditInput(
                                labelText: "Phone",
                                inputFormatters: [_phoneFormatter],
                                initialValue: '+1',
                                prefix: Container(
                                  width: 40,
                                  child: Row(
                                    children: [
                                      Container(
                                        child: SvgPicture.asset(
                                            "assets/images/97.svg"),
                                      ),
                                      SizedBox(width: 10),
                                      Container(
                                        width: 1,
                                        height: 10,
                                        color: Color(0xFFEDEDED),
                                      ),
                                      SizedBox(width: 10),
                                    ],
                                  ),
                                ),
                                keyboardType: TextInputType.phone,
                                hintText: "+1 (234) 567-8901",
                                validate: (String value) {
                                  if (value.isEmpty) {
                                    return "Phone is required!";
                                  }
                                  return null;
                                },
                                onChanged: (String value) async {
                                  _phone = value;
                                  setState(() {});
                                },
                              ),
                              EditInput(
                                labelText: "Password",
                                obscureText: _hidePassword,
                                noCapitalize: true,
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _hidePassword
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                    size: 16,
                                  ),
                                  onPressed: () {
                                    _hidePassword = !_hidePassword;
                                    setState(() {});
                                  },
                                ),
                                hintText: "Enter your password",
                                validate: (String value) {
                                  if (value.trim().isEmpty) {
                                    return "Password is required!";
                                  }
                                  if (value.trim().length < 4) {
                                    return "Password must be longer than 3 characters";
                                  }
                                  return null;
                                },
                                onChanged: (String value) {
                                  _password = value;
                                  setState(() {});
                                },
                              ),
                              EditInput(
                                labelText: "Repeat Password",
                                hintText: "Enter your password",
                                noCapitalize: true,
                                obscureText: _hideConfirmPassword,
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _hideConfirmPassword
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                    size: 16,
                                  ),
                                  onPressed: () {
                                    _hideConfirmPassword =
                                        !_hideConfirmPassword;
                                    setState(() {});
                                  },
                                ),
                                validate: (String value) {
                                  if (value.trim().isEmpty) {
                                    return "Confirm password is required!";
                                  } else if (value != _password) {
                                    return "Password is not match!";
                                  }
                                  return null;
                                },
                                onChanged: (String value) {
                                  _confirmPassword = value;
                                  setState(() {});
                                },
                              ),
                              SizedBox(height: 30),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ButtonPrimary(
                        callback: !_getValidData() ? null : _createAccount,
                        text: "Create Account",
                      ),
                      SizedBox(height: 20),
                      RichText(
                        textAlign: TextAlign.start,
                        text: TextSpan(
                          style: TextStyle(
                            color: Color(0xFF999999),
                            fontSize: 12,
                          ),
                          children: [
                            TextSpan(
                              text:
                                  'By selecting create account, you agree to the\n',
                            ),
                            TextSpan(
                              text: 'Terms and Conditions',
                              style: TextStyle(
                                  color: Color(0xFF20303C),
                                  decoration: TextDecoration.underline),
                              recognizer: TapGestureRecognizer()
                                ..onTap =
                                    () => StateM(context).navTo(TermsView()),
                            ),
                            TextSpan(
                              text: ' and ',
                            ),
                            TextSpan(
                              text: 'Privacy Policy',
                              style: TextStyle(
                                  color: Color(0xFF20303C),
                                  decoration: TextDecoration.underline),
                              recognizer: TapGestureRecognizer()
                                ..onTap =
                                    () => StateM(context).navTo(PolicyView()),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 25),
                    ],
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
