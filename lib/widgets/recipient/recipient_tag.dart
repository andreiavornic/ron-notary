import 'package:flutter/material.dart';

import 'package:notary/controllers/recipient.dart';
import 'package:notary/methods/resize_formatting.dart';
import 'package:notary/models/recipient.dart';
import 'package:provider/provider.dart';

import '../check_icon.dart';

class RecipientTag extends StatefulWidget {
  final Recipient recipient;
  final Function resetType;

  RecipientTag({this.recipient, this.resetType});

  @override
  _RecipientTagState createState() => _RecipientTagState();
}

class _RecipientTagState extends State<RecipientTag> {
  String _reformType(String type) {
    String formatType = type[0].toUpperCase() + type.substring(1).toLowerCase();
    if (type.toUpperCase() == "NOTARY") formatType += " (You)";
    return formatType;
  }

  activateRecipient() {
    widget.resetType();
    Provider.of<RecipientController>(context, listen: false)
        .activateRecipient(widget.recipient);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      highlightColor: Color(0xFFFFFFFF),
      splashColor: Color(0xFFFFFFFF),
      onTap: activateRecipient,
      child: widget.recipient == null
          ? Container()
          : Padding(
              padding: const EdgeInsets.only(right: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 7, bottom: 2),
                        child: Container(
                          width: reSize(context, 34),
                          height: reSize(context, 34),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: widget.recipient.isActive != null &&
                                    widget.recipient.isActive
                                ? widget.recipient.color
                                : Color(0xFFC4C4C4),
                          ),
                          child: Center(
                            child: Text(
                              "${widget.recipient.firstName[0]} ${widget.recipient.lastName[0]}",
                              style: TextStyle(
                                fontSize: 8,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFFFFFFFF),
                              ),
                            ),
                          ),
                        ),
                      ),
                      widget.recipient.isActive != null &&
                              widget.recipient.isActive
                          ? CheckIcon()
                          : Container(),
                    ],
                  ),
                  SizedBox(
                    height: reSize(context, 7),
                  ),
                  Container(
                    constraints: BoxConstraints(maxWidth: 100),
                    child: Text(
                      "${widget.recipient.firstName} ${widget.recipient.lastName}",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    _reformType(widget.recipient.type),
                    style: TextStyle(
                      color: Color(0xFFC4C4C4),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
