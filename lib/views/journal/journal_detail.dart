import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:notary/controllers/journal.dart';
import 'package:notary/methods/resize_formatting.dart';
import 'package:notary/methods/show_error.dart';
import 'package:notary/models/journal.dart';
import 'package:notary/views/errors/error_page.dart';
import 'package:notary/widgets/loading.dart';
import 'package:notary/widgets/network_connection.dart';

import 'item_data.dart';
import 'recipient_item.dart';

class JournalDetail extends StatefulWidget {
  final String id;

  JournalDetail(this.id);

  @override
  _JournalDetailState createState() => _JournalDetailState();
}

class _JournalDetailState extends State<JournalDetail> {
  final JournalController _journalController = Get.put(JournalController());
  Journal _journal;
  bool _isDownloadPdf;
  bool _isDownloadEvent;
  bool _isDownloadVideo;
  String status;
  int size;

  initState() {
    _isDownloadPdf = false;
    _isDownloadEvent = false;
    _isDownloadVideo = false;
    super.initState();
  }

  Future<Journal> getJournal() async {
    try {
      var data = await _journalController.getJournalById(widget.id);
      Journal journal = Journal.fromJson(data['journal']);
      status = data['status'];
      size = data['size'];
      return journal;
    } catch (err) {
      throw err;
    }
  }

