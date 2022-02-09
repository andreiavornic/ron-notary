import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:notary/controllers/session.dart';
import 'package:notary/controllers/user.dart';
import 'package:notary/methods/resize_formatting.dart';
import 'package:notary/methods/show_error.dart';
import 'package:notary/services/socket_service.dart';
import 'package:notary/views/encrypt.dart';
import 'package:notary/views/home/start_session.dart';
import 'package:notary/views/session_process.dart';
import 'package:notary/views/settings/biling_plan.dart';
import 'package:notary/widgets/bottom_navigator.dart';
import 'package:notary/widgets/button_primary.dart';
import 'package:notary/widgets/button_primary_outline.dart';
import 'package:notary/widgets/network_connection.dart';
import 'package:notary/widgets/payment_btn.dart';
import 'package:notary/widgets/wrap_pages/loading_page.dart';
import 'document-setting.dart';
import 'download.dart';
import 'errors/error_page.dart';
import 'home/certificate_upload.dart';
import 'home/widgets/hello.dart';
import 'home/widgets/no_notary.dart';

class Start extends StatefulWidget {
  @override
  _StartState createState() => _StartState();
}

class _StartState extends State<Start> {
  UserController _userController = Get.put(UserController());
  SessionController _sessionController = Get.put(SessionController());
  final SocketService _socketService = Get.find<SocketService>();
  bool _loading;

  @override
  void initState() {
    print("Init Start()");
    _loading = true;
    _getData();
    super.initState();
  }

  void dispose() {
    if (_socketService.socket != null && _socketService.socket.connected) {
      _socketService.disconnect();
    }
    super.dispose();
  }

  _getData() async {
    try {
      await _userController.getUser();
      await _userController.getStamp();
      await _userController.getSignatures();
      await _sessionController.getSession();
      _socketService.socket.connect();
      _sessionController.reset();
      final prefs = GetStorage();
      String room = prefs.read("SOCKET_ROOM_SESSION");
      if (room == null) return;
      if (_socketService.socket != null && _socketService.socket.connected) {
        _socketService.disconnect();
      }
      _socketService.socket.connect();
      _socketService.socket.emit('joinRoom', room);
      _socketService.socket.on(
        'UPDATE_PAYMENT',
        (data) {
          print("UPDATE_PAYMENT $data");
          _userController.renewPayment(data);
          // Get.snackbar(
          //   "Billing Update",
          //   "Your billing and plan ws updated!",
          //   snackPosition: SnackPosition.BOTTOM,
          // );
        },
      );
      if (mounted) {
        _loading = false;
        setState(() {});
      }
    } catch (err) {
      _loading = false;
      setState(() {});
      showError(err);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<UserController>(builder: (_controller) {
      if (_controller.user.value != null) {
        if (_sessionController.session != null) {
          if (_sessionController.session.value?.state == 'ENCRYPTING') {
            return Encryption();
          } else if (_sessionController.session.value?.state == 'START' ||
              _sessionController.session.value?.state == 'IN_PROCESS') {
            return SessionProcess();
          }
        }
      }
      return NetworkConnection(
        widget: LoadingPage(
          _loading,
          Container(
            width: Get.width,
            height: Get.height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Hello(),
                      _getView(),
                    ],
                  ),
                ),
                BottomNavigator(
                  widget: _getSessionExist(),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _getView() {
    return GetBuilder<UserController>(builder: (_controller) {
      if (_controller.notary.value == null) {
        return NoNotary();
      }
      if (_controller.certificate.value == null) {
        return CertificateUpload();
      }
      if (_controller.payment.value == null) {
        return PaymentBtn();
      }
      if (_controller.payment.value != null &&
          _controller.payment.value.ronAmount == 0) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Container(
            child: Center(
              child: Column(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: Center(
                      child: SvgPicture.asset(
                        'assets/images/100.svg',
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                  Text(
                    "You have consumed the RON limit for this month, in order to continue add extra notarization",
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 30),
                  ButtonPrimaryOutline(
                    width: 232,
                    text: "Billing",
                    callback: () => Get.to(
                      () => BillingPlan(),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      }
      return StartSession();
    });
  }

  Widget _getSessionExist() {
    return GetBuilder<SessionController>(
      init: SessionController(),
      builder: (_controller) => _controller.session.value != null &&
              _controller.session.value.state != "CANCELLED" &&
              _controller.session.value.state != "FAILED" &&
              _controller.session.value.state != "ENCRYPTING"
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
                  callback: _controller.session.value.state == "FINISHED"
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
          : Container(),
    );
  }

  void _deleteSession() {
    try {
      _sessionController.deleteSession();
    } catch (err) {
      Get.to(
        () => ErrorPage(
          errorMessage: err.toString(),
          callback: () => Get.back(),
        ),
      );
    }
  }
}
