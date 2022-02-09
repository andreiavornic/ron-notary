import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notary/controllers/session.dart';
import 'package:notary/controllers/user.dart';
import 'package:notary/methods/resize_formatting.dart';
import 'package:notary/methods/show_error.dart';
import 'package:notary/models/recipient.dart';
import 'package:notary/services/socket_service.dart';
import 'package:notary/twilio/controller/conference_room.dart';
import 'package:notary/views/process/widgets/ready_recipient.dart';
import 'package:notary/views/process/widgets/waiting_recipient.dart';
import 'package:notary/widgets/btn_sign.dart';
import 'package:notary/widgets/button_primary.dart';
import 'package:notary/widgets/title_page.dart';
import 'package:avatar_glow/avatar_glow.dart';

import '../encrypt.dart';
import 'document_tag_session.dart';

class VideoSession extends StatefulWidget {
  @override
  _VideoSessionState createState() => _VideoSessionState();
}

class _VideoSessionState extends State<VideoSession> {
  SessionController _sessionController = Get.put(SessionController());
  UserController _userController = Get.put(UserController());
  final SocketService _socketService = Get.find<SocketService>();
  ConferenceRoom _conferenceRoom;
  StreamSubscription _onConferenceRoomException;

  bool _documentIsActive;

  @override
  void initState() {
    _documentIsActive = true;
    _connectToTwilio();
    super.initState();

    _socketService.socket.on(
      'UPDATE_POINT',
      (data) {
        print("UPDATE_POINT $data");
        _sessionController.updatePoints(data);
      },
    );
  }

  void _conferenceRoomUpdated() {
    setState(() {});
  }

  _connectToTwilio() async {
    try {
      await _sessionController.processSession();
      String roomName = _sessionController.session.value.twilioRoomName;
      final conferenceRoom = ConferenceRoom(
        name: roomName,
        identity: _userController.user.value.id,
      );
      await conferenceRoom.connect();
      setState(() {
        _conferenceRoom = conferenceRoom;
        _onConferenceRoomException =
            conferenceRoom.onException.listen((err) async {
          await showError(err);
        });
        conferenceRoom.addListener(_conferenceRoomUpdated);
      });
    } catch (err) {
      print("err $err");
    }
  }

  void dispose() async {
    if (_conferenceRoom != null) {
      await _conferenceRoom?.disconnect();
      await _onConferenceRoomException.cancel();
    }
    super.dispose();
  }

  _getRecipe(Recipient recipient) {
    if (_conferenceRoom == null || _conferenceRoom.participants.length == 0) {
      return WaitingRecipient(color: recipient.color);
    }
    if (recipient.id == _userController.user.value.id) {
      return ReadyRecipient(
        callback: () => _activateParticipant(recipient),
        child: _conferenceRoom.participants
            .firstWhere((element) => !element.isRemote)
            .child,
        color: recipient.color,
      );
    }
    int index = _conferenceRoom.participants
        .indexWhere((element) => element.id == recipient.id);
    if (index == -1) {
      return WaitingRecipient(color: recipient.color);
    } else {
      return ReadyRecipient(
        callback: () => _activateParticipant(recipient),
        child: _conferenceRoom.participants[index].child,
        color: recipient.color,
      );
    }
  }

