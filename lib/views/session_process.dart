import 'package:flutter/material.dart';
import 'package:focus_detector/focus_detector.dart';

import 'package:lottie/lottie.dart';
import 'package:notary/controllers/session.dart';
import 'package:notary/methods/resize_formatting.dart';
import 'package:notary/methods/show_error.dart';
import 'package:notary/models/recipient.dart';
import 'package:notary/utils/navigate.dart';
import 'package:notary/views/process/confirm_delete.dart';
import 'package:notary/views/process/list_recipients.dart';
import 'package:notary/views/process/video_session.dart';
import 'package:notary/widgets/button_primary.dart';
import 'package:notary/widgets/loading_page.dart';
import 'package:notary/widgets/modals/modal_container.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';

import '../widgets/network_connection.dart';
import 'start.dart';
import 'package:camera/camera.dart';

class SessionProcess extends StatefulWidget {
  @override
  _SessionProcessState createState() => _SessionProcessState();
}

class _SessionProcessState extends State<SessionProcess> {
  bool _loading;
  SessionController _sessionController;
  List<CameraDescription> cameras;
  CameraController controller;

  @override
  void initState() {
    super.initState();
    _loading = true;
    _sessionController = Provider.of<SessionController>(context, listen: false);
    _getSession();
  }

  Future<void> _getSession() async {
    try {
      await _sessionController.getSession();
      if (mounted) {
        _loading = false;
        setState(() {});
      }
    } catch (err) {
      _loading = false;
      showError(err, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return NetworkConnection(
      FocusDetector(
        onFocusGained: () async {
          await _getSession();
        },
        onVisibilityGained: () async {
          await _getSession();
        },
        onFocusLost: () {},
        onVisibilityLost: () {},
        onForegroundLost: () {},
        onForegroundGained: () {},
        child: LoadingPage(
          _loading,
          Consumer<SessionController>(
            builder: (context, _controller, _) {
              List<Recipient> _recipients = _controller.recipients;
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  width: StateM(context).width() - 40,
                  height: StateM(context).height(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(height: 0),
                      Container(
                        height: StateM(context).height() < 670
                            ? 0
                            : reSize(context, 80),
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Positioned(
                              top: StateM(context).height() < 670
                                  ? reSize(context, -140)
                                  : -60,
                              left: -5,
                              child: Container(
                                height: reSize(context, 100),
                                width: StateM(context).width() - 40,
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
                        height: reSize(context, 40),
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
                          SizedBox(height: reSize(context, 5)),
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
                        height: reSize(context, 78),
                        width: StateM(context).width() - reSize(context, 30),
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
                          SizedBox(height: reSize(context, 10)),
                          Text(
                            'This Code was sent to all participants. You may\nshare it again',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color(0xFF999999),
                              fontSize: 14,
                            ),
                          ),
                          SizedBox(height: reSize(context, 20)),
                          Text(
                            "${_controller.session?.sessionToken}",
                            style: TextStyle(
                              color: Color(0xFF161617),
                              fontWeight: FontWeight.w600,
                              fontSize: 24,
                              letterSpacing: 8,
                            ),
                          ),
                          SizedBox(height: reSize(context, 20)),
                          TextButton(
                            onPressed: _shareToken,
                            style: ButtonStyle(
                              padding: MaterialStateProperty.all(
                                EdgeInsets.zero,
                              ),
                              overlayColor: MaterialStateProperty.all(
                                  Theme.of(context)
                                      .colorScheme
                                      .secondary
                                      .withOpacity(0.03)),
                            ),
                            child: Container(
                                width: reSize(context, 128),
                                height: reSize(context, 40),
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
                            onTap: () => modalContainerSimple(
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
                                context),
                            child: Text(
                              "Cancel Session",
                              style: TextStyle(
                                color: Color(0xFF161617),
                                fontSize: 14,
                              ),
                            ),
                          ),
                          SizedBox(height: reSize(context, 15)),
                          Container(
                            child: ButtonPrimary(
                              callback: _recipients.every((element) =>
                                      element.states.last == "LOGGED")
                                  ? _goInProcess
                                  : null,
                              // callback: _goInProcess,
                              text: "Start Session",
                            ),
                          ),
                          SizedBox(
                              height: StateM(context).height() < 670
                                  ? 20
                                  : reSize(context, 40)),
                        ],
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  // Future<void> _setupCamera() async {
  //   try {
  //     // initialize cameras.
  //     cameras = await availableCameras();

  //     // initialize camera controllers.
  //     controller = new CameraController(cameras[1], ResolutionPreset.medium);
  //     print(controller);
  //     await controller.initialize();

  //   } on CameraException catch (_) {
  //     debugPrint("Some error occured!");
  //   }
  // }

  _goInProcess() async {
    try {
      _loading = true;
      setState(() {});
      // await _setupCamera();
      // _loading = false;
      // setState(() {});
      // return;

      await _sessionController.getSession();
      await _sessionController.processSession();
      StateM(context).navTo(VideoSession());
      _loading = false;
      setState(() {});
    } catch (err) {
      _loading = false;
      setState(() {});
      showError(err, context);
    }
  }

  _shareToken() {
    Share.share(
      'Please enter session code: ${_sessionController.session.sessionToken}',
      subject: 'Session Token',
    );
  }

  _deleteSession() async {
    _loading = true;
    setState(() {});
    Navigator.pop(context);
    try {
      await _sessionController.cancelSession();
      StateM(context).navOff(Start());
      _loading = false;
      setState(() {});
    } catch (err) {
      _loading = false;
      setState(() {});
      showError(err, context);
    }
  }
}
