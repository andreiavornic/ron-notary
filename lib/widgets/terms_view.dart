import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'button_primary.dart';

class TermsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFFFFFFFF),
        body: Column(
          children: [
            SizedBox(height: 90),
            Container(
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Terms of Use",
                      style: TextStyle(
                        fontSize: 32,
                        color: Color(0xFF000000),
                        fontWeight: FontWeight.w700,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      "Please read and accept",
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF494949),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 40),
                      Text(
                        "Accounts",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 10),
                      RichText(
                        text: TextSpan(
                          style: TextStyle(
                            color: Color(0xFF000000),
                            fontSize: 13,
                          ),
                          text:
                          "For you to use the Site, you have to start an account and provide information about yourself. You warrant that: (a) all required registration information you submit is truthful, up-to-date and accurate; (b) you will maintain the accuracy of such information.",
                        ),
                      ),
                      SizedBox(height: 10),
                      RichText(
                        text: TextSpan(
                            style: TextStyle(
                              color: Color(0xFF000000),
                              fontSize: 13,
                            ),
                            text:
                            "You may delete your Account at any time by following the instructions on the Site.  Company may suspend or terminate your Account in accordance with Section."),
                      ),
                      SizedBox(height: 40),
                      Text(
                        "User Content",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 10),
                      RichText(
                        text: TextSpan(
                          style: TextStyle(
                            color: Color(0xFF000000),
                            fontSize: 13,
                          ),
                          text:
                          "You bear all risks associated with use of your User Content.  You hereby certify that your User Content does not violate our Acceptable Use Policy. ",
                        ),
                      ),
                      SizedBox(height: 10),
                      RichText(
                        text: TextSpan(
                            style: TextStyle(
                              color: Color(0xFF000000),
                              fontSize: 13,
                            ),
                            text:
                            "You may not represent or imply to others that your User Content is in any way provided, sponsored or endorsed by Company."),
                      ),
                      SizedBox(height: 10),
                      RichText(
                        text: TextSpan(
                          style: TextStyle(
                            color: Color(0xFF000000),
                            fontSize: 13,
                          ),
                          text:
                          "For you to use the Site, you have to start an account and provide information about yourself. You warrant that: (a) all required registration information you submit is truthful, up-to-date and accurate; (b) you will maintain the accuracy of such information.",
                        ),
                      ),
                      SizedBox(height: 10),
                      RichText(
                        text: TextSpan(
                            style: TextStyle(
                              color: Color(0xFF000000),
                              fontSize: 13,
                            ),
                            text:
                            "You may delete your Account at any time by following the instructions on the Site.  Company may suspend or terminate your Account in accordance with Section."),
                      ),
                      SizedBox(height: 40),
                      Text(
                        "User Content",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 10),
                      RichText(
                        text: TextSpan(
                          style: TextStyle(
                            color: Color(0xFF000000),
                            fontSize: 13,
                          ),
                          text:
                          "You bear all risks associated with use of your User Content.  You hereby certify that your User Content does not violate our Acceptable Use Policy. ",
                        ),
                      ),
                      SizedBox(height: 10),
                      RichText(
                        text: TextSpan(
                            style: TextStyle(
                              color: Color(0xFF000000),
                              fontSize: 13,
                            ),
                            text:
                            "You may not represent or imply to others that your User Content is in any way provided, sponsored or endorsed by Company."),
                      ),
                      SizedBox(height: 10),
                      RichText(
                        text: TextSpan(
                          style: TextStyle(
                            color: Color(0xFF000000),
                            fontSize: 13,
                          ),
                          text:
                          "For you to use the Site, you have to start an account and provide information about yourself. You warrant that: (a) all required registration information you submit is truthful, up-to-date and accurate; (b) you will maintain the accuracy of such information.",
                        ),
                      ),
                      SizedBox(height: 10),
                      RichText(
                        text: TextSpan(
                            style: TextStyle(
                              color: Color(0xFF000000),
                              fontSize: 13,
                            ),
                            text:
                            "You may delete your Account at any time by following the instructions on the Site.  Company may suspend or terminate your Account in accordance with Section."),
                      ),
                      SizedBox(height: 40),
                      Text(
                        "User Content",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 10),
                      RichText(
                        text: TextSpan(
                          style: TextStyle(
                            color: Color(0xFF000000),
                            fontSize: 13,
                          ),
                          text:
                          "You bear all risks associated with use of your User Content.  You hereby certify that your User Content does not violate our Acceptable Use Policy. ",
                        ),
                      ),
                      SizedBox(height: 10),
                      RichText(
                        text: TextSpan(
                            style: TextStyle(
                              color: Color(0xFF000000),
                              fontSize: 13,
                            ),
                            text:
                            "You may not represent or imply to others that your User Content is in any way provided, sponsored or endorsed by Company."),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Container(
                child: Column(
                  children: [
                    ButtonPrimary(
                      text: "Accept",
                      width: 163,
                      callback: () => Get.back(),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              )
              ,
            )
          ],
        ));
  }
}
