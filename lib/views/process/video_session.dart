import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:notary/controllers/point.dart';
import 'package:notary/controllers/recipient.dart';
import 'package:notary/controllers/session.dart';
import 'package:notary/controllers/user.dart';
import 'package:notary/methods/resize_formatting.dart';
import 'package:notary/methods/show_error.dart';
import 'package:notary/models/recipient.dart';
import 'package:notary/twilio/controller/twilio.dart';
import 'package:notary/twilio/views/participant.dart';
import 'package:notary/views/tags/document_tag.dart';
import 'package:notary/widgets/black_loading.dart';
import 'package:notary/widgets/btn_sign.dart';
import 'package:notary/widgets/button_primary.dart';
import 'package:notary/widgets/loading.dart';
import 'package:notary/widgets/title_page.dart';
import 'package:avatar_glow/avatar_glow.dart';

import '../encrypt.dart';

class VideoSession extends StatefulWidget {
  @override
  _VideoSessionState createState() => _VideoSessionState();
}

class _VideoSessionState extends State<VideoSession> {
  SessionController _sessionController = Get.put(SessionController());
  RecipientController _recipientController = Get.put(RecipientController());
  PointController _pointController = Get.put(PointController());
  UserController _userController = Get.put(UserController());
  TwilioController _twilioController = Get.put(TwilioController());

  bool _documentIsActive;

  @override
  void initState() {
    _documentIsActive = true;
    _connectToTwilio();
    super.initState();
  }

