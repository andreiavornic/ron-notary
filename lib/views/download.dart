import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:notary/controllers/session.dart';
import 'package:notary/methods/resize_formatting.dart';
import 'package:notary/methods/show_error.dart';
import 'package:notary/widgets/button_primary.dart';
import 'package:notary/widgets/button_primary_outline.dart';
import 'package:notary/widgets/loading.dart';
import 'package:share/share.dart';

import 'home.dart';

class Download extends StatefulWidget {
  @override
  _DownloadState createState() => _DownloadState();
}

class _DownloadState extends State<Download> {
  bool _isDownloaded;

  SessionController _sessionController = Get.put(SessionController());

  @override
  void initState() {
    _isDownloaded = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: Get.width,
        height: Get.height,
        child: GetBuilder<SessionController>(
          init: SessionController(),
          builder: (_controller) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  Container(height: reSize(40)),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Download",
                          style: TextStyle(
                              color: Theme.of(context).accentColor,
                              fontSize: 28,
                              fontWeight: FontWeight.w700,
                              letterSpacing: -1),
                        ),
                        SizedBox(height: reSize(60)),
                        _isDownloaded
                            ? Container(
                                height: reSize(165),
                                width: reSize(125),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    width: 1,
                                    color: Color(0xFF000000).withOpacity(0.07),
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: FutureBuilder<MemoryImage>(
                                  future: _controller.formatImage(),
                                  // a previously-obtained Future<String> or null
                                  builder: (BuildContext context,
                                      AsyncSnapshot<MemoryImage> snapshot) {
                                    if (snapshot.hasData) {
                                      return InkWell(
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          child:
                                              Image.memory(snapshot.data.bytes),
                                        ),
                                        onTap: _controller.openFile,
                                      );
                                    }
                                    if (snapshot.hasError) {
                                      return Container(
                                        height: reSize(80),
                                        width: reSize(80),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(50)),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Center(
                                            child: Text(
                                              snapshot.error.toString(),
                                              style: TextStyle(fontSize: 10),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ),
                                      );
                                    }
                                    return Container(
                                      height: reSize(80),
                                      width: reSize(80),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(50)),
                                      child: Center(
                                        child: Loading(),
                                      ),
                                    );
                                  },
                                ),
                              )
                            : Container(
                                height: reSize(80),
                                width: reSize(80),
                                decoration: BoxDecoration(
                                    color: Theme.of(context).primaryColor,
                                    borderRadius: BorderRadius.circular(50)),
                                child: Center(
                                  child: SvgPicture.asset(
                                    'assets/images/110.svg',
                                    height: reSize(30),
                                  ),
                                ),
                              ),
                        SizedBox(height: Get.height < 670 ? 20 : reSize(50)),
                        Text(
                          "${_controller.session.value?.sessionFileName}",
                          style: TextStyle(
                            color: Color(0xFF161617),
                            fontSize: 16,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: reSize(10)),
                        Text(
                          _controller.fileEncrypted.value != null
                              ? "${(_controller.fileEncrypted.value.lengthSync() / 1e+6).toStringAsFixed(3)} Mb"
                              : "0 Mb",
                          style: TextStyle(
                            color: Color(0xFF000000),
                            fontSize: 14,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: reSize(50)),
                      ],
                    ),
                  ),
                  _getTextData(),
                  _isDownloaded
                      ? Column(
                          children: [
                            ButtonPrimaryOutline(
                              text: "Share Document",
                              callback: () => _onShare(),
                            ),
                            SizedBox(height: reSize(15)),
                            ButtonPrimary(
                              text: "Go Homescreen",
                              callback: () => Get.offAll(
                                () => HomePage(),
                                transition: Transition.noTransition,
                              ),
                            ),
                            SizedBox(
                                height: Get.height < 670 ? 20 : reSize(40)),
                          ],
                        )
                      : Column(
                          children: [
                            ButtonPrimary(
                              text: "Download",
                              callback: _downloadFile,
                            ),
                            SizedBox(
                                height: Get.height < 670 ? 20 : reSize(40)),
                          ],
                        ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  _downloadFile() async {
    try {
      await _sessionController.downloadFile();
      _isDownloaded = true;
      setState(() {});
    } catch (err) {
      // showError(err);
    }
  }

  _onShare() async {
    await _sessionController.shareFile();
  }

  _getTextData() {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      return Column(
        children: [
          Text(
            "Download",
            style: TextStyle(
              color: Color(0xFF161617),
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: reSize(20)),
          Text(
            "Notarized document, video recording and session details are saved in eJournal Log",
            style: TextStyle(
              color: Color(0xFF494949),
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: reSize(40)),
        ],
      );
    });
  }
}
