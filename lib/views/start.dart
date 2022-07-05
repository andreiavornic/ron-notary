import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_apns/apns.dart';
import 'package:flutter_svg/svg.dart';
import 'package:notary/controllers/payment.dart';

import 'package:notary/controllers/session.dart';
import 'package:notary/controllers/user.dart';
import 'package:notary/methods/resize_formatting.dart';
import 'package:notary/methods/show_error.dart';
import 'package:notary/utils/navigate.dart';
import 'package:notary/views/encrypt.dart';
import 'package:notary/views/home/start_session.dart';
import 'package:notary/views/purchase_cat.dart';
import 'package:notary/views/session_process.dart';
import 'package:notary/widgets/bottom_navigator.dart';
import 'package:notary/widgets/button_primary.dart';
import 'package:notary/widgets/button_primary_outline.dart';
import 'package:notary/widgets/network_connection.dart';
import 'package:notary/widgets/payment_btn.dart';
import 'package:notary/widgets/wrap_pages/loading_page.dart';
import 'package:provider/provider.dart';
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
  final PushConnector _connector = createPushConnector();

  @override
  void initState() {
    _loading = true;
    _userController = Provider.of<UserController>(context, listen: false);
    _sessionController = Provider.of<SessionController>(context, listen: false);

    _initNotification();
    super.initState();
  }

  _initNotification() async {
    try {
      await register();
      await _getData();
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    } catch (err) {
      print("Is error $err");
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
      showError(err, context);
    }
  }

  Future<void> register() async {
    print("register() => Executed!");
    try {
      _connector.requestNotificationPermissions();
      _connector.configure(
        onLaunch: (data) => onPush('onLaunch', data),
        onResume: (data) => onPush('onResume', data),
        onMessage: (data) => onPush('onMessage', data),
        //     onBackgroundMessage: _onBackgroundMessage,
      );
      _connector.token.addListener(() async {
        var token = _connector.token.value;
        print("token $token");
        await _userController.addTokenNotification(token);
      });
      if (mounted) {
        setState(() {});
      }
    } catch (e) {
      throw e;
    }
  }

  Future<dynamic> onPush(String name, RemoteMessage payload) async {
    if(!mounted) return;
    print("onPush name $name");
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
        case 'INITIAL_PURCHASE':
          await Provider.of<UserController>(context, listen: false).getUser();
          await Provider.of<PaymentController>(context, listen: false)
              .getTransactions();
          print("INITIAL_PURCHASE");
          break;
        case 'SUBSCRIPTION_RENEWED':
          await Provider.of<UserController>(context, listen: false).getUser();
          await Provider.of<PaymentController>(context, listen: false)
              .getTransactions();
          print("SUBSCRIPTION_RENEWED");
          break;
        case 'EXPIRATION':
          await Provider.of<UserController>(context, listen: false).getUser();
          print("EXPIRATION");
          break;
        case 'UPDATE_POINT':
          print("UPDATE_POINT");
          Provider.of<SessionController>(context, listen: false)
              .updatePoints(info);
          break;
        case 'UPDATE_ONE_POINT':
          print("UPDATE_ONE_POINT");
          Provider.of<SessionController>(context, listen: false)
              .updateOnePoint(info);
          break;
        case 'UPDATE_RECIPIENT':
          print("UPDATE_RECIPIENT");
          Provider.of<SessionController>(context, listen: false)
              .updateRecipients(info);
          break;
        default:
          break;
      }
    }
    return Future.value(true);
  }

  _getData() async {
    try {
      if (!mounted) return;
      await _userController.getUser();
      await _userController.getStamp();
      await _userController.getSignatures();
      await _sessionController.getSession();
    } catch (err) {
      print("Error __getData()");
      throw err;
    }
  }

  @override
  void dispose() {
    _connector.dispose();
    super.dispose();
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
                  BottomNavigator(
                    widget:
                        _controller.payment != null && !_controller.payment.paid
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
    if (_controller.user.promoCode != null && _controller.user.promoCode.ronsLeft != 0) {
      return StartSession();
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
                  callback: () => StateM(context).navTo(PurchaseCat()),
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
