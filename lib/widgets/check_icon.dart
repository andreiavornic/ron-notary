import 'package:flutter/material.dart';

class CheckIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 3,
      bottom: 0,
      child: Container(
        width: 14,
        height: 14,
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(7),
          border: Border.all(
            color: Color(0xFFFFFFFF),
            width: 1.5,
          ),
        ),
        child: Center(
          child: Icon(
            Icons.check,
            size: 8,
            color: Theme.of(context).accentColor,
          ),
        ),
      ),
    );
  }
}
