import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:notary/controllers/session.dart';
import 'package:notary/controllers/user.dart';
import 'package:notary/methods/resize_formatting.dart';
import 'package:notary/methods/show_error.dart';
import 'package:notary/models/recipient.dart';
import 'package:notary/models/user.dart';
import 'package:notary/twilio/controller/conference_room.dart';
import 'package:notary/twilio/views/participant.dart';
import 'package:notary/utils/navigate.dart';
import 'package:notary/views/process/widgets/ready_recipient.dart';
import 'package:notary/widgets/black_loading.dart';
import 'package:notary/widgets/btn_sign.dart';
import 'package:notary/widgets/button_primary.dart';
import 'package:notary/widgets/network_connection.dart';
import 'package:notary/widgets/title_page.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:provider/provider.dart';

import '../encrypt.dart';
import 'document_tag_session.dart';

class VideoSession extends StatefulWidget {
  @override
  _VideoSessionState createState() => _VideoSessionState();
}

class _VideoSessionState extends State<VideoSession> {
  bool _documentIsActive;
  List<Recipient> _recipients;
  User _user;
  StreamSubscription _onConferenceRoomException;
  SessionController _sessionController;
  UserController _userController;
  ConferenceRoom _conferenceRoom;
  bool _isSign = false;
  bool _isStamp = false;

  @override
  void initState() {
    _documentIsActive = true;
    _sessionController = Provider.of<SessionController>(context, listen: false);
    _userController = Provider.of<UserController>(context, listen: false);
    _connectToTwilio();
    super.initState();
  }

  void _conferenceRoomUpdated() {
    setState(() {});
  }

  _connectToTwilio() async {
    try {
      final conferenceRoom = ConferenceRoom();
      await conferenceRoom.connect();
      setState(() {
        _conferenceRoom = conferenceRoom;
        _onConferenceRoomException =
            conferenceRoom.onException.listen((err) async {
          await showError(err, context);
        });
        conferenceRoom.addListener(_conferenceRoomUpdated);
      });
    } catch (err) {
      throw err;
    }
  }

