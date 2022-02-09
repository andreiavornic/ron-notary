import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notary/controllers/session.dart';
import 'package:notary/models/recipient.dart';
import 'package:notary/views/process/recipient_progress.dart';
import 'package:steps_indicator/steps_indicator.dart';

class RecipientWaiting extends StatefulWidget {
  final String recipientId;

  RecipientWaiting(this.recipientId);

  @override
  _RecipientWaitingState createState() => _RecipientWaitingState();
}

class _RecipientWaitingState extends State<RecipientWaiting> {
  SessionController _sessionController = Get.put(
    SessionController(),
  );

  Recipient _recipient;
  int _selectedItem;

  @override
  initState() {
    _selectedItem = 0;
    _recipient = _sessionController.recipients
        .firstWhere((element) => element.id == widget.recipientId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String _formattingState() {
      switch (_recipient.states.last.toUpperCase()) {
        case ("OFFLINE"):
          _selectedItem = 0;
          return "Offline";
        case ("CONNECTED"):
          _selectedItem = 0;
          return "Connected";
        case ("PERSONAL_DATA"):
          _selectedItem = 1;
          return "Connectivity";
        case ("KBA"):
          _selectedItem = 2;
          return "KBA";
        case ("DOCUMENT_IDENTIFY"):
          _selectedItem = 3;
          return "Identity";
        case ("LOGGED"):
          _selectedItem = 4;
          return "Ready";
        default:
          return "Offline";
      }
    }

    return Container(
      width: Get.width,
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
            width: Get.width,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  StepsIndicator(
                    selectedStep: _recipient.states.last == "OFFLINE"
                        ? -1
                        : _selectedItem,
                    nbSteps: 4,
                    doneLineColor: Theme.of(context).primaryColor,
                    undoneLineColor: Color(0xFF29292D).withOpacity(0.08),
                    lineLength: Get.width / 7,
                    selectedStepWidget: Container(
                      width: 30,
                      height: 30,
                      color: Color(0xFFFFFFFF),
                      child: Center(
                        child: Container(
                          width: 14,
                          height: 14,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(7),
                            color: Color(0xFFFFFFFF),
                            border: Border.all(
                              width: 1,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          child: Center(
                            child: Container(
                              width: 7,
                              height: 7,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(7),
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    doneStepWidget: Container(
                      child: Center(
                        child: Container(
                          width: 30,
                          height: 30,
                          color: Color(0xFFFFFFFF),
                          child: Center(
                            child: Container(
                              width: 14,
                              height: 14,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(7),
                                color: Theme.of(context).primaryColor,
                              ),
                              child: Icon(
                                Icons.check,
                                size: 10,
                              ),
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
                          width: 14,
                          height: 14,
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
                          'KBA',
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
                    ],
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 40),
        ],
      ),
    );
  }
}
