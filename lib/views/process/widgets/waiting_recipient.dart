import 'package:flutter/material.dart';
import 'package:notary/methods/resize_formatting.dart';
import 'package:notary/widgets/black_loading.dart';

class WaitingRecipient extends StatelessWidget {
  final Color color;

  const WaitingRecipient({Key key, this.color}) : super(key: key);

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
              color: color,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Center(child: BlackLoading()),
          ),
        ),
      ),
    );
  }
}