  _connectToTwilio() async {
    try {
      await _sessionController.processSession();
      String roomName = _sessionController.session.value.twilioRoomName;
      await _twilioController.connectToRoom(roomName);
    } catch (err) {
      Get.showSnackbar(
        new GetBar(
          icon: SvgPicture.asset(
            'assets/images/89.svg',
          ),
          titleText: Text(
            "Error",
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF161616),
              fontWeight: FontWeight.w600,
            ),
          ),
          messageText: Text(
            err.toString(),
            style: TextStyle(fontSize: 12, color: Color(0xFF161616)),
          ),
          margin: EdgeInsets.symmetric(vertical: 20),
          maxWidth: Get.width - 40,
          padding: EdgeInsets.all(20),
          borderRadius: 5,
          backgroundColor: Color(0xFFF5F6F9),
          duration: Duration(
            seconds: 3,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: Get.height,
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: TitlePage(
                    title: "Live Session",
                    description: "Follow RON guidelines",
                  ),
                ),
                _cancelButton()
              ],
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Color(0xFFF1F1F1),
                    border: Border.all(
                      color: Color(0xFFEDEDED),
                      width: 1,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Column(
                      children: [
                        Expanded(
                          child: Stack(
                            children: [
                              if (_documentIsActive)
                                Container(
                                  height: 81,
                                ),
                              _documentIsActive
                                  ? Center(
                                      child: Padding(
                                        padding: _documentIsActive
                                            ? const EdgeInsets.only(top: 80)
                                            : const EdgeInsets.only(top: 0),
                                        child: DocumentTag(
                                          addPoint: null,
                                          updatePoint: null,
                                          checkPoint: null,
                                        ),
                                      ),
                                    )
                                  : Container(
                                      width: Get.width - 40,
                                      child: Center(
                                        child: Loading(),
                                      ),
                                    ),
                              Positioned(
                                left: 0,
                                top: 0,
                                child: Column(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        color: !_documentIsActive
                                            ? Color(0xFF000000)
                                                .withOpacity(0.56)
                                            : Color(0xFFF6F6F9),
                                      ),
                                      child: Container(
                                        height: reSize(81),
                                        width:
                                            MediaQuery.of(context).size.width -
                                                reSize(60),
                                        child: Row(
                                          children: [
                                            SizedBox(width: reSize(15)),
                                            _getDoc(),
                                            SizedBox(width: reSize(15)),
                                            _getRecipients(),
                                          ],
                                        ),
                                      ),
                                      width: MediaQuery.of(context).size.width -
                                          40,
                                    ),
                                    _documentIsActive
                                        ? Container(
                                            height: 1,
                                            color: Color(0xFFEDEDED),
                                          )
                                        : Container(),
                                  ],
                                ),
                              ),
                              _getStamp(),
                              _getSign(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: reSize(15)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ButtonPrimary(
                callback: _finishSession,
                text: "Finish",
              ),
            ),
            SizedBox(height: Get.height < 670 ? 20 : reSize(40)),
          ],
        ),
      ),
    );
  }

  Widget _getStamp() {
    var notarySigns = _pointController.points.where((element) =>
        element.ownerId == _userController.user.value.id &&
        element.type == "STAMP");
    bool active = notarySigns.every((element) => !element.isSigned);
    return Positioned(
        right: 0,
        bottom: 60,
        child: AvatarGlow(
          endRadius: 42.0,
          glowColor: Theme.of(context).primaryColor,
          showTwoGlows: false,
          animate: active,
          duration: Duration(milliseconds: 2500),
          child: BtnSign(
            icon: "69",
            callback: active ? _pointController.addStamp : null,
            isSigned: !active,
          ),
        ));
  }

  Widget _getSign() {
    var notarySigns = _pointController.points.where((element) =>
        element.ownerId == _userController.user.value.id &&
        element.type != "STAMP");
    bool active = notarySigns.every((element) => !element.isSigned);
    return Positioned(
      right: 0,
      bottom: 0,
      child: AvatarGlow(
        endRadius: 42.0,
        glowColor: Theme.of(context).primaryColor,
        showTwoGlows: false,
        animate: active,
        duration: Duration(milliseconds: 2500),
        child: BtnSign(
          icon: "70",
          callback: active ? _pointController.addSign : null,
          isSigned: !active,
        ),
      ),
    );
  }

  Widget _getDoc() {
    return Container(
      width: reSize(58),
      height: reSize(58),
      decoration: BoxDecoration(
        border: Border.all(
          color: _documentIsActive
              ? Color(0xFFFFFFFF)
              : Color(0xFFFFFFFF).withOpacity(0.3),
          width: 2.5,
        ),
        borderRadius: BorderRadius.circular(30),
      ),
      child: InkWell(
        onTap: () => _activateDocument(),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: Container(
            width: reSize(49),
            height: reSize(49),
            decoration: BoxDecoration(
              color: Color(0xFFFFFFFF),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Image.memory(
              base64Decode(
                _sessionController.session.value.images[0],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _getRecipients() {
    return Expanded(
      child: ListView.separated(
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: _recipientController.recipientsForTag.length,
        separatorBuilder: (BuildContext context, int index) =>
            SizedBox(width: reSize(15)),
        itemBuilder: (context, index) {
          return Center(
            child: Container(
              width: reSize(58),
              height: reSize(58),
              decoration: BoxDecoration(
                border: Border.all(
                  color: _recipientController.recipientsForTag[index].color,
                  width: 2.5,
                ),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: Container(
                    width: reSize(49),
                    height: reSize(49),
                    decoration: BoxDecoration(
                      color: Color(0xFFE6E8EE),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Stack(
                      children: [
                        _getParticipant(
                          _recipientController.recipientsForTag[index],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _cancelButton() {
    return Padding(
      padding: const EdgeInsets.only(right: 20),
      child: Column(
        children: [
          TextButton(
            onPressed: () async {
              await _twilioController.onHangup();
              Get.back();
            },
            style: ButtonStyle(
              padding: MaterialStateProperty.all(EdgeInsets.zero),
              overlayColor: MaterialStateProperty.all(
                Color(0xFFFF5454).withOpacity(0.1),
              ),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                  side: BorderSide(color: Color(0xFFFF5454), width: 1),
                ),
              ),
            ),
            child: Container(
              width: reSize(83),
              height: reSize(33),
              child: Center(
                child: Text(
                  "Cancel",
                  style: TextStyle(
                    color: Color(0xFFFF5454),
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: reSize(15))
        ],
      ),
    );
  }

  _activateParticipant(Recipient recipient) {
    _documentIsActive = false;
    _recipientController.activateRecipient(recipient);
    setState(() {});
  }

  _activateDocument() {
    _documentIsActive = true;
    setState(() {});
  }

  _getParticipant(Recipient recipient) {
    ParticipantWidget participant =
        _twilioController.getParticipant(recipient.id);
    if (participant != null) {
      return participant;
    } else {
      return InkWell(
        onTap: () => _activateParticipant(recipient),
        child: Container(
          width: reSize(49),
          height: reSize(49),
          decoration: BoxDecoration(
            color: recipient.color,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Center(
            child: BlackLoading(),
          ),
        ),
      );
    }
  }

  _finishSession() async {
    try {
      print("here");
      await _twilioController.onHangup();
      await _sessionController.finishSession();
      Get.to(
        () => Encryption(),
        transition: Transition.noTransition,
      );
    } catch (err) {
      showError(err);
    }
  }
}
