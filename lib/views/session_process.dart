import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:notary/controllers/recipient.dart';
import 'package:notary/controllers/session.dart';
import 'package:notary/controllers/socket.dart';
import 'package:notary/methods/resize_formatting.dart';
import 'package:notary/views/process/confirm_delete.dart';
import 'package:notary/views/process/list_recipients.dart';
import 'package:notary/views/process/video_session.dart';
import 'package:notary/widgets/button_primary.dart';
import 'package:notary/widgets/modals/modal_container.dart';
import 'package:share/share.dart';

class SessionProcess extends StatefulWidget {
  @override
  _SessionProcessState createState() => _SessionProcessState();
}

class _SessionProcessState extends State<SessionProcess> {
  SessionController _sessionController = Get.put(SessionController());
  RecipientController _recipientController = Get.put(RecipientController());
  SocketController _socketController = Get.put(SocketController());
  bool _smaller;

  @override
  void initState() {
    _smaller = Get.height < 670;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Container(
          width: Get.width,
          height: Get.height,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(height: 0),
              Container(
                height: _smaller ? 0 : reSize(80),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Positioned(
                      top: _smaller ? reSize(-140) : -60,
                      left: -5,
                      child: Container(
                        height: reSize(100),
                        width: MediaQuery.of(context).size.width - 40,
                        child: Lottie.asset(
                          'assets/anime/loader5.json',
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: reSize(40),
              ),
              Column(
                children: [
                  Text(
                    "Starting Session...",
                    style: TextStyle(
                      color: Color(0xFF000000),
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      letterSpacing: -1,
                    ),
                  ),
                  SizedBox(height: reSize(5)),
                  Text(
                    "Waiting for all participants to join",
                    style: TextStyle(
                      color: Color(0xFF494949),
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              Container(
                height: reSize(78),
                width: Get.width - reSize(30),
                child: ListRecipients(),
              ),
              Container(
                height: 1,
                color: Color(0xFFE8EAF0),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Ronary Session Code',
                    style: TextStyle(
                      color: Color(0xFF161617),
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      letterSpacing: -1,
                    ),
                  ),
                  SizedBox(height: reSize(10)),
                  Text(
                    'This Code was sent to all participants. You may\nshare it again',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF999999),
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(height: reSize(20)),
                  Text(
                    _sessionController.session.value.sessionToken,
                    style: TextStyle(
                      color: Color(0xFF161617),
                      fontWeight: FontWeight.w600,
                      fontSize: 24,
                      letterSpacing: 8,
                    ),
                  ),
                  SizedBox(height: reSize(20)),
                  TextButton(
                    onPressed: _shareToken,
                    style: ButtonStyle(
                      padding: MaterialStateProperty.all(
                        EdgeInsets.zero,
                      ),
                      overlayColor: MaterialStateProperty.all(
                          Theme.of(context).accentColor.withOpacity(0.03)),
                    ),
                    child: Container(
                        width: reSize(128),
                        height: reSize(40),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Color(0xFF20303C),
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(2),
                        ),
                        child: Center(
                          child: Text(
                            'Share',
                            style: TextStyle(
                              color: Color(0xFF000000),
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        )),
                  )
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () => modalContainer(
                      ConfirmDelete(
                        callback: _deleteSession,
                        btnTxt: 'Cancel Session',
                        icon: 107,
                        description: Text(
                          'If you Cancel, you will be required to\nstart over',
                          style: TextStyle(
                            color: Color(0xFF494949),
                            fontSize: 14,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    child: Text(
                      "Cancel Session",
                      style: TextStyle(
                        color: Color(0xFF161617),
                        fontSize: 14,
                      ),
                    ),
                  ),
                  SizedBox(height: reSize(15)),
                  Container(
                    child: ButtonPrimary(
                      // callback: _recipientController.recipients.every(
                      //         (element) => element.states.last == "LOGGED")
                      //     ? _goInProcess
                      //     : null,
                      callback: _goInProcess,
                      text: "Start Session",
                    ),
                  ),
                  SizedBox(height: _smaller ? 20 : reSize(40)),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  _goInProcess() async {
    Get.to(
      () => VideoSession(),
      transition: Transition.noTransition,
    );
  }

  _shareToken() {
    Share.share(
      'Please enter session code: ${_sessionController.session.value.sessionToken}',
      subject: 'Session Token',
    );
  }

  _deleteSession() async {
    Get.back();
  }
}