  @override
  Widget build(BuildContext context) {
    return NetworkConnection(
      widget: Container(
        height: Get.height,
        child: SingleChildScrollView(
          child: FutureBuilder<Journal>(
              future: getJournal(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  ErrorPage(errorMessage: snapshot.error.toString());
                }
                if (snapshot.connectionState == ConnectionState.done) {
                  _journal = snapshot.data;
                  if (snapshot.hasError) {
                    return Container(
                      child: Center(
                        child: Text(snapshot.error.toString()),
                      ),
                    );
                  }
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: reSize(70)),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(25),
                          child: Row(
                            children: [
                              Container(
                                width: reSize(24),
                                height: reSize(24),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                child: SvgPicture.asset("assets/images/96.svg"),
                              ),
                              Container(
                                width: Get.width - 60,
                                child: Text(
                                  "${_journal.name}",
                                  style: TextStyle(
                                    color: Color(0xFF000000),
                                    fontSize: 24,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          onTap: () => Get.back(),
                        ),
                      ),
                      SizedBox(height: reSize(4)),
                      Padding(
                        padding: const EdgeInsets.only(left: 25.0),
                        child: Container(
                          width: reSize(60),
                          height: reSize(20),
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.circular(2),
                          ),
                          child: Center(
                            child: Text(
                              "${_journal.session.state[0].toUpperCase()}${_journal.session.state.substring(1).toLowerCase()}",
                              style: TextStyle(
                                color: Color(0xFF161617),
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: reSize(30)),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Document Title: ${_journal.session.sessionFileName}',
                              style: TextStyle(
                                fontSize: 16,
                                color: Color(0xFF161617),
                              ),
                            ),
                            SizedBox(
                              height: reSize(5),
                            ),
                            Text(
                              _journal.session != null
                                  ? 'Type of Notarization: ${_journal.session.typeNotarization.name}'
                                  : "No type of Notarization ",
                              style: TextStyle(
                                fontSize: 16,
                                color: Color(0xFF161617),
                              ),
                            ),
                            SizedBox(height: reSize(30)),
                            ItemData(
                              'Date',
                              "${DateFormat('MMM dd, yyyy, hh:mm a').format(_journal.created)} (${DateTime.now().timeZoneName} Time)",
                              false,
                            ),
                            for (var i = 0;
                                i <= _journal.recipients.length - 1;
                                i++)
                              Container(
                                child: RecipientItem(_journal.recipients[i]),
                              ),
                            ItemData(
                              'Fee:',
                              '\$${_journal.fee}',
                              true,
                            ),
                            SizedBox(height: reSize(20)),
                            _journal.session.state == 'CANCELLED'
                                ? Container()
                                : _isDownloadPdf
                                    ? Container(
                                        height: reSize(50),
                                        child: Center(
                                            child: LinearProgressIndicator(
                                          backgroundColor:
                                              Theme.of(context).primaryColor,
                                        )),
                                      )
                                    : TextButton(
                                        onPressed: () => _openPdf(
                                          _journal.session.encryptedFile,
                                        ),
                                        style: ButtonStyle(
                                          padding: MaterialStateProperty.all(
                                            EdgeInsets.zero,
                                          ),
                                          shape: MaterialStateProperty.all<
                                              RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(4.0),
                                            ),
                                          ),
                                          overlayColor:
                                              MaterialStateProperty.all(
                                            Color(0xFF000000).withOpacity(0.1),
                                          ),
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                            Color(0xFFF6F6F9),
                                          ),
                                        ),
                                        child: Container(
                                          height: reSize(50),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(4),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 18,
                                            ),
                                            child: Row(
                                              children: [
                                                Text(
                                                  'Document',
                                                  style: TextStyle(
                                                    color: Color(0xFF161617),
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                                SvgPicture.asset(
                                                  'assets/images/111.svg',
                                                  width: reSize(16),
                                                  height: reSize(16),
                                                )
                                              ],
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                            ),
                                          ),
                                        ),
                                      ),
                            if (_journal.stepPdf != null)
                              _isDownloadEvent
                                  ? Container(
                                      height: reSize(50),
                                      child: Center(
                                          child: LinearProgressIndicator(
                                        backgroundColor:
                                            Theme.of(context).primaryColor,
                                      )),
                                    )
                                  : Column(
                                      children: [
                                        SizedBox(height: reSize(10)),
                                        if (_journal.stepPdf != 'step')
                                          TextButton(
                                            onPressed: () =>
                                                _openStepPdf(_journal.id),
                                            style: ButtonStyle(
                                              padding:
                                                  MaterialStateProperty.all(
                                                EdgeInsets.zero,
                                              ),
                                              shape: MaterialStateProperty.all<
                                                  RoundedRectangleBorder>(
                                                RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          4.0),
                                                ),
                                              ),
                                              overlayColor:
                                                  MaterialStateProperty.all(
                                                Color(0xFF000000)
                                                    .withOpacity(0.1),
                                              ),
                                              backgroundColor:
                                                  MaterialStateProperty.all(
                                                Color(0xFFF6F6F9),
                                              ),
                                            ),
                                            child: Container(
                                              height: reSize(50),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  horizontal: 18,
                                                ),
                                                child: Row(
                                                  children: [
                                                    Text(
                                                      'Transaction Level Key Event',
                                                      style: TextStyle(
                                                        color:
                                                            Color(0xFF161617),
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      ),
                                                    ),
                                                    SvgPicture.asset(
                                                      'assets/images/111.svg',
                                                      width: reSize(16),
                                                      height: reSize(16),
                                                    )
                                                  ],
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                ),
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                            SizedBox(height: reSize(10)),
                            _journal.session.state == 'CANCELLED'
                                ? Container()
                                : status == null
                                    ? Container(
                                        height: reSize(50),
                                        decoration: BoxDecoration(
                                          color: Color(0xFFFC563D)
                                              .withOpacity(0.1),
                                          borderRadius:
                                              BorderRadius.circular(4),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 18,
                                          ),
                                          child: Center(
                                            child: Text(
                                              "No video for this session",
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Color(0xFFFC563D),
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                    : _isDownloadVideo
                                        ? Container(
                                            height: reSize(50),
                                            child: Center(
                                                child: LinearProgressIndicator(
                                              backgroundColor: Theme.of(context)
                                                  .primaryColor,
                                            )),
                                          )
                                        : TextButton(
                                            onPressed: status == 'completed'
                                                ? _getVideo
                                                : null,
                                            style: ButtonStyle(
                                              padding:
                                                  MaterialStateProperty.all(
                                                EdgeInsets.zero,
                                              ),
                                              shape: MaterialStateProperty.all<
                                                  RoundedRectangleBorder>(
                                                RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          4.0),
                                                ),
                                              ),
                                              overlayColor:
                                                  MaterialStateProperty.all(
                                                Color(0xFF000000)
                                                    .withOpacity(0.1),
                                              ),
                                              backgroundColor:
                                                  MaterialStateProperty.all(
                                                Color(0xFFF6F6F9),
                                              ),
                                            ),
                                            child: Container(
                                              height: reSize(50),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  horizontal: 18,
                                                ),
                                                child: Row(
                                                  children: [
                                                    Text(
                                                      status != 'completed'
                                                          ? "Video in progress"
                                                          : 'Video confirmation',
                                                      style: TextStyle(
                                                        color: status !=
                                                                'completed'
                                                            ? Color(0xFF161617)
                                                                .withOpacity(
                                                                    0.5)
                                                            : Color(0xFF161617),
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        fontSize: 14,
                                                      ),
                                                    ),
                                                    SvgPicture.asset(
                                                      'assets/images/112.svg',
                                                      width: reSize(16),
                                                      height: reSize(16),
                                                      color: status !=
                                                              'completed'
                                                          ? Color(0xFF161617)
                                                              .withOpacity(0.5)
                                                          : Color(0xFF161617),
                                                    )
                                                  ],
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                ),
                                              ),
                                            ),
                                          ),
                          ],
                        ),
                      )
                    ],
                  );
                } else {
                  return Container(
                    height: Get.height,
                    child: Center(
                      child: Loading(),
                    ),
                  );
                }
              }),
        ),
      ),
    );
  }

  _openPdf(String encryptedPDF) async {
    try {
      _isDownloadPdf = true;
      setState(() {});
      await _journalController.getJournalDocument(encryptedPDF);
      _isDownloadPdf = false;
      setState(() {});
    } catch (err) {
      showError(err);
      _isDownloadPdf = false;
      setState(() {});
    }
  }

  _getVideo() async {
    _isDownloadVideo = true;
    setState(() {});
    try {
      await _journalController.getJournalMedia(_journal);
      _isDownloadVideo = false;
      setState(() {});
    } catch (err) {
      showError(err);
      _isDownloadVideo = false;
      setState(() {});
    }
  }

  _openStepPdf(String id) async {
    try {
      _isDownloadEvent = true;
      setState(() {});
      await _journalController.getJournalStep(id);
      _isDownloadEvent = false;
      setState(() {});
    } catch (err) {
      showError(err);
      _isDownloadEvent = false;
      setState(() {});
    }
  }
}
