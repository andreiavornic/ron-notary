import 'dart:ui';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:notary/controllers/authentication.dart';
import 'package:notary/controllers/session.dart';
import 'package:notary/controllers/user.dart';
import 'package:notary/methods/resize_formatting.dart';
import 'package:notary/methods/show_error.dart';
import 'package:notary/models/session.dart';
import 'package:notary/models/user.dart';
import 'package:notary/views/document-setting.dart';
import 'package:notary/views/download.dart';
import 'package:notary/views/errors/error_page.dart';
import 'package:notary/widgets/bottom_navigator.dart';
import 'package:notary/widgets/button_primary.dart';
import 'package:notary/widgets/button_primary_outline.dart';
import 'package:notary/widgets/loading.dart';
import 'package:notary/widgets/wrap_pages/loading_page.dart';

import 'home/certificate_upload.dart';
import 'home/notary_edit.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final UserController _userController = Get.put(UserController());
  final SessionController _sessionController = Get.put(SessionController());

  @override
  void initState() {
    _userController.getUser();
    _sessionController.getSession();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            GetX<UserController>(builder: (controller) {
              return Expanded(
                  child: Stack(
                children: [
                  Column(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Container(),
                      ),
                      if (controller.certificate.value != null)
                        Expanded(
                          flex: 3,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                child: SvgPicture.asset(
                                  'assets/images/121.svg',
                                ),
                              ),
                            ],
                          ),
                        ),
                      Expanded(
                        flex: controller.notary.value == null
                            ? 11
                            : controller.certificate.value == null
                                ? 4
                                : 8,
                        child: Column(
                          children: [
                            SizedBox(height: reSize(80)),
                            SizedBox(
                              height: reSize(19),
                              child: Text(
                                "Welcome,",
                                style: TextStyle(
                                  color: Theme.of(context).accentColor,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            SizedBox(height: reSize(5)),
                            Text(
                              controller.user.value != null
                                  ? "${controller.user.value.firstName} ${controller.user.value.lastName}"
                                  : "",
                              style: TextStyle(
                                color: Color(0xFF000000),
                                fontSize: 24,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            SizedBox(height: reSize(30)),
                            controller.notary.value == null
                                ? Column(
                                    children: [
                                      Container(
                                        width: reSize(96),
                                        height: reSize(96),
                                        decoration: BoxDecoration(
                                          color: Theme.of(context).primaryColor,
                                          borderRadius:
                                              BorderRadius.circular(50),
                                        ),
                                        child: Center(
                                          child: SvgPicture.asset(
                                              "assets/images/76.svg"),
                                        ),
                                      ),
                                      SizedBox(height: reSize(30)),
                                      Container(
                                        child: Text(
                                          "Before we begin, we require some\nadditional information",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Color(0xFF000000),
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: reSize(30)),
                                      Container(
                                        child: ButtonPrimaryOutline(
                                          text: "Add",
                                          callback: () => Get.to(
                                            () => NotaryEdit(),
                                          ),
                                          width: 232,
                                        ),
                                      ),
                                    ],
                                  )
                                : controller.certificate.value == null
                                    ? CertificateUpload()
                                    : Column(
                                        children: [
                                          Container(
                                            width: 80,
                                            height: 80,
                                            child: TextButton(
                                              onPressed: _createSession,
                                              style: ButtonStyle(
                                                backgroundColor:
                                                    MaterialStateProperty.all(
                                                  Theme.of(context).accentColor,
                                                ),
                                                overlayColor:
                                                    MaterialStateProperty.all(
                                                  Color(0xFF000000)
                                                      .withOpacity(0.1),
                                                ),
                                                shape:
                                                    MaterialStateProperty.all<
                                                        RoundedRectangleBorder>(
                                                  RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            150),
                                                  ),
                                                ),
                                              ),
                                              child: Center(
                                                child: Icon(
                                                  Icons.add,
                                                  size: 45,
                                                  color: Color(0xFFFFFFFF),
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 30),
                                          Text(
                                            "New Session",
                                            style: TextStyle(
                                              color:
                                                  Theme.of(context).accentColor,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 16,
                                            ),
                                          )
                                        ],
                                      )
                          ],
                        ),
                      ),
                    ],
                  ),
                  if (controller.user.value == null)
                    Positioned(
                      top: 0,
                      left: 0,
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 4.0, sigmaY: 4.0),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height,
                          child: Center(
                            child: Loading(),
                          ),
                          decoration: BoxDecoration(
                            color: Color(0xFFFFFFFF).withOpacity(0.4),
                          ),
                        ),
                      ),
                    ),
                ],
              ));
            }),
            BottomNavigator(
              widget: GetX<SessionController>(builder: (controller) {
                return controller.session.value != null &&
                        controller.session.value.state != "CANCELLED" &&
                        // controller.session.value.state != "FINISHED" &&
                        controller.session.value.state != "FAILED"
                    ? Column(
                        children: [
                          SizedBox(height: reSize(40)),
                          ButtonPrimaryOutline(
                            text: 'Discard Session',
                            callback: _deleteSession,
                          ),
                          SizedBox(
                            height: reSize(10),
                          ),
                          ButtonPrimary(
                            text: 'Resume',
                            callback:
                                controller.session.value.state == "FINISHED"
                                    ? () => Get.offAll(
                                          () => Download(),
                                          transition: Transition.noTransition,
                                        )
                                    : () => Get.to(
                                          () => DocumentSetting(),
                                          transition: Transition.noTransition,
                                        ),
                          ),
                          SizedBox(
                            height: reSize(35),
                          ),
                        ],
                      )
                    : Container();
              }),
            ),
          ],
        ),
      ),
    );
  }

  _createSession() async {
    Get.bottomSheet(
      Container(
        height: reSize(366),
        decoration: BoxDecoration(
          color: Color(0xFFFFFFFF),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25.0),
            topRight: Radius.circular(25.0),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(
            top: 10,
            bottom: 50,
            left: 30,
            right: 30,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 4,
                width: 50,
                decoration: BoxDecoration(
                  color: Color(0xFFC5C5C5).withOpacity(0.3),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              SizedBox(height: reSize(25)),
              Container(
                width: MediaQuery.of(context).size.width - 40,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Upload documents",
                      style: TextStyle(
                        color: Theme.of(context).accentColor,
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        letterSpacing: -1,
                      ),
                      textAlign: TextAlign.left,
                    ),
                    SizedBox(height: reSize(5)),
                    Text(
                      "Select documents",
                      style: TextStyle(
                        color: Color(0xFF20303C),
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ],
                ),
              ),
              SizedBox(height: reSize(40)),
              TextButton(
                style: ButtonStyle(
                  padding: MaterialStateProperty.all(
                    EdgeInsets.symmetric(
                      vertical: 15,
                    ),
                  ),
                  overlayColor: MaterialStateProperty.all(
                    Theme.of(context).accentColor.withOpacity(0.1),
                  ),
                ),
                onPressed: _importFilePhone,
                child: Row(
                  children: [
                    SvgPicture.asset("assets/images/55.svg"),
                    SizedBox(
                      width: reSize(20),
                    ),
                    Text(
                      "Import Files",
                      style: TextStyle(
                        color: Theme.of(context).accentColor,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    )
                  ],
                ),
              ),
              Divider(
                color: Color(0xFFE8EAF0),
                height: reSize(1),
              ),
              TextButton(
                style: ButtonStyle(
                  padding: MaterialStateProperty.all(
                    EdgeInsets.symmetric(
                      vertical: 15,
                    ),
                  ),
                  overlayColor: MaterialStateProperty.all(
                    Theme.of(context).accentColor.withOpacity(0.1),
                  ),
                ),
                onPressed: () => null,
                child: Row(
                  children: [
                    SvgPicture.asset("assets/images/56.svg"),
                    SizedBox(width: reSize(20)),
                    Text(
                      "Scan Document",
                      style: TextStyle(
                        color: Theme.of(context).accentColor,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    )
                  ],
                ),
              ),
              Divider(
                color: Color(0xFFE8EAF0),
                height: 1,
              ),
              SizedBox(height: reSize(25)),
              Container(
                width: MediaQuery.of(context).size.width - 40,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Acceptable formats:',
                      style: TextStyle(
                        color: Color(0xFF000000),
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      'PDF - up to 15 Mb',
                      style: TextStyle(
                        color: Color(0xFF000000),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _importFilePhone() async {
    try {
      var result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (result != null) {
        if (result.files.first.size > 15000000) {
          showError('The file must not contain more than 15 Mb');
          return;
        }

        PlatformFile file = result.files.first;
        if (file.extension != 'pdf') {
          setState(() {});
          return;
        } else if (file.size > (7.5e+7 * 75).toInt()) {
          setState(() {});
          return;
        }

        await _sessionController.createSession(file);
        Get.back();
        Get.to(
          () => DocumentSetting(),
          transition: Transition.noTransition,
        );
      }
    } catch (err) {
      print(err);
      Get.back();
      showError(err);
    }
  }

  void _deleteSession() {
    try {
      _sessionController.deleteSession();
    } catch (err) {
      Get.to(
        ErrorPage(
          errorMessage: err.toString(),
          callback: () => Get.back(),
        ),
      );
    }
  }
}
