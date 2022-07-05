import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:notary/controllers/authentication.dart';
import 'package:notary/controllers/user.dart';
import 'package:notary/methods/resize_formatting.dart';
import 'package:notary/utils/navigate.dart';
import 'package:notary/views/settings/account.dart';
import 'package:notary/views/settings/biling_plan.dart';
import 'package:notary/views/settings/bottom_navigator.dart';
import 'package:notary/views/settings/digital_certificate.dart';
import 'package:notary/views/settings/notary.dart';
import 'package:notary/views/settings/signature_seal.dart';
import 'package:notary/widgets/title_page.dart';
import 'package:provider/provider.dart';

import '../widgets/network_connection.dart';
import 'auth.dart';

class SettingsMenu extends StatefulWidget {
  @override
  _SettingsMenuState createState() => _SettingsMenuState();
}

class _SettingsMenuState extends State<SettingsMenu> {


  AuthenticationController _authenticationController;

  @override
  void initState() {
    _authenticationController =
        Provider.of<AuthenticationController>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserController>(builder: (context, _controller, _) {
      return NetworkConnection(
        Scaffold(
          body: Container(
            height: StateM(context).height(),
            child: SingleChildScrollView(
              child: Container(
                child: Column(
                  children: [
                    TitlePage(
                      title: 'Settings',
                      description: 'Account information details',
                      needNav: true,
                    ),
                    SizedBox(height: reSize(context, 20)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Column(
                        children: [
                          Column(
                            children: [
                              ButtonNavigator(
                                title: "Account",
                                icon: "48",
                                onPressed: () =>
                                    StateM(context).navTo(Account()),
                              ),
                              ButtonNavigator(
                                title: "Notary Details",
                                icon: "49",
                                onPressed: _controller.notary == null
                                    ? null
                                    : () => StateM(context).navTo(Notary()),
                              ),
                              ButtonNavigator(
                                title: "eSignature & eSeal",
                                icon: "50",
                                onPressed: () =>
                                    StateM(context).navTo(SignatureSeal()),
                              ),
                              ButtonNavigator(
                                title: "Digital Certificate",
                                icon: "51",
                                onPressed: _controller.certificate == null
                                    ? null
                                    : () => StateM(context)
                                        .navTo(DigitalCertificate()),
                              ),
                              ButtonNavigator(
                                title: "Billing & Plan",
                                icon: "52",
                                onPressed: _controller.user.promoCode !=null ? () =>
                                    StateM(context).navTo(BillingPlan()) : _controller.payment == null
                                    ? null
                                    : () =>
                                        StateM(context).navTo(BillingPlan()),
                              ),
                            ],
                          ),
                          // InkWell(
                          //   onTap: _activateIntro,
                          //   child: Padding(
                          //     padding: EdgeInsets.only(top: 10.0, bottom: 10),
                          //     child: Row(
                          //       mainAxisAlignment:
                          //           MainAxisAlignment.spaceBetween,
                          //       children: [
                          //         Expanded(
                          //           child: Column(
                          //             crossAxisAlignment:
                          //                 CrossAxisAlignment.start,
                          //             children: [
                          //               Text(
                          //                 'Get intro info any time',
                          //                 style: TextStyle(
                          //                   color: Color(0xFFA4A4A4),
                          //                   fontSize: 12,
                          //                 ),
                          //               ),
                          //               Text(
                          //                 _isIntro != null && _isIntro
                          //                     ? 'Enabled'
                          //                     : 'Disabled',
                          //                 style: TextStyle(
                          //                     color: Theme.of(context)
                          //                         .colorScheme
                          //                         .secondary,
                          //                     fontSize: 14,
                          //                     fontWeight: FontWeight.w400),
                          //               ),
                          //             ],
                          //           ),
                          //         ),
                          //         AnimatedContainer(
                          //           duration: Duration(
                          //             milliseconds: 200,
                          //           ),
                          //           width: reSize(context, 30),
                          //           height: reSize(context, 18),
                          //           decoration: BoxDecoration(
                          //             borderRadius: BorderRadius.circular(9),
                          //             color: _isIntro
                          //                 ? Theme.of(context)
                          //                     .colorScheme
                          //                     .secondary
                          //                 : Color(0xFFEEEEEE),
                          //           ),
                          //           child: AnimatedAlign(
                          //             duration: Duration(
                          //               milliseconds: 200,
                          //             ),
                          //             alignment: _isIntro
                          //                 ? FractionalOffset(0.9, 0.5)
                          //                 : FractionalOffset(0.1, 0.5),
                          //             child: Container(
                          //               width: reSize(context, 16),
                          //               height: reSize(context, 16),
                          //               decoration: BoxDecoration(
                          //                 borderRadius:
                          //                     BorderRadius.circular(9),
                          //                 color: _isIntro
                          //                     ? Theme.of(context).primaryColor
                          //                     : Color(0xFFFFFFFFF),
                          //                 boxShadow: [
                          //                   BoxShadow(
                          //                     color: Colors.black
                          //                         .withOpacity(0.15),
                          //                     spreadRadius: 0,
                          //                     blurRadius: 8,
                          //                     offset: Offset(0,
                          //                         3), // changes position of shadow
                          //                   ),
                          //                   BoxShadow(
                          //                     color: Colors.black
                          //                         .withOpacity(0.06),
                          //                     spreadRadius: 0,
                          //                     blurRadius: 1,
                          //                     offset: Offset(0,
                          //                         3), // changes position of shadow
                          //                   ),
                          //                 ],
                          //               ),
                          //             ),
                          //           ),
                          //         ),
                          //       ],
                          //     ),
                          //   ),
                          // ),
                          // SizedBox(height: reSize(context, 20)),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
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
        ),
      );
    });
  }

  _logout() async {
    await _authenticationController.logOut();
    StateM(context).navOff(Auth());
  }
}
