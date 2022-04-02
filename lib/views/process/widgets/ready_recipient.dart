import 'package:flutter/material.dart';
import 'package:notary/methods/resize_formatting.dart';

class ReadyRecipient extends StatelessWidget {
  final Widget child;
  final Color color;
  final Function callback;

  const ReadyRecipient({Key key, this.child, this.color, this.callback})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: reSize(context, 58),
      height: reSize(context, 58),
      decoration: BoxDecoration(
        border: Border.all(
          color: color,
          width: 2.5,
        ),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Center(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: Container(
            width: reSize(context, 49),
            height: reSize(context, 49),
            decoration: BoxDecoration(
              color: Color(0xFFE6E8EE),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Stack(
              children: [
                if (child != null) child,
                InkWell(
                  onTap: callback,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
