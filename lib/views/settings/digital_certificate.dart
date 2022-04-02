import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:notary/controllers/user.dart';
import 'package:notary/methods/resize_formatting.dart';
import 'package:notary/methods/show_error.dart';
import 'package:notary/utils/navigate.dart';
import 'package:notary/views/process/confirm_delete.dart';
import 'package:notary/widgets/button_primary.dart';
import 'package:notary/widgets/button_primary_outline.dart';
import 'package:notary/widgets/edit_input.widget.dart';
import 'package:notary/widgets/modals/modal_container.dart';
import 'package:notary/widgets/title_page.dart';
import 'package:provider/provider.dart';

import '../../widgets/network_connection.dart';
import '../start.dart';

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
    return Consumer<UserController>(builder: (context, _controller, _) {
      return NetworkConnection(
        Scaffold(
          body: Container(
            height: StateM(context).height(),
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
                          SizedBox(height: reSize(context, 50)),
                          Container(
                            child: Center(
                              child: SvgPicture.asset(
                                'assets/images/99.svg',
                                width: reSize(context, 32),
                                height: reSize(context, 32),
                              ),
                            ),
                            width: reSize(context, 90),
                            height: reSize(context, 118),
                            decoration: BoxDecoration(
                              color: Color(0xFFF5F6F9),
                              border: Border.all(
                                color: Color(0xFF000000).withOpacity(0.07),
                              ),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          SizedBox(height: reSize(context, 15)),
                          Text(
                            "${_controller.certificate}",
                            style: TextStyle(
                              color: Color(0xFF000000),
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(height: reSize(context, 30)),
                          Text(
                            "Uploaded",
                            style: TextStyle(
                              color: Color(0xFF161617),
                              fontSize: 28,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(height: reSize(context, 20)),
                          Text(
                            "Certificate will be used to sign the final document. Set password to make it secure",
                            style: TextStyle(
                              color: Color(0xFF494949),
                              fontSize: 14,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: reSize(context, 50)),
                          _controller.passwordCertificate
                              ? Container(
                                  child: Column(
                                    children: [
                                      Container(
                                        width: reSize(context, 80),
                                        height: reSize(context, 80),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(50),
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                        ),
                                        child: Center(
                                          child: SvgPicture.asset(
                                            'assets/images/109.svg',
                                            color:
                                                Theme.of(context).primaryColor,
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: reSize(context, 15)),
                                      Text(
                                        'Password saved',
                                        style: TextStyle(
                                          color: Color(0xFF161617),
                                          fontSize: 16,
                                        ),
                                      ),
                                      SizedBox(height: reSize(context, 15)),
                                      ButtonPrimaryOutline(
                                        callback: () => modalContainerSimple(
                                            ConfirmDelete(
                                              callback: _removePassword,
                                              description: Text(
                                                "The password is used for digital certificate\ndocuments",
                                                style: TextStyle(
                                                  color: Color(0xFF161617),
                                                  fontSize: 14,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                            context),
                                        text: 'Remove Password',
                                        width: reSize(context, 230),
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
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                          size: reSize(context, 16),
                                        ),
                                        onPressed: () {
                                          _hidePassword = !_hidePassword;
                                          setState(() {});
                                        },
                                      ),
                                    ),
                                    SizedBox(height: reSize(context, 35)),
                                    GestureDetector(
                                      onTap: _passwordState,
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            width: reSize(context, 20),
                                            height: reSize(context, 20),
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
                                                      size: reSize(context, 14),
                                                    ),
                                                  )
                                                : SizedBox(),
                                          ),
                                          SizedBox(width: reSize(context, 10)),
                                          Text(
                                            "I authorize Ronary to store my Password\nCertificate",
                                            style: TextStyle(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .secondary,
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
                              SizedBox(height: reSize(context, 20)),
                              InkWell(
                                onTap: () => modalContainerSimple(
                                    ConfirmDelete(
                                      callback: _removeCertificate,
                                      description: Text(
                                        "Without the digital certificate you will not be able to perform sessions",
                                        style: TextStyle(
                                          color: Color(0xFF161617),
                                          fontSize: 14,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    context),
                                child: Text(
                                  "Remove Certificate",
                                  style: TextStyle(
                                    color: Color(0xFFFF5454),
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              SizedBox(height: reSize(context, 20)),
                              _controller.passwordCertificate
                                  ? Container()
                                  : ButtonPrimary(
                                      text: "Save",
                                      callback:
                                          !_controller.passwordCertificate &&
                                                      _password == null ||
                                                  _password.trim().isEmpty ||
                                                  !_savePassword
                                              ? null
                                              : _addPassword,
                                    ),
                              SizedBox(
                                height: StateM(context).height() < 670
                                    ? 20
                                    : reSize(context, 40),
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
        ),
      );
    });
  }

  _passwordState() async {
    _savePassword = !_savePassword;
    setState(() {});
  }

  _addPassword() async {
    try {
      await Provider.of<UserController>(context, listen: false)
          .addCertificatePassword(_password);
    } catch (err) {
      showError(err, context);
    }
  }

  _removePassword() async {
    try {
      await Provider.of<UserController>(context, listen: false)
          .removePassword();
      Navigator.pop(context);
    } catch (err) {
      showError(err, context);
    }
  }

  _removeCertificate() async {
    try {
      await Provider.of<UserController>(context, listen: false)
          .removeCertificate();
      StateM(context).navOff(Start());
    } catch (err) {
      showError(err, context);
    }
  }
}
