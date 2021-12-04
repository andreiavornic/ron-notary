import 'package:flutter/material.dart';
import 'package:notary/models/recipient.dart';
import "dart:math" show pi;


class RecipientStatus extends StatefulWidget {
  final Recipient recipient;
  final int progress;

  RecipientStatus({
    this.recipient,
    this.progress,
  });

  @override
  _RecipientStatusState createState() => _RecipientStatusState();
}

class _RecipientStatusState extends State<RecipientStatus> {
  bool _getReadyRecipient() {
    return widget.recipient.states.contains('LOGGED');
  }

  @override
  Widget build(BuildContext context) {

    return Container(
      width: 48,
      child: Stack(
        children: [
          Container(
            width: 48,
            height: 48,
            child: Container(
              width: 46,
              height: 46,
              color: Color(0xFFFFFFFF),
              child: Center(
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    color: widget.recipient.color,
                  ),
                  child: Center(
                    child: Text(
                      "${widget.recipient.firstName[0]} ${widget.recipient.lastName[0]}",
                      style: TextStyle(
                        color: Color(0xFFFFFFFF),
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          widget.progress != 0 && widget.progress != null
              ? Transform.rotate(
            angle: -120 * pi / 180,
            child: ShaderMask(
              shaderCallback: (rect) {
                return SweepGradient(
                  startAngle: 0,
                  endAngle: (16 * widget.progress).toDouble(),
                  stops: [0.1, 0.1],
                  colors: [
                    widget.recipient.color,
                    Color(0xFFFFFFFF),
                  ],
                ).createShader(rect);
              },
              child: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  // color: widget.recipient.color,
                  border: Border.all(
                    color: _getReadyRecipient()
                        ? widget.recipient.color
                        : Color(0xFFFFFFFF),
                    width: 1.5,
                  ),
                ),
              ),
            ),
          )
              : Container(),
        ],
      ),
    );
  }
}
