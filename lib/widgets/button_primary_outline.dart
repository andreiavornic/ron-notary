import 'package:flutter/material.dart';
import 'package:notary/methods/resize_formatting.dart';

class ButtonPrimaryOutline extends StatelessWidget {
  final Function callback;
  final String text;
  final double width;
  final Color color;

  ButtonPrimaryOutline({
    this.callback,
    this.text,
    this.width,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: ButtonStyle(
        overlayColor: MaterialStateProperty.all(
          color != null
              ? color.withOpacity(0.2)
              : Theme.of(context).accentColor.withOpacity(0.2),
        ),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4.0),
            side: BorderSide(
              color: callback != null
                  ? color != null
                      ? color
                      : Theme.of(context).accentColor
                  : Color(0xFFD1D1D1),
              width: 1,
            ),
          ),
        ),
        textStyle: MaterialStateProperty.all(
          TextStyle(
            color: color != null ? color : Theme.of(context).accentColor,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        padding: MaterialStateProperty.all(
          EdgeInsets.zero,
        ),
      ),
      onPressed: callback,
      child: SizedBox(
        height:  reSize(51),
        width: width != null ? width : MediaQuery.of(context).size.width - 40,
        child: Center(
          child: Text(
            text,
            softWrap: true,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 16,
              color: callback != null
                  ? color != null
                      ? color
                      : Theme.of(context).accentColor
                  : Color(0xFFD1D1D1),
            ),
          ),
        ),
      ),
    );
  }
}
