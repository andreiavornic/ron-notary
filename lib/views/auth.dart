import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:notary/controllers/authentication.dart';
import 'package:notary/methods/resize_formatting.dart';
import 'package:notary/methods/show_error.dart';
import 'package:notary/utils/navigate.dart';
import 'package:notary/views/register.dart';
import 'package:notary/views/start.dart';
import 'package:notary/widgets/button_primary.dart';
import 'package:notary/widgets/edit_input.widget.dart';
import 'package:notary/widgets/loading_page.dart';
import 'package:notary/widgets/recovered.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Auth extends StatefulWidget {
  @override
  _AuthState createState() => _AuthState();
}

class _AuthState extends State<Auth> {
  // final AuthenticationController Provider.of<AuthenticationController>(context, listen: false) =
  //     Get.put(AuthenticationController());
  final GlobalKey<FormState> _formKey = GlobalKey();
  String _email;
  String _password;
  bool _hidePassword;
  bool _isLoading;
  bool _remember;
  bool _firstInit;

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
    _firstInit = false;
    _getFirstInit();
    super.initState();
  }

  _getFirstInit() async {
    final prefs = await SharedPreferences.getInstance();
    bool result = prefs.getBool("firstInit");

    if (result != null) {
      _firstInit = result;
    } else {
      _firstInit = true;
    }
    setState(() {});
  }

  _makeReady() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool("firstInit", false);
    StateM(context).navOff(Auth());
  }

  Future<void> _loginGoogle() async {
    try {
      _isLoading = true;
      setState(() {});
      _googleSignIn.signOut();
      GoogleSignInAccount result = await _googleSignIn.signIn();
      if (result != null) {
        GoogleSignInAuthentication googleKey = await result.authentication;
        await Provider.of<AuthenticationController>(context, listen: false)
            .loginGoogle(googleKey.accessToken);
      } else
        throw "Invalid data for continue";
      _isLoading = false;
      setState(() {});
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation1, animation2) => Start(),
          transitionDuration: Duration(seconds: 0),
        ),
      );
    } catch (err) {
      _isLoading = false;
      setState(() {});
      showError(err, context);
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
      await Provider.of<AuthenticationController>(context, listen: false)
          .login({
        "email": _email,
        "password": _password,
        "remember": _remember,
      });
      StateM(context).navOff(Start());
      _isLoading = false;
      setState(() {});
    } catch (err) {
      print("err $err");
      _isLoading = false;
      setState(() {});
      showError(err, context);
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
    return _firstInit
        ? Scaffold(
            body: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/115.jpg"),
                  fit: BoxFit.cover,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                child: Column(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Center(
                        child: SvgPicture.asset(
                          "assets/images/116.svg",
                          width: reSize(context, 100),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style: TextStyle(
                            fontSize: reSize(context, 40),
                            fontWeight: FontWeight.w700,
                          ),
                          children: [
                            TextSpan(text: 'Remote\n'),
                            TextSpan(text: 'Online\n'),
                            TextSpan(text: 'Notarization\n'),
                            TextSpan(
                              text: 'in minutes',
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: _makeReady,
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                Theme.of(context).primaryColor,
                              ),
                              overlayColor: MaterialStateProperty.all(
                                Color(0xFF161617).withOpacity(0.1),
                              ),
                              padding:
                                  MaterialStateProperty.all(EdgeInsets.zero),
                            ),
                            child: Container(
                              height: reSize(context, 51),
                              child: Center(
                                child: Text(
                                  'Get Started',
                                  style: TextStyle(
                                    color: Color(0xFF161617),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: reSize(context, 25)),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Already have an account?',
                                style: TextStyle(
                                  color: Color(0xFFFFFFFF),
                                ),
                              ),
                              SizedBox(width: reSize(context, 5)),
                              InkWell(
                                onTap: _makeReady ,
                                child: Text(
                                  'Login',
                                  style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                              )
                            ],
                          ),
                          SizedBox(height: 40),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          )
        : LoadingPage(
            _isLoading,
            SingleChildScrollView(
              child: Container(
                height: StateM(context).height(),
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
                                width: reSize(context, 100),
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
                                    keyboardType: TextInputType.emailAddress,
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
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary,
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
                                                  ? Theme.of(context)
                                                      .primaryColor
                                                  : Color(0xFFCDCDCD),
                                              width: 1,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(3),
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
                                    width: StateM(context).width(),
                                  ),
                                  SizedBox(height: reSize(context, 10)),
                                  Container(
                                    height: reSize(context, 51),
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
                                              width: reSize(context, 24),
                                            ),
                                            SizedBox(
                                              width: reSize(context, 10),
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
                                  SizedBox(height: reSize(context, 25)),
                                  GestureDetector(
                                    onTap: () =>
                                        StateM(context).navTo(RecoveredPage(
                                      isRegister: false,
                                    )),
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
                          SizedBox(height: reSize(context, 20)),
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
                                onTap: () =>
                                    StateM(context).navTo(RegisterPage()),
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
                          SizedBox(height: reSize(context, 40)),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ));
  }
}
