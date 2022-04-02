import 'dart:async';

import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';

import '../methods/resize_formatting.dart';
import '../utils/navigate.dart';

class NetworkConnection extends StatefulWidget {
  final Widget widget;

  const NetworkConnection(this.widget);

  @override
  State<NetworkConnection> createState() => _NetworkConnectionState();
}

class _NetworkConnectionState extends State<NetworkConnection> {
  ConnectivityResult _connectionStatus;
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult> _connectivitySubscription;

  initState() {
    super.initState();
    initConnectivity();

    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initConnectivity() async {
    ConnectivityResult result;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      print('Couldn\'t check connectivity status $e');
      return;
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    setState(() {
      _connectionStatus = result;
    });
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _connectionStatus == null
        ? widget.widget
        : _connectionStatus == ConnectivityResult.none
            ? Scaffold(
                body: Container(
                  width: StateM(context).width(),
                  height: StateM(context).height(),
                  decoration: BoxDecoration(
                    color: Color(0xFFFFFFFF).withOpacity(0.95),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: reSize(context, 80),
                            height: reSize(context, 80),
                            decoration: BoxDecoration(
                              color: Color(0xFFFC563D),
                              borderRadius: BorderRadius.circular(80),
                            ),
                            child: Center(
                              child: SvgPicture.asset(
                                'assets/images/113.svg',
                              ),
                            ),
                          ),
                          SizedBox(height: reSize(context, 40)),
                          Text(
                            "Oops! Something went wrong!",
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF20303C),
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: reSize(context, 40)),
                          Text(
                            "Your internet connection is poor. Please check your settings and return",
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
                ),
              )
            : widget.widget;
  }
}
