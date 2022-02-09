import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:notary/controllers/user.dart';
import 'package:notary/methods/show_error.dart';
import 'package:notary/widgets/button_primary.dart';
import 'package:notary/widgets/edit_intput.widget.dart';
import 'package:notary/widgets/loading_page.dart';
import 'package:notary/widgets/terms_view.dart';
import 'package:notary/widgets/title_page.dart';

class CertificatePassword extends StatefulWidget {
  final Uint8List byteData;
  final String fileName;

  CertificatePassword(
    this.byteData,
    this.fileName,
  );

  @override
  _CertificatePasswordState createState() => _CertificatePasswordState();
}

class _CertificatePasswordState extends State<CertificatePassword> {
  final UserController _userController = Get.put(UserController());
  String _password;
  bool _hidePassword;
  bool _savePassword;
  bool _acceptTerms;
  bool _loading;

  initState() {
    _hidePassword = true;
    _savePassword = false;
    _acceptTerms = false;
    _loading = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LoadingPage(
        _loading,
        SingleChildScrollView(
          child: Container(
            height: Get.height,
            child: Column(
              children: [
                TitlePage(
                  needNav: true,
                  title: "Certificate Password",
                  description:
                      'Enter password you created to retrieve certificate',
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(),
                        Container(
                          child: Center(
                            child: SvgPicture.asset(
                              'assets/images/99.svg',
                              width: 32,
                              height: 32,
                            ),
                          ),
                          width: 90,
                          height: 118,
                          decoration: BoxDecoration(
                            color: Color(0xFFF5F6F9),
                            border: Border.all(
                              color: Color(0xFF000000).withOpacity(0.07),
                            ),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        Text(
                          widget.fileName,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          'Certificate is needed to encrypt final document. You will need to enter password every time after session or you can save password now',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xFF20303C),
                            fontSize: 14,
                            height: 1.4,
                          ),
                        ),
                        EditInput(
                          hintText: 'Password for certificate',
                          labelText: 'Password for certificate',
                          onChanged: (String value) {
                            _password = value;
                            setState(() {});
                          },
                          obscureText: _hidePassword,
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
                          validate: (String value) {
                            if (value.trim().isEmpty) {
                              return "Password is required";
                            }
                            return null;
                          },
                        ),
                        Column(
                          children: [
                            GestureDetector(
                              onTap: _passwordState,
                              child: Row(
                                children: [
                                  Container(
                                    width: 20,
                                    height: 20,
                                    decoration: BoxDecoration(
                                      color: _savePassword
                                          ? Theme.of(context).primaryColor
                                          : Color(0xFFFFFFFF),
                                      border: Border.all(
                                        color: _savePassword
                                            ? Theme.of(context).primaryColor
                                            : Color(0xFFCDCDCD),
                                        width: 1,
                                      ),
                                      borderRadius: BorderRadius.circular(3),
                                    ),
                                    child: _savePassword
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
                                    "Validate your certificate",
                                    style: TextStyle(
                                      color: Theme.of(context).colorScheme.secondary,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 20),
                            GestureDetector(
                              onTap: _termState,
                              child: Row(
                                children: [
                                  Container(
                                    width: 20,
                                    height: 20,
                                    decoration: BoxDecoration(
                                      color: _acceptTerms
                                          ? Theme.of(context).primaryColor
                                          : Color(0xFFFFFFFF),
                                      border: Border.all(
                                        color: _acceptTerms
                                            ? Theme.of(context).primaryColor
                                            : Color(0xFFCDCDCD),
                                        width: 1,
                                      ),
                                      borderRadius: BorderRadius.circular(3),
                                    ),
                                    child: _acceptTerms
                                        ? Center(
                                            child: Icon(
                                              Icons.check,
                                              size: 14,
                                            ),
                                          )
                                        : SizedBox(),
                                  ),
                                  SizedBox(width: 10),
                                  RichText(
                                    text: TextSpan(
                                      style: TextStyle(
                                        color: Theme.of(context).colorScheme.secondary,
                                        fontSize: 14,
                                      ),
                                      children: [
                                        TextSpan(text: 'I accept ', style: TextStyle(
                                          fontSize: 14,
                                        )),
                                        TextSpan(
                                          text: 'Terms of Use',
                                          style: TextStyle(
                                            fontSize: 14,
                                            decoration:
                                                TextDecoration.underline,
                                          ),
                                          recognizer: TapGestureRecognizer()
                                            ..onTap = () => Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        TermsView(),
                                                  ),
                                                ),
                                        )
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        Container(
                          width: Get.width - 40,
                          child: Column(
                            children: [
                              RichText(
                                text: TextSpan(
                                  style: TextStyle(
                                    color: Color(0xFFADAEAF),
                                    fontSize: 14,
                                  ),
                                  children: [
                                    TextSpan(
                                        text: 'Uploaded wrong certificate? '),
                                    TextSpan(
                                      text: 'Remove',
                                      style: TextStyle(
                                        color: Theme.of(context).colorScheme.secondary,
                                      ),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = _removeCertificate,
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(height: 20),
                              Text(
                                'By selecting Open Certificate, I confirm the above information is true and correct',
                                style: TextStyle(
                                  color: Color(0xFF999999),
                                  fontSize: 12,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 15),
                              ButtonPrimary(
                                text: "Open Certificate",
                                callback: !_acceptTerms ||
                                        _password == null ||
                                        _password.isEmpty
                                    ? null
                                    : _uploadCertificate,
                              ),
                              SizedBox(height: 40),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ));
  }

  _termState() async {
    _acceptTerms = !_acceptTerms;
    setState(() {});
  }

  _passwordState() async {
    _savePassword = !_savePassword;
    setState(() {});
  }

  Future<void> _uploadCertificate() async {
    FocusScopeNode currentFocus = FocusScope.of(context);

    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }

    _loading = true;
    setState(() {});
    try {
      final buffer = widget.byteData.buffer;
      Directory tempDir = await getTemporaryDirectory();
      String tempPath = tempDir.path;
      var filePath = tempPath + '/' + widget.fileName;
      File certificate = await new File(filePath).writeAsBytes(
          buffer.asUint8List(
              widget.byteData.offsetInBytes, widget.byteData.lengthInBytes));

      await _userController.addCertificate(
        certificate,
        _password,
        _savePassword,
      );
      Get.back();
      _loading = false;
      setState(() {});
    } catch (err) {
      _loading = false;
      setState(() {});
      showError(err.toString());
    }
  }

  Future<void> _removeCertificate() async {
    try {
      await _userController.removeCertificate();
      Get.back();
    } catch (err) {
      showError(err);
    }
  }
}