  _getRecipeActive(Recipient recipient) {
    if (_conferenceRoom == null || _conferenceRoom.participants.length == 0) {
      return WaitingRecipient(color: recipient.color);
    }
    if (recipient.id == _userController.user.value.id) {
      return Stack(
        children: [
          _conferenceRoom.participants
              .firstWhere((element) => !element.isRemote)
              .child,
          Positioned(
            left: 0,
            bottom: 0,
            child: Container(
              width: Get.width - 40,
              height: reSize(100),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [0.0, 1.0],
                  colors: [
                    Colors.black.withOpacity(0),
                    Colors.black.withOpacity(1),
                  ],
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${recipient.firstName} ${recipient.lastName}",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 3),
                    Text(
                      "${recipient.type}",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      );
    }
    int index = _conferenceRoom.participants
        .indexWhere((element) => element.id == recipient.id);
    if (index == -1) {
      return WaitingRecipient(color: recipient.color);
    } else {
      return Stack(
        children: [
          _conferenceRoom.participants[index].child,
          Positioned(
            left: 0,
            bottom: 0,
            child: Container(
              width: Get.width - 40,
              height: reSize(100),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [0.0, 1.0],
                  colors: [
                    Colors.black.withOpacity(0),
                    Colors.black.withOpacity(1),
                  ],
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${recipient.firstName} ${recipient.lastName}",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 3),
                    Text(
                      "${recipient.type}",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    )
                  ],
                ),
              ),
            ),
          )
        ],
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
                                          child: DocumentTagSession()),
                                    )
                                  : Container(
                                      width: Get.width - 40,
                                      child: Center(
                                        child: _getRecipeActive(
                                            _sessionController.recipientVideo
                                                .firstWhere((element) =>
                                                    element.isActive)),
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
                                        width: Get.width - reSize(60),
                                        child: Row(
                                          children: [
                                            SizedBox(width: reSize(15)),
                                            _getDoc(),
                                            SizedBox(width: reSize(15)),
                                            _listRecipients(_sessionController
                                                .recipientVideo)
                                          ],
                                        ),
                                      ),
                                      width: Get.width - 40,
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
                              if (_documentIsActive) _getStamp(),
                              if (_documentIsActive) _getSign(),
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
            GetBuilder<SessionController>(builder: (_controller) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ButtonPrimary(
                  callback: _controller.points.length == 0
                      ? null
                      : _controller.points.every((point) => point.isSigned)
                          ? _finishSession
                          : null,
                  text: "Finish",
                ),
              );
            }),
            SizedBox(height: Get.height < 670 ? 20 : reSize(40)),
          ],
        ),
      ),
    );
  }

  Widget _getStamp() {
    return GetBuilder<SessionController>(builder: (_controller) {
      var notarySigns = _controller.points.where((element) =>
          element.ownerId == _userController.user.value.id &&
          element.type == "STAMP");
      var recipientsSigns =
          _controller.points.where((element) => element.ownerType != "NOTARY");

      bool active = recipientsSigns.every((element) => element.isSigned)
          ? notarySigns.every((element) => !element.isSigned)
          : false;
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
              callback: active ? _controller.addStamp : null,
              isSigned: !active,
            ),
          ));
    });
  }

  Widget _getSign() {
    return GetBuilder<SessionController>(builder: (_controller) {
      var notarySigns = _controller.points.where((element) =>
          element.ownerId == _userController.user.value.id &&
          element.type != "STAMP");

      var recipientsSigns =
          _controller.points.where((element) => element.ownerType != "NOTARY");

      bool active = recipientsSigns.every((element) => element.isSigned)
          ? notarySigns.every((element) => !element.isSigned)
          : false;
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
            callback: recipientsSigns.every((element) => !element.isSigned)
                ? null
                : active
                    ? _controller.addSign
                    : null,
            isSigned: !active,
          ),
        ),
      );
    });
  }

  Widget _listRecipients(List<Recipient> recipients) {
    return Expanded(
      child: ListView.separated(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: _sessionController.recipientVideo.length,
          separatorBuilder: (BuildContext context, int index) =>
              SizedBox(width: reSize(15)),
          itemBuilder: (context, index) {
            return Center(
              child: _conferenceRoom != null
                  ? _getRecipe(recipients[index])
                  : WaitingRecipient(
                      color: recipients[index].color,
                    ),
            );
          }),
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
            child: _sessionController.session.value != null &&
                    _sessionController.session.value.images.length > 0
                ? Image.memory(
                    base64Decode(
                      _sessionController.session?.value?.images[0],
                    ),
                  )
                : Container(),
          ),
        ),
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
              await _conferenceRoom?.disconnect();
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
    _sessionController.activateRecipient(recipient);
    setState(() {});
  }

  _activateDocument() {
    _documentIsActive = true;
    setState(() {});
  }

  _finishSession() async {
    try {
      _socketService.socket.disconnect();
      await _sessionController.finishSession();
      Get.offAll(
        () => Encryption(),
        transition: Transition.noTransition,
      );
    } catch (err) {
      showError(err);
    }
  }
}
