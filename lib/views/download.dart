import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:notary/controllers/session.dart';
import 'package:notary/methods/resize_formatting.dart';
import 'package:notary/methods/show_error.dart';
import 'package:notary/utils/navigate.dart';
import 'package:notary/views/start.dart';
import 'package:notary/widgets/button_primary.dart';
import 'package:notary/widgets/button_primary_outline.dart';
import 'package:notary/widgets/loading.dart';
import 'package:notary/widgets/loading_page.dart';
import 'package:notary/widgets/network_connection.dart';
import 'package:provider/provider.dart';

class Download extends StatefulWidget {
  @override
  _DownloadState createState() => _DownloadState();
}

class _DownloadState extends State<Download> {
  bool _isDownloaded;
  bool _loading;

  @override
  void initState() {
    _isDownloaded = false;
    _loading = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return NetworkConnection(
      Scaffold(
        body: LoadingPage(
          _loading,
          Container(
            width: StateM(context).width(),
            height: StateM(context).height(),
            child: Consumer<SessionController>(
              builder: (context, _controller, _) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      Container(height: reSize(context, 40)),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Download",
                              style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                  fontSize: 28,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: -1),
                            ),
                            SizedBox(height: reSize(context, 60)),
                            _isDownloaded
                                ? Container(
                                    height: reSize(context, 165),
                                    width: reSize(context, 125),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        width: 1,
                                        color:
                                            Color(0xFF000000).withOpacity(0.07),
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
                                              child: Image.memory(
                                                  snapshot.data.bytes),
                                            ),
                                            onTap: _controller.openFile,
                                          );
                                        }
                                        if (snapshot.hasError) {
                                          return Container(
                                            height: reSize(context, 80),
                                            width: reSize(context, 80),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(50)),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Center(
                                                child: Text(
                                                  snapshot.error.toString(),
                                                  style:
                                                      TextStyle(fontSize: 10),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            ),
                                          );
                                        }
                                        return Container(
                                          height: reSize(context, 80),
                                          width: reSize(context, 80),
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
                                    height: reSize(context, 80),
                                    width: reSize(context, 80),
                                    decoration: BoxDecoration(
                                        color: Theme.of(context).primaryColor,
                                        borderRadius:
                                            BorderRadius.circular(50)),
                                    child: Center(
                                      child: SvgPicture.asset(
                                        'assets/images/110.svg',
                                        height: reSize(context, 30),
                                      ),
                                    ),
                                  ),
                            SizedBox(
                                height: StateM(context).height() < 670
                                    ? 20
                                    : reSize(context, 50)),
                            Text(
                              "${_controller.sessionFileName}",
                              style: TextStyle(
                                color: Color(0xFF161617),
                                fontSize: 16,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: reSize(context, 10)),
                            if (_controller.fileEncrypted != null)
                              Text(
                                "${(_controller.fileEncrypted.lengthSync() / 1e+6).toStringAsFixed(3)} Mb",
                                style: TextStyle(
                                  color: Color(0xFF000000),
                                  fontSize: 14,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            SizedBox(height: reSize(context, 50)),
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
                                SizedBox(height: reSize(context, 15)),
                                ButtonPrimary(
                                  text: "Go Homescreen",
                                  callback: () =>
                                      StateM(context).navOff(Start()),
                                ),
                                SizedBox(
                                    height: StateM(context).height() < 670
                                        ? 20
                                        : reSize(context, 40)),
                              ],
                            )
                          : Column(
                              children: [
                                ButtonPrimary(
                                  text: "Download",
                                  callback: _downloadFile,
                                ),
                                SizedBox(
                                    height: StateM(context).height() < 670
                                        ? 20
                                        : reSize(context, 40)),
                              ],
                            ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  _downloadFile() async {
    try {
      _loading = true;
      setState(() {});
      await Provider.of<SessionController>(context, listen: false)
          .downloadFile();
      _isDownloaded = true;
      _loading = false;
      setState(() {});
    } catch (err) {
      _loading = false;
      setState(() {});
      showError(err, context);
    }
  }

  _onShare() async {
    await Provider.of<SessionController>(context, listen: false).shareFile();
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
          SizedBox(height: reSize(context, 20)),
          Text(
            "Notarized document, video recording and session details are saved in eJournal Log",
            style: TextStyle(
              color: Color(0xFF494949),
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: reSize(context, 40)),
        ],
      );
    });
  }
}
