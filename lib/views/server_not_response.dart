import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:notary/controllers/authentication.dart';
import 'package:notary/views/auth.dart';
import 'package:notary/views/start.dart';
import 'package:notary/widgets/network_connection.dart';
import 'package:provider/provider.dart';

import '../methods/resize_formatting.dart';
import '../utils/navigate.dart';
import '../widgets/button_primary.dart';
import '../widgets/button_primary_outline.dart';

class ServerNotResponse extends StatefulWidget {
  @override
  State<ServerNotResponse> createState() => _ServerNotResponseState();
}

class _ServerNotResponseState extends State<ServerNotResponse> {
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
                      Center(child: SvgPicture.asset('assets/images/113.svg')),
                ),
                SizedBox(
                  height: reSize(context, 30),
                ),
                Text(
                  'Server Not Responded!',
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
                  'Our specialists are working to fix the problem!',
                  style: TextStyle(
                    color: Color(0xFF494949),
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: reSize(context, 40),
                ),
                ButtonPrimary(
                  callback: () => StateM(context).navTo(Start()),
                  text: "Try again",
                  width: 232,
                ),
                SizedBox(
                  height: reSize(context, 15),
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
