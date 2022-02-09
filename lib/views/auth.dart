import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:notary/controllers/authentication.dart';
import 'package:notary/methods/resize_formatting.dart';
import 'package:notary/methods/show_error.dart';
import 'package:notary/views/register.dart';
import 'package:notary/views/start.dart';
import 'package:notary/widgets/button_primary.dart';
import 'package:notary/widgets/edit_intput.widget.dart';
import 'package:notary/widgets/loading_page.dart';
import 'package:notary/widgets/recovered.dart';

class Auth extends StatefulWidget {
  @override
  _AuthState createState() => _AuthState();
}

class _AuthState extends State<Auth> {
  final AuthenticationController _authController =
      Get.put(AuthenticationController());
  final GlobalKey<FormState> _formKey = GlobalKey();
  String _email;
  String _password;
  bool _hidePassword;
  bool _isLoading;
  bool _remember;

  GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
      "https://www.googleapis.com/auth/userinfo.profile"
    ],
  );

  @override
  void initState() {
    _hidePassword = true;
    _isLoading = false;
    _remember = false;
    super.initState();
  }

  Future<void> _loginGoogle() async {
    try {
      _isLoading = true;
      setState(() {});
      _googleSignIn.signOut();
      GoogleSignInAccount result = await _googleSignIn.signIn();
      if (result != null) {
        GoogleSignInAuthentication googleKey = await result.authentication;
        await _authController.loginGoogle(googleKey.accessToken);
      } else
        throw "Invalid data for continue";
      _isLoading = false;
      setState(() {});
      Get.offAll(
        () => Start(),
        transition: Transition.noTransition,
      );
    } catch (err) {
      _isLoading = false;
      setState(() {});
      showError(err);
    }
  }

  Future<void> _loginWithData() async {
    FocusScopeNode currentFocus = FocusScope.of(context);

    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
    if (!_formKey.currentState.validate()) {
      return;
    }
    _isLoading = true;
    setState(() {});
    try {
      await _authController.login({
        "email": _email,
        "password": _password,
        "remember": _remember,
      });
      Get.offAll(
        () => Start(),
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

  _setRemember() {
    _remember = !_remember;
    setState(() {});
  }

  bool _getValidData() {
    if (_email == null || _email.trim().isEmpty || !_email.contains("@")) {
      return true;
    } else if (_password == null || _password.isEmpty) {
      return true;
    } else {
      return false;
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
                SizedBox(height: 40),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          SvgPicture.asset(
                            'assets/images/45.svg',
                            width: reSize(100),
                          ),
                        ],
                      ),
                      SizedBox(height: 50),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              EditInput(
                                labelText: "Email",
                                hintText: "Enter your email",
                                obscureText: false,
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
                              EditInput(
                                labelText: "Password",
                                hintText: "Enter your password",
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
                                validate: (String value) {
                                  if (value.isEmpty) {
                                    return "Password is required!";
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(height: 30),
                              GestureDetector(
                                onTap: _setRemember,
                                child: Row(
                                  children: [
                                    Container(
                                      width: 20,
                                      height: 20,
                                      decoration: BoxDecoration(
                                        color: _remember
                                            ? Theme.of(context).primaryColor
                                            : Color(0xFFFFFFFF),
                                        border: Border.all(
                                          color: _remember
                                              ? Theme.of(context).primaryColor
                                              : Color(0xFFCDCDCD),
                                          width: 1,
                                        ),
                                        borderRadius: BorderRadius.circular(3),
                                      ),
                                      child: _remember
                                          ? Center(
                                              child: Icon(
                                                Icons.check,
                                                size: 14,
                                              ),
                                            )
                                          : SizedBox(),
                                    ),
                                    SizedBox(width: 10),
                                    Text(
                                      "Remember Me",
                                      style: TextStyle(
                                        color: Color(0xFF646464),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 60),
                              ButtonPrimary(
                                callback:
                                    _getValidData() ? null : _loginWithData,
                                text: "Login",
                                width: Get.width,
                              ),
                              SizedBox(height: reSize(10)),
                              Container(
                                height: reSize(51),
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Color(0xFFFFFFFF),
                                  borderRadius: BorderRadius.circular(4),
                                  border: Border.all(
                                    color: Color(0xFFCCCCCC),
                                    width: 1,
                                  ),
                                ),
                                child: TextButton(
                                  onPressed: _loginGoogle,
                                  style: ButtonStyle(
                                    padding: MaterialStateProperty.all(
                                      EdgeInsets.zero,
                                    ),
                                  ),
                                  child: Container(
                                    height: 24,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Image.asset(
                                          'assets/images/2.png',
                                          width: reSize(24),
                                        ),
                                        SizedBox(
                                          width: reSize(10),
                                        ),
                                        Text(
                                          'Continue with Google',
                                          style: TextStyle(
                                            color: Color(0xFF414141),
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: reSize(25)),
                              GestureDetector(
                                onTap: () => Get.to(
                                  () => RecoveredPage(
                                    isRegister: false,
                                  ),
                                  transition: Transition.noTransition,
                                ),
                                child: Text(
                                  'Forgot Password',
                                  style: TextStyle(
                                    color: Color(0xFF161617),
                                    fontSize: 14,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      SizedBox(height: reSize(20)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Don\'t have account? ',
                            style: TextStyle(
                              color: Color(0xFF999999),
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                            ),
                          ),
                          GestureDetector(
                            onTap: () => Get.to(
                              () => RegisterPage(),
                              transition: Transition.noTransition,
                            ),
                            child: Text(
                              'Register',
                              style: TextStyle(
                                color: Color(0xFF202215),
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: reSize(40)),
                    ],
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
