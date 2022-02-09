import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:notary/controllers/authentication.dart';
import 'package:notary/methods/resize_formatting.dart';
import 'package:notary/views/settings/account.dart';
import 'package:notary/views/settings/biling_plan.dart';
import 'package:notary/views/settings/bottom_navigator.dart';
import 'package:notary/views/settings/digital_certificate.dart';
import 'package:notary/views/settings/notary.dart';
import 'package:notary/views/settings/signature_seal.dart';
import 'package:notary/widgets/network_connection.dart';
import 'package:notary/widgets/title_page.dart';

class SettingsMenu extends StatefulWidget {
  @override
  _SettingsMenuState createState() => _SettingsMenuState();
}

class _SettingsMenuState extends State<SettingsMenu> {
  AuthenticationController _authController =
      Get.put(AuthenticationController());
  bool _isIntro;

  @override
  void initState() {
    _isIntro = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return NetworkConnection(
      widget: Container(
        height: Get.height,
        child: SingleChildScrollView(
          child: Container(
            child: Column(
              children: [
                TitlePage(
                  title: 'Settings',
                  description: 'Account information details',
                  needNav: true,
                ),
                SizedBox(height: reSize(20)),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    children: [
                      Column(
                        children: [
                          ButtonNavigator(
                            title: "Account",
                            icon: "48",
                            onPressed: () => Get.to(() => Account()),
                          ),
                          ButtonNavigator(
                            title: "Notary Details",
                            icon: "49",
                            onPressed: () => Get.to(() => Notary()),
                          ),
                          ButtonNavigator(
                            title: "eSignature & eSeal",
                            icon: "50",
                            onPressed: () => Get.to(() => SignatureSeal()),
                          ),
                          ButtonNavigator(
                            title: "Digital Certificate",
                            icon: "51",
                            onPressed: () => Get.to(() => DigitalCertificate()),
                          ),
                          ButtonNavigator(
                            title: "Billing & Plan",
                            icon: "52",
                            onPressed: () => Get.to(() => BillingPlan()),
                          ),
                        ],
                      ),
                      InkWell(
                        onTap: _activateIntro,
                        child: Padding(
                          padding: EdgeInsets.only(top: 10.0, bottom: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Get intro info any time',
                                      style: TextStyle(
                                        color: Color(0xFFA4A4A4),
                                        fontSize: 12,
                                      ),
                                    ),
                                    Text(
                                      _isIntro != null && _isIntro
                                          ? 'Enabled'
                                          : 'Disabled',
                                      style: TextStyle(
                                          color: Theme.of(context).colorScheme.secondary,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ],
                                ),
                              ),
                              AnimatedContainer(
                                duration: Duration(
                                  milliseconds: 200,
                                ),
                                width: reSize(30),
                                height: reSize(18),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(9),
                                  color: _isIntro
                                      ? Theme.of(context).colorScheme.secondary
                                      : Color(0xFFEEEEEE),
                                ),
                                child: AnimatedAlign(
                                  duration: Duration(
                                    milliseconds: 200,
                                  ),
                                  alignment: _isIntro
                                      ? FractionalOffset(0.9, 0.5)
                                      : FractionalOffset(0.1, 0.5),
                                  child: Container(
                                    width: reSize(16),
                                    height: reSize(16),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(9),
                                      color: _isIntro
                                          ? Theme.of(context).primaryColor
                                          : Color(0xFFFFFFFFF),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.15),
                                          spreadRadius: 0,
                                          blurRadius: 8,
                                          offset: Offset(0,
                                              3), // changes position of shadow
                                        ),
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.06),
                                          spreadRadius: 0,
                                          blurRadius: 1,
                                          offset: Offset(0,
                                              3), // changes position of shadow
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: reSize(20)),
                      Row(
                        children: [
                          TextButton(
                            style: ButtonStyle(
                              padding: MaterialStateProperty.all(
                                EdgeInsets.zero,
                              ),
                              overlayColor: MaterialStateProperty.all(
                                Color(0xFFFF5454).withOpacity(0.2),
                              ),
                            ),
                            onPressed: _logout,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 20.0,
                                horizontal: 0,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        child: SvgPicture.asset(
                                            'assets/images/71.svg'),
                                      ),
                                      SizedBox(width: 10),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Logout",
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w400,
                                              color: Color(0xFFFF5454),
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _activateIntro() {
    _isIntro = !_isIntro;
    setState(() {});
  }

  _logout() {
    _authController.logOut();
  }
}
