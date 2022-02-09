import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:notary/controllers/session.dart';
import 'package:notary/controllers/user.dart';
import 'package:notary/models/point.dart';

import 'get_stamp.dart';

class TouchTagPart extends StatefulWidget {
  final String text;
  final Point point;
  final double imgWidth;

  TouchTagPart({
    this.point,
    this.text,
    this.imgWidth,
  });

  @override
  _TouchTagPartState createState() => _TouchTagPartState();
}

class _TouchTagPartState extends State<TouchTagPart> {
  UserController _userController = Get.put(UserController());
  SessionController _sessionController = Get.put(SessionController());

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: widget.point.type == "STAMP"
            ? GetStamp(widget.point)
            : widget.point.isSigned
                ? Text(
                    "${widget.point.value}",
                    style: TextStyle(
                      fontSize: 6,
                      fontFamily: widget.point.ownerType == "NOTARY"
                          ? _userController.getTypeFont().fontFamily
                          : _sessionController.getTypeFont(widget.point.ownerId).fontFamily,
                    ),
                  )
                : Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(2),
                      border: Border.all(
                        color: widget.point.color,
                        width: 1,
                      ),
                      color: widget.point.isChecked
                          ? widget.point.color.withOpacity(0.6)
                          : widget.point.color.withOpacity(0.15),
                    ),
                    child: _getIcon(widget.point)),
      ),
    );
  }

  Widget _getIcon(Point point) {
    int icon = 60;

    if (point.type == "INITIAL") {
      icon = 64;
    } else if (point.type == "DATE") {
      icon = 62;
    } else if (point.type == "STAMP") {
      icon = 61;
    } else if (point.type == "TEXTBOX") {
      icon = 63;
    }

    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.all(2.0),
          child: SvgPicture.asset(
            'assets/images/$icon.svg',
            color: widget.point.color,
            width: 18,
          ),
        ),
        Text(
          widget.text != null ? widget.text : widget.point.value,
          style: TextStyle(
            fontSize: 12,
            color: Colors.transparent,
          ),
        ),
      ],
    );
  }
}
