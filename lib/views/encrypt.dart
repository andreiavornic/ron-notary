import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:notary/controllers/session.dart';
import 'package:notary/methods/resize_formatting.dart';
import 'package:notary/methods/show_error.dart';
import 'package:notary/widgets/button_primary.dart';

import 'download.dart';

class Encryption extends StatefulWidget {
  @override
  _EncryptionState createState() => _EncryptionState();
}

class _EncryptionState extends State<Encryption> {
  SessionController _sessionController = Get.put(SessionController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: Get.height,
          width: Get.width,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                Container(height: reSize(70)),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Encryption",
                        style: TextStyle(
                          color: Theme.of(context).accentColor,
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: reSize(60)),
                      Container(
                        width: reSize(80),
                        height: reSize(80),
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(40),
                        ),
                        child: SvgPicture.asset('assets/images/109.svg'),
                      ),
                      SizedBox(height: reSize(60)),
                      Column(
                        children: [
                          Text(
                            "Digital Certificate",
                            style: TextStyle(
                              color: Theme.of(context).accentColor,
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: reSize(10)),
                          Column(
                            children: [
                              Text(
                                "Your certificate is ready for encrypting, with your digital certificate",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Color(0xFF494949),
                                  fontSize: 14,
                                ),
                              ),
                              SizedBox(height: reSize(55)),
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                Column(
                  children: [
                    InkWell(
                      onTap: _cancelEncryption,
                      overlayColor:
                          MaterialStateProperty.all(Colors.transparent),
                      highlightColor: Colors.transparent,
                      child: Text(
                        'Cancel Encryption',
                        style: TextStyle(
                          color: Color(0xFF161617),
                          fontSize: 16,
                        ),
                      ),
                    ),
                    SizedBox(height: reSize(25)),
                    ButtonPrimary(
                      text: "Encrypt",
                      callback: _encryptDocument,
                    ),
                  ],
                ),
                SizedBox(
                    height: MediaQuery.of(context).size.height < 670
                        ? 20
                        : reSize(40)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _encryptDocument() async {
    try {
      await _sessionController.encryptFile();
      Get.offAll(
            () => Download(),
        transition: Transition.noTransition,
      );
    } catch (err) {
      showError(err);
    }
  }

  _cancelEncryption() async {
    try {} catch (err) {
      showError(err);
    }
  }
}
