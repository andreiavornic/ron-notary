import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:notary/methods/resize_formatting.dart';

class ButtonRecipient extends StatefulWidget {
  final bool isActive;
  final String txt;
  final int icon;
  final Function callback;

  ButtonRecipient({
    this.isActive,
    this.txt,
    this.icon,
    this.callback,
  });

  @override
  _ButtonRecipientState createState() => _ButtonRecipientState();
}

class _ButtonRecipientState extends State<ButtonRecipient> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          TextButton(
            style: ButtonStyle(
              padding: MaterialStateProperty.all(
                EdgeInsets.zero,
              ),
              overlayColor: MaterialStateProperty.all(
                Theme.of(context).colorScheme.secondary.withOpacity(0.1),
              ),
              backgroundColor: MaterialStateProperty.all(
                Color(0xFFF5F6F9),
              ),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(2.0),
                  side: widget.isActive
                      ? BorderSide(
                    color: Color(0xFF161617),
                    width: 1,
                  )
                      : BorderSide(
                    color: Color(0xFFF5F6F9),
                    width: 1,
                  ),
                ),
              ),
            ),
            onPressed: widget.callback,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset('assets/images/${widget.icon}.svg'),
                Text(
                  widget.txt,
                  style: TextStyle(
                    color: Color(0xFF000000),
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          widget.isActive
              ? Positioned(
            right: -5,
            top: 1,
            child: Container(
              width: reSize(14),
              height: reSize(14),
              decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(7),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xFF5B5BFF).withOpacity(0.12),
                      blurRadius: 2,
                    ),
                    BoxShadow(
                      color: Color(0xFF000000).withOpacity(0.04),
                      blurRadius: 1,
                    ),
                  ]),
              child: Center(
                child: Icon(
                  Icons.check,
                  size: 10,
                ),
              ),
            ),
          )
              : Container()
        ],
      ),
    );
  }
}
