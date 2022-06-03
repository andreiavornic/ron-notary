import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:notary/controllers/session.dart';
import 'package:notary/methods/resize_formatting.dart';
import 'package:notary/models/recipient.dart';
import 'package:notary/utils/navigate.dart';
import 'package:notary/views/process/recipient_progress.dart';
import 'package:notary/widgets/button_primary.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import 'package:steps_indicator/steps_indicator.dart';

class RecipientWaiting extends StatefulWidget {
  final String recipientId;

  RecipientWaiting(this.recipientId);

  @override
  _RecipientWaitingState createState() => _RecipientWaitingState();
}

class _RecipientWaitingState extends State<RecipientWaiting> {
  Recipient _recipient;
  int _selectedItem;
  SessionController _sessionController;

  @override
  initState() {
    _selectedItem = 0;
    _sessionController = Provider.of<SessionController>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String _formattingState() {
      switch (_recipient.states.last.toUpperCase()) {
        case ("OFFLINE"):
          _selectedItem = 0;
          return "Offline";
        case ("CONNECTIVITY"):
          _selectedItem = 0;
          return "Connected";
        case ("PERSONAL_DATA"):
          _selectedItem = 1;
          return "Connectivity";
        case ("DOCUMENT_IDENTIFY"):
          _selectedItem = 2;
          return "Identity";
        case ("KBA"):
          _selectedItem = 3;
          return "KBA";
        case ("LOGGED"):
          _selectedItem = 4;
          return "Ready";
        default:
          return "Offline";
      }
    }

    return Consumer<SessionController>(builder: (context, _controller, _) {
      _recipient = _controller.recipients
          .firstWhere((element) => element.id == widget.recipientId);
      return Container(
        width: StateM(context).width(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 30),
            RecipientStatus(
              recipient: _recipient,
              progress:
                  _recipient.states.last == "OFFLINE" ? 0 : _selectedItem + 1,
            ),
            SizedBox(height: 30),
            Text(
              '${_recipient.firstName} ${_recipient.lastName}',
              style: TextStyle(
                color: Theme.of(context).colorScheme.secondary,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _formattingState(),
                  style: TextStyle(
                    color: Color(0xFF494949),
                    fontSize: 12,
                  ),
                ),
                SizedBox(width: 5),
                Row(
                  children: [
                    for (int i = 0; i < 3; i++)
                      Row(
                        children: [
                          Container(
                            width: 4,
                            height: 4,
                            decoration: BoxDecoration(
                              color: Color(0xFF494949),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          SizedBox(width: 3),
                        ],
                      )
                  ],
                )
              ],
            ),
            SizedBox(height: 30),
            Container(
              width: StateM(context).width(),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    StepsIndicator(
                      selectedStep: _recipient.states.last == "OFFLINE"
                          ? -1
                          : _selectedItem,
                      nbSteps: 4,
                      doneLineColor: Theme.of(context).colorScheme.secondary,
                      undoneLineColor: Color(0xFF29292D).withOpacity(0.08),
                      lineLength: StateM(context).width() / 7,
                      selectedStepWidget: Container(
                        width: 30,
                        height: 30,
                        color: Color(0xFFFFFFFF),
                        child: Center(
                          child: Container(
                            width: 15,
                            height: 15,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(7),
                              color: Color(0xFFFFFFFF),
                              border: Border.all(
                                width: 1,
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                            ),
                            child: Center(
                              child: Container(
                                width: 7,
                                height: 7,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(7),
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      doneStepWidget: Container(
                        width: 30,
                        height: 30,
                        color: Color(0xFFFFFFFF),
                        child: Center(
                          child: Container(
                            width: 15,
                            height: 15,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(7),
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                            child: Center(
                              child: Container(
                                width: 7,
                                height: 7,
                                child:
                                    SvgPicture.asset("assets/images/123.svg"),
                              ),
                            ),
                          ),
                        ),
                      ),
                      unselectedStepWidget: Container(
                        width: 30,
                        height: 30,
                        color: Color(0xFFFFFFFF),
                        child: Center(
                          child: Container(
                            width: 15,
                            height: 15,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(7),
                              border: Border.all(
                                width: 1,
                                color: Color(0xFF4B4D56).withOpacity(0.29),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 2),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Text(
                            'Connected',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color(0xFFADAEAF),
                              fontSize: 12,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            'Connectivity',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color(0xFFADAEAF),
                              fontSize: 12,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            'Identity',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color(0xFFADAEAF),
                              fontSize: 12,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            'KBA',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color(0xFFADAEAF),
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: reSize(context, 20)),
            Container(
              width: StateM(context).width() - 40,
              decoration: BoxDecoration(
                  color: Color(0xFFF5F6F9),
                  borderRadius: BorderRadius.circular(6)),
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    Text(
                      "This Code was sent to all participants.\nYou may share it again",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFF999999),
                        fontSize: 12,
                      ),
                    ),
                    SizedBox(height: reSize(context, 20)),
                    Text(
                      _sessionController.session.sessionToken,
                      style: TextStyle(
                          color: Color(0xFF161617),
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 5),
                    ),
                    SizedBox(height: reSize(context, 20)),
                    ButtonPrimary(
                      text: "Share",
                      callback: _shareToken,
                    )
                  ],
                ),
              ),
            ),
            SizedBox(height: reSize(context, 20)),
          ],
        ),
      );
    });
  }

  _shareToken() {
    Share.share(
      'Please enter session code: ${_sessionController.session.sessionToken}',
      subject: 'Session Token',
    );
  }
}
