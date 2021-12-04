import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:notary/controllers/authentication.dart';
import 'package:notary/methods/resize_formatting.dart';
import 'package:notary/widgets/button_primary.dart';
import 'package:notary/widgets/edit_intput.widget.dart';

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
  bool _isStarting;

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
        // await Provider.of<AuthProvider>(context, listen: false)
        //     .loginGoogle(googleKey.accessToken);
      } else
        throw "Invalid data for continue";
      _isLoading = false;
      setState(() {});
      // Navigator.pushReplacement(
      //   context,
      //   PageRouteBuilder(
      //     pageBuilder: (context, animation1, animation2) => Home(),
      //     transitionDuration: Duration(seconds: 0),
      //   ),
      // );
    } catch (error) {
      _isLoading = false;
      setState(() {});
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(
      //     builder: (context) => ErrorPage(
      //       errorMessage: error.toString(),
      //       callback: () => Navigator.pop(context),
      //     ),
      //   ),
      // );
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
    try {
      _isLoading = true;
      setState(() {});
      _authController.login({
        "email": _email,
        "password": _password,
        "remember": _remember,
      });
      // await Provider.of<AuthProvider>(context, listen: false)
      //     .login(_email, _password, _remember);
      _isLoading = false;
      setState(() {});
      // Navigator.pushReplacement(
      //   context,
      //   PageRouteBuilder(
      //     pageBuilder: (context, animation1, animation2) => HomePage(),
      //     transitionDuration: Duration(seconds: 0),
      //   ),
      // );
      //  Navigator.of(context).pushReplacementNamed(HomePage.id);
    } catch (err) {
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(
      //     builder: (context) => ErrorPage(
      //       errorMessage: err.toString(),
      //       callback: () => Navigator.pop(context),
      //     ),
      //   ),
      // );
      Get.bottomSheet(
        Container(
          height: 100,
          child: Text(err.toString()),
        ),
        backgroundColor: Color(0xFFFFFFFF),
      );
      _isLoading = false;
      setState(() {});
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
    return Scaffold(
      body: _isLoading
          ? Text("Loading")
          : SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height,
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
                                        color: Theme.of(context).accentColor,
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
                                    width: MediaQuery.of(context).size.width,
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
                                    // onTap: () => Navigator.push(
                                    //   context,
                                    //   MaterialPageRoute(
                                    //     builder: (context) =>
                                    //         RecoveredPage(
                                    //           isRegister: false,
                                    //         ),
                                    //   ),
                                    // ),
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
                                // onTap: () => Navigator.push(
                                //   context,
                                //   MaterialPageRoute(
                                //     builder: (context) =>
                                //         RegisterPage(),
                                //   ),
                                // ),
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
            ),
    );
  }
}
