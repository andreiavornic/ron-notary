import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_apns/flutter_apns.dart';
import 'package:flutter_svg/svg.dart';

import 'package:notary/controllers/session.dart';
import 'package:notary/controllers/user.dart';
import 'package:notary/methods/resize_formatting.dart';
import 'package:notary/methods/show_error.dart';
import 'package:notary/utils/navigate.dart';
import 'package:notary/views/encrypt.dart';
import 'package:notary/views/home/start_session.dart';
import 'package:notary/views/purchase_app.dart';
import 'package:notary/views/purchase_cat.dart';
import 'package:notary/views/session_process.dart';
import 'package:notary/widgets/bottom_navigator.dart';
import 'package:notary/widgets/button_primary.dart';
import 'package:notary/widgets/button_primary_outline.dart';
import 'package:notary/widgets/network_connection.dart';
import 'package:notary/widgets/payment_btn.dart';
import 'package:notary/widgets/wrap_pages/loading_page.dart';
import 'package:provider/provider.dart';
import '../widgets/payment_success.dart';
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
  bool _loading;
  UserController _userController;
  SessionController _sessionController;
  String _token;
  final PushConnector connector = createPushConnector();
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  @override
  void initState() {
    _loading = true;
    _userController = Provider.of<UserController>(
      context,
      listen: false,
    );
    _sessionController = Provider.of<SessionController>(
      context,
      listen: false,
    );

    _getData();
    super.initState();
  }

  _getSnackbar(context, payload, action) {
    final snackBar = SnackBar(
      content: Text(
        payload.notification?.title,
        style: TextStyle(fontSize: 12, color: Color(0xFF161617)),
      ),
      backgroundColor: Color(0xFFF6F6F9).withOpacity(0.9),
      behavior: SnackBarBehavior.floating,
      elevation: 6.0,
      duration: Duration(seconds: 10),
      action: action,
      margin: EdgeInsets.only(
        bottom: StateM(context).height() - 100,
        right: 20,
        left: 20,
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future<void> register() async {
    try {
      final connector = this.connector;
      connector.configure(
        onLaunch: (data) => onPush('onLaunch', data),
        onResume: (data) => onPush('onResume', data),
        onMessage: (data) => onPush('onMessage', data),
      );
      connector.requestNotificationPermissions();
      connector.token.addListener(() {
        _token = connector.token.value;
        if (mounted) setState(() {});
      });
    } catch (e) {}
  }

  Future<dynamic> onPush(String name, RemoteMessage payload) async {
    String os = Platform.operatingSystem;
    dynamic data = {"actionIdentifier": null, "info": {}};
    if (os == 'ios') {
      data = payload.data['data'];
    } else if (os == 'android') {
      data = json.decode(payload.data['data']);
    }
    var info = data['info'];
    final action = data['actionIdentifier'];
    if (action != null) {
      switch (action) {
        case 'RON_THREE':
          _getSnackbar(
              context,
              payload,
              SnackBarAction(
                label: 'Undo',
                textColor: Color(0xFF161617),
                onPressed: () {},
              ));
          break;
        case 'INITIAL_PURCHASE':
          StateM(context).navOff(PaymentSuccess());
          print("INITIAL_PURCHASE");
          break;
        case 'RENEWAL':
          _getSnackbar(
              context,
              "Your subscription was renewed",
              SnackBarAction(
                label: 'Undo',
                textColor: Color(0xFF161617),
                onPressed: () {},
              ));
          break;
        case 'PRODUCT_CHANGE':
          await _userController.getUser();
          print("PRODUCT_CHANGE");
          break;
        case 'CANCELLATION':
          await _userController.getUser();
          print("CANCELLATION");
          break;
        case 'EXPIRATION':
          _getSnackbar(
              context,
              payload,
              SnackBarAction(
                label: 'Buy more',
                textColor: Color(0xFF161617),
                onPressed: () => StateM(context).navTo(PurchaseApp()),
              ));
          print("EXPIRATION");
          break;
        case 'UPDATE_POINT':
          print("UPDATE_POINT");
          _sessionController.updatePoints(info);
          break;
        case 'UPDATE_RECIPIENT':
          print("UPDATE_RECIPIENT");
          _sessionController.updateRecipients(info);
          break;
        default:
          break;
      }
    }
    return Future.value(true);
  }

  _getData() async {
    try {
      await register();
      await _userController.getUser();
      await _userController.addTokenNotification(_token);
      await _userController.getStamp();
      await _userController.getSignatures();
      await _sessionController.getSession();
      _loading = false;
      setState(() {});
    } catch (err) {
      if (mounted) {
        showError(err, context);
        _loading = false;
        setState(() {});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<UserController, SessionController>(
        builder: (context, _controller, _sessionController, _) {
      if (_controller.user != null) {
        if (_sessionController.session != null) {
          if (_sessionController.session.state == 'ENCRYPTING') {
            return Encryption();
          } else if (_sessionController.session.state == 'START' ||
              _sessionController.session.state == 'IN_PROCESS') {
            return SessionProcess();
          }
        }
      }
      return NetworkConnection(
        Scaffold(
          body: LoadingPage(
            _loading,
            Container(
              width: StateM(context).width(),
              height: StateM(context).height(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Hello(),
                        _getView(_controller),
                      ],
                    ),
                  ),
                  if (_controller.payment != null)
                    BottomNavigator(
                      widget: _controller.payment.paid == false
                          ? Container()
                          : _getSessionExist(),
                    ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget _getView(UserController _controller) {
    if (_controller.notary == null) {
      return NoNotary();
    }
    if (_controller.certificate == null) {
      return CertificateUpload();
    }
    if (_controller.payment == null || !_controller.payment.paid) {
      return PaymentBtn();
    }
    if (_controller.payment != null && _controller.payment.ronAmount == 0) {
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
                  callback: () => StateM(context).navTo(PurchaseApp()),
                )
              ],
            ),
          ),
        ),
      );
    }
    return StartSession();
  }

  Widget _getSessionExist() {
    return Consumer<SessionController>(
      builder: (context, _controller, _) => _controller.session != null &&
              _controller.session.state != "CANCELLED" &&
              _controller.session.state != "FAILED" &&
              _controller.session.state != "ENCRYPTING"
          ? Column(
              children: [
                SizedBox(height: reSize(context, 40)),
                ButtonPrimaryOutline(
                  text: 'Discard Session',
                  callback: _deleteSession,
                ),
                SizedBox(
                  height: reSize(context, 10),
                ),
                ButtonPrimary(
                  text: 'Resume',
                  callback: _controller.session.state == "FINISHED"
                      ? () => StateM(context).navOff(Download())
                      : _controller.session.state == "IN_PROCESS"
                          ? () => StateM(context).navOff(SessionProcess())
                          : () => StateM(context).navTo(DocumentSetting()),
                ),
                SizedBox(
                  height: reSize(context, 35),
                ),
              ],
            )
          : Container(),
    );
  }

  void _deleteSession() async {
    try {
      _loading = true;
      setState(() {});
      await _sessionController.deleteSession();
      _loading = false;
      setState(() {});
    } catch (err) {
      _loading = false;
      setState(() {});
      StateM(context).navTo(ErrorPage(
        errorMessage: err.toString(),
        callback: () => Navigator.pop(context),
      ));
    }
  }
}