  void dispose() async {
    if (_onConferenceRoomException != null) {
      _onConferenceRoomException.cancel();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<SessionController, UserController>(
        builder: (context, _controller, _userController, _) {
      _recipients = _controller.recipients;
      _user = _userController.user;
      return NetworkConnection(
        FocusDetector(
          onFocusGained: () {
            _controller.getSession();
          },
          onVisibilityGained: () {
            _controller.getSession();
          },
          onFocusLost: () {},
          onVisibilityLost: () {},
          onForegroundLost: () {},
          onForegroundGained: () {},
          child: Scaffold(
            body: Container(
              height: StateM(context).height(),
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
                      _cancelButton(context)
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
                                    Column(
                                      children: [
                                        if (_documentIsActive)
                                          Container(
                                            height: 68,
                                          ),
                                        Expanded(
                                          child: _conferenceRoom == null
                                              ? DocumentTagSession()
                                              : _documentIsActive
                                                  ? DocumentTagSession()
                                                  : getActiveParticipant(),
                                        ),
                                      ],
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
                                              height: reSize(context, 81),
                                              width: StateM(context).width() -
                                                  reSize(context, 60),
                                              child: Row(
                                                children: [
                                                  SizedBox(
                                                      width:
                                                          reSize(context, 15)),
                                                  Container(
                                                    width: reSize(context, 58),
                                                    height: reSize(context, 58),
                                                    decoration: BoxDecoration(
                                                      border: Border.all(
                                                        color: _documentIsActive
                                                            ? Color(0xFFFFFFFF)
                                                            : Color(0xFFFFFFFF)
                                                                .withOpacity(
                                                                    0.3),
                                                        width: 2.5,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              30),
                                                    ),
                                                    child: InkWell(
                                                      onTap: () {
                                                        _conferenceRoom
                                                            .activateParticipant(
                                                                null,
                                                                false,
                                                                true);
                                                        _documentIsActive =
                                                            true;
                                                        setState(() {});
                                                      },
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(30),
                                                        child: Container(
                                                          width: reSize(
                                                              context, 49),
                                                          height: reSize(
                                                              context, 49),
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Color(
                                                                0xFFFFFFFF),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        30),
                                                          ),
                                                          child: _controller
                                                                          .session !=
                                                                      null &&
                                                                  _controller
                                                                          .session
                                                                          .images
                                                                          .length >
                                                                      0
                                                              ? Image.memory(
                                                                  base64Decode(
                                                                    _controller
                                                                        .session
                                                                        ?.images[0],
                                                                  ),
                                                                )
                                                              : Container(),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                      width:
                                                          reSize(context, 15)),
                                                  ReadyRecipient(
                                                    callback: () {
                                                      _conferenceRoom
                                                          .activateParticipant(
                                                              Provider.of<UserController>(
                                                                      context,
                                                                      listen:
                                                                          false)
                                                                  .user
                                                                  .id,
                                                              true,
                                                              false);
                                                      _documentIsActive = false;
                                                      setState(() {});
                                                    },
                                                    child: _conferenceRoom
                                                        ?.participants
                                                        ?.firstWhere(
                                                      (element) =>
                                                          !element.isRemote,
                                                      orElse: () =>
                                                          ParticipantWidget(
                                                        child: Container(
                                                          width: reSize(
                                                              context, 58),
                                                          height: reSize(
                                                              context, 58),
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Theme.of(
                                                                    context)
                                                                .primaryColor,
                                                          ),
                                                          child: Center(
                                                            child:
                                                                BlackLoading(),
                                                          ),
                                                        ),
                                                        audioEnabled: false,
                                                        videoEnabled: false,
                                                        isActive: false,
                                                        id: Provider.of<
                                                                    UserController>(
                                                                context,
                                                                listen: false)
                                                            .user
                                                            .id,
                                                        isRemote: false,
                                                      ),
                                                    ),
                                                    color: Theme.of(context)
                                                        .primaryColor,
                                                  ),
                                                  SizedBox(
                                                      width:
                                                          reSize(context, 15)),
                                                  ..._recipients.map(
                                                    (Recipient recipient) =>
                                                        Container(
                                                      child: Row(
                                                        children: [
                                                          ReadyRecipient(
                                                            callback: () {
                                                              _conferenceRoom
                                                                  .activateParticipant(
                                                                      recipient
                                                                          .id,
                                                                      false,
                                                                      false);
                                                              _documentIsActive =
                                                                  false;
                                                            },
                                                            child: _conferenceRoom ==
                                                                    null
                                                                ? Container(
                                                                    width: reSize(
                                                                        context,
                                                                        58),
                                                                    height: reSize(
                                                                        context,
                                                                        58),
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      color: recipient
                                                                          .color,
                                                                    ),
                                                                    child: Center(
                                                                        child:
                                                                            BlackLoading()),
                                                                  )
                                                                : _conferenceRoom
                                                                    .participants
                                                                    .firstWhere(
                                                                    (element) =>
                                                                        element
                                                                            .id ==
                                                                        recipient
                                                                            .id,
                                                                    orElse: () =>
                                                                        new ParticipantWidget(
                                                                      child:
                                                                          Container(
                                                                        width: reSize(
                                                                            context,
                                                                            58),
                                                                        height: reSize(
                                                                            context,
                                                                            58),
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          color:
                                                                              recipient.color,
                                                                        ),
                                                                        child:
                                                                            Center(
                                                                          child:
                                                                              BlackLoading(),
                                                                        ),
                                                                      ),
                                                                      audioEnabled:
                                                                          false,
                                                                      videoEnabled:
                                                                          false,
                                                                      isActive:
                                                                          false,
                                                                      id: recipient
                                                                          .id,
                                                                      isRemote:
                                                                          true,
                                                                    ),
                                                                  ),
                                                            color:
                                                                recipient.color,
                                                          ),
                                                          SizedBox(
                                                              width: reSize(
                                                                  context, 15)),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            width: StateM(context).width() - 40,
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
                  SizedBox(height: reSize(context, 15)),
                  if (getReady())
                    Column(
                      children: [
                        Container(
                          width: StateM(context).width() - 40,
                          decoration: BoxDecoration(
                            color: Color(0xFFF5F6F9),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Row(
                              children: [
                                FaIcon(
                                  FontAwesomeIcons.exclamationCircle,
                                  color: Color(0xFFFC563D),
                                  size: 20,
                                ),
                                SizedBox(width: 10),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Please wait!',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700,
                                        color: Color(0xFF161617),
                                      ),
                                    ),
                                    Container(
                                      child: Text(
                                        'Someone is having connection problems...',
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Color(0xFF161617),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: reSize(context, 15)),
                      ],
                    ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: ButtonPrimary(
                      callback: _controller.points.length == 0
                          ? null
                          : _conferenceRoom == null
                              ? null
                              : _controller.points
                                          .every((point) => point.isSigned) &&
                                      _conferenceRoom.participants.length !=
                                          _controller.recipients.length
                                  ? _finishSession
                                  : null,
                      text: "Finish",
                    ),
                  ),
                  SizedBox(
                      height: StateM(context).height() < 670
                          ? 20
                          : reSize(context, 40)),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  bool getReady() {
    return _conferenceRoom != null &&
        _documentIsActive &&
        _recipients.length + 1 != _conferenceRoom.participants?.length;
  }

  Widget getActiveParticipant() {
    if (_conferenceRoom == null) return DocumentTagSession();
    ParticipantWidget _participant;
    _conferenceRoom.participants.forEach((element) {
      if (element.isActive != null && element.isActive) {
        _participant = element;
        return;
      }
    });
    if (_participant == null) {
      _documentIsActive = true;
      return DocumentTagSession();
    }
    // ParticipantWidget _participant =
    //     _conferenceRoom.participants.firstWhere((element) => element.isActive);
    Recipient _recipient;
    if (_participant.isRemote) {
      _recipient =
          _recipients.firstWhere((element) => element.id == _participant.id);
    } else {
      _recipient = new Recipient(
          firstName: _user.firstName, lastName: _user.lastName, type: "Notary");
    }
    return Stack(
      children: [
        _conferenceRoom.participants.firstWhere((e) => e.isActive),
        if (!_documentIsActive)
          Positioned(
            left: 0,
            bottom: 0,
            child: Container(
              height: reSize(context, 150),
              width: StateM(context).width() - 40,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF000000).withOpacity(0),
                    Color(0xFF000000).withOpacity(1),
                  ],
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 30.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${_recipient.firstName} ${_recipient.lastName}",
                      style: TextStyle(
                        color: Color(0xFFFFFFFF),
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      "${_recipient.type}",
                      style: TextStyle(
                        color: Color(0xFFFFFFFF),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }

  _addStamp() async {
    try {
      _isStamp = true;
      setState(() {});
      await _sessionController.addStamp();
      _isStamp = false;
      setState(() {});
    } catch (err) {
      _isStamp = true;
      setState(() {});
      showError(err, context);
    }
  }

  Widget _getStamp() {
    var notarySigns = _sessionController.points.where((element) =>
        element.ownerId == _userController.user.id && element.type == "STAMP");
    var recipientsSigns = _sessionController.points
        .where((element) => element.ownerType != "NOTARY");

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
          child: _isStamp
              ? Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: Color(0xFFF5F6F9),
                  ),
                  child: Center(
                    child: BlackLoading(),
                  ),
                )
              : BtnSign(
                  icon: "69",
                  callback: active ? _addStamp : null,
                  isSigned: !active,
                ),
        ));
  }

  _addSign() async {
    try {
      _isSign = true;
      setState(() {});
      await _sessionController.addSign();
      _isSign = false;
      setState(() {});
    } catch (err) {
      _isSign = true;
      setState(() {});
      showError(err, context);
    }
  }

  Widget _getSign() {
    var notarySigns = _sessionController.points.where((element) =>
        element.ownerId == _userController.user.id && element.type != "STAMP");

    var recipientsSigns = _sessionController.points
        .where((element) => element.ownerType != "NOTARY");

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
        child: _isSign
            ? Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: Color(0xFFF5F6F9),
                ),
                child: Center(
                  child: BlackLoading(),
                ),
              )
            : BtnSign(
                icon: "70",
                callback: recipientsSigns.every((element) => !element.isSigned)
                    ? null
                    : active
                        ? _addSign
                        : null,
                isSigned: !active,
              ),
      ),
    );
  }

  Widget _cancelButton(ctx) {
    return Padding(
      padding: const EdgeInsets.only(right: 20),
      child: Column(
        children: [
          TextButton(
            onPressed: () async {
              if (_conferenceRoom != null) {
                await _conferenceRoom.disconnect();
                _onConferenceRoomException.cancel();
              }
              StateM(ctx).navBack();
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
              width: reSize(ctx, 83),
              height: reSize(ctx, 33),
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
          SizedBox(height: reSize(ctx, 15))
        ],
      ),
    );
  }

  _finishSession() async {
    try {
      if (_conferenceRoom != null) {
        await _conferenceRoom.disconnect();
        _onConferenceRoomException.cancel();
      }
      await Provider.of<SessionController>(context, listen: false)
          .finishSession();
      StateM(context).navOff(Encryption());
    } catch (err) {
      showError(err, context);
    }
  }
}
