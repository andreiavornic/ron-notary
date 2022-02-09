import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:notary/methods/resize_formatting.dart';
import 'package:notary/services/network_manager.dart';

class NetworkConnection extends StatelessWidget {
  final Widget widget;

  const NetworkConnection({Key key, this.widget}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final GetXNetworkManager _networkManager = Get.find<GetXNetworkManager>();

    return GetBuilder<GetXNetworkManager>(
      builder: (builder) => Scaffold(
        body: Container(
            child: (_networkManager.connectionType == 0)
                ? Container(
                    width: Get.width,
                    height: Get.height,
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
                              width: reSize(80),
                              height: reSize(80),
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
                            SizedBox(height: reSize(40)),
                            Text(
                              "Oops! Something went wrong!",
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF20303C),
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: reSize(40)),
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
                  )
                : widget),
      ),
    );
  }
}
