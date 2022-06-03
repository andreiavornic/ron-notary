import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:notary/widgets/network_connection.dart';
import 'package:provider/provider.dart';

import '../controllers/authentication.dart';
import '../methods/resize_formatting.dart';
import '../utils/navigate.dart';
import '../widgets/button_primary_outline.dart';
import 'auth.dart';

class SessionExpired extends StatefulWidget {

  @override
  State<SessionExpired> createState() => _SessionExpiredState();
}

class _SessionExpiredState extends State<SessionExpired> {

  callback() async {
    await Provider.of<AuthenticationController>(context, listen: false)
        .logOut();
    StateM(context).navOff(Auth());
  }

  @override
  Widget build(BuildContext context) {
    return NetworkConnection(
      Scaffold(
        body: Container(
          width: StateM(context).width(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: reSize(context, 80),
                  height: reSize(context, 80),
                  decoration: BoxDecoration(
                    color: Color(0xFFFC563D),
                    borderRadius: BorderRadius.circular(80),
                  ),
                  child:
                  Center(child: SvgPicture.asset('assets/images/124.svg')),
                ),
                SizedBox(
                  height: reSize(context, 30),
                ),
                Text(
                  'Session Expired!',
                  style: TextStyle(
                    color: Color(0xFF000000),
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: reSize(context, 25),
                ),
                Text(
                  'Your session was expired, please login again to continue use, our app!',
                  style: TextStyle(
                    color: Color(0xFF494949),
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: reSize(context, 40),
                ),
                ButtonPrimaryOutline(
                  callback: callback,
                  text: "Sign Out",
                  width: 232,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
