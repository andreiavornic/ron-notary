import 'package:flutter/material.dart';
import 'package:notary/methods/resize_formatting.dart';
import 'package:notary/models/recipient.dart';
import 'package:notary/views/process/recipient_waiting.dart';
import 'package:notary/widgets/check_icon.dart';
import 'package:notary/widgets/modals/modal_container.dart';

class RecipientStatus extends StatelessWidget {
  final Recipient recipient;

  RecipientStatus(this.recipient);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      highlightColor: Color(0xFFFFFFFF),
      splashColor: Color(0xFFFFFFFF),
      onTap: () => modalContainer(
        RecipientWaiting(recipient.id),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 7, bottom: 2),
                child: Container(
                  width: reSize(34),
                  height: reSize(34),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: recipient.color,
                  ),
                  child: Center(
                    child: Text(
                      '${recipient.firstName[0]} ${recipient.lastName[0]}'
                          .toUpperCase(),
                      style: TextStyle(
                          color: Color(0xFFFFFFFF),
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          letterSpacing: -1.3),
                    ),
                  ),
                ),
              ),
              recipient?.states?.last == "LOGGED" ? CheckIcon() : Container(),
            ],
          ),
          SizedBox(height: reSize(8)),
          Container(
            constraints: BoxConstraints(maxWidth: 120),
            child: Text(
              '${recipient.firstName} ${recipient.lastName}',
              style: TextStyle(
                color: Theme.of(context).colorScheme.secondary,
                fontSize: reSize(14),
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SizedBox(height: reSize(2)),
          Text(
            _formattingState(),
            style: TextStyle(
              color: Color(0xFFADAEAF),
              fontSize: reSize(12),
            ),
          ),
        ],
      ),
    );
  }

  String _formattingState() {
    switch (recipient.states.last.toUpperCase()) {
      case ("CONNECTIVITY"):
        return "Connected";
      case ("PERSONAL_DATA"):
        return "Connectivity";
      case ("KBA"):
        return "KBA";
      case ("DOCUMENT_IDENTIFY"):
        return "Identity";
      case ("PREPARE"):
        return "Prepare";
      case ("LOGGED"):
        return "Ready";
      default:
        return "Offline";
    }
  }
}
